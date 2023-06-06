// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexDispatcher} from "./interfaces/IReflexDispatcher.sol";
import {IReflexInstaller} from "./interfaces/IReflexInstaller.sol";
import {IReflexModule} from "./interfaces/IReflexModule.sol";

// Sources
import {ReflexBase} from "./ReflexBase.sol";

/**
 * @title Reflex Dispatcher
 *
 * @dev Non-upgradeable, extendable.
 */
abstract contract ReflexDispatcher is IReflexDispatcher, ReflexBase {
    // ===========
    // Constructor
    // ===========

    /**
     * @param owner_ Protocol owner.
     * @param installerModule_ Installer module address.
     */
    constructor(address owner_, address installerModule_) {
        // Initialize the global reentrancy guard as unlocked.
        _reentrancyStatus = _REENTRANCY_GUARD_UNLOCKED;

        if (owner_ == address(0) || installerModule_ == address(0)) revert ZeroAddress();

        // Verify that the `Installer` module configuration is as expected.
        IReflexModule.ModuleSettings memory moduleSettings_ = IReflexInstaller(installerModule_).moduleSettings();

        if (moduleSettings_.moduleId != _MODULE_ID_INSTALLER) revert ModuleIdInvalid();
        if (moduleSettings_.moduleType != _MODULE_TYPE_SINGLE_ENDPOINT) revert ModuleTypeInvalid();

        // Initialize the owner.
        _owner = owner_;

        // Register the built-in `Installer` module.
        _modules[_MODULE_ID_INSTALLER] = installerModule_;

        // Create and register the `Installer` endpoint.
        _createEndpoint(moduleSettings_.moduleId, moduleSettings_.moduleType, installerModule_);

        emit OwnershipTransferred(address(0), owner_);
        emit ModuleAdded(_MODULE_ID_INSTALLER, installerModule_, IReflexInstaller(installerModule_).moduleVersion());
    }

    // ============
    // View methods
    // ============

    /**
     * @inheritdoc IReflexDispatcher
     */
    function moduleIdToModuleImplementation(uint32 moduleId_) public view virtual returns (address) {
        return _modules[moduleId_];
    }

    /**
     * @inheritdoc IReflexDispatcher
     */
    function moduleIdToEndpoint(uint32 moduleId_) public view virtual returns (address) {
        return _endpoints[moduleId_];
    }

    // ================
    // Fallback methods
    // ================

    /**
     * @notice Dispatch call to module implementation.
     */
    // solhint-disable-next-line payable-fallback, no-complex-fallback
    fallback() external virtual reentrancyAllowed {
        uint32 moduleId = _relations[msg.sender].moduleId;
        address moduleImplementation = _relations[msg.sender].moduleImplementation;

        if (moduleId == 0) revert CallerNotTrusted();

        if (moduleImplementation == address(0)) moduleImplementation = _modules[moduleId];

        // Message length >= (4 + 20)
        // 4 bytes for selector used to call the endpoint.
        // 20 bytes for the trailing `msg.sender`.
        if (msg.data.length < 24) revert MessageTooShort();

        // [calldata (N bytes)][msg.sender (20 bytes)]
        assembly {
            // We take full control of memory in this inline assembly block because it will not return to Solidity code.

            // Copy `msg.data` into memory, starting at position `0`.
            calldatacopy(0x00, 0x00, calldatasize())

            // Append endpoint address with leading 12 bytes of padding removed to copied `msg.data` in memory.
            mstore(calldatasize(), shl(96, caller()))

            // Calldata: [original calldata (N bytes)][original msg.sender (20 bytes)][endpoint address (20 bytes)]
            let result := delegatecall(gas(), moduleImplementation, 0, add(calldatasize(), 20), 0, 0)

            // Copy the returned data into memory, starting at position `0`.
            returndatacopy(0x00, 0x00, returndatasize())

            switch result
            case 0 {
                // If result is 0, revert.
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
}
