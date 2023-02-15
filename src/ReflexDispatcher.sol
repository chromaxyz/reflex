// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexDispatcher} from "./interfaces/IReflexDispatcher.sol";
import {IReflexInstaller} from "./interfaces/IReflexInstaller.sol";
import {IReflexModule} from "./interfaces/IReflexModule.sol";

// Sources
import {ReflexBase} from "./ReflexBase.sol";
import {ReflexProxy} from "./ReflexProxy.sol";

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
        // Initialize the global reentrancy lock.
        _reentrancyLock = _REENTRANCY_LOCK_UNLOCKED;

        if (owner_ == address(0)) revert InvalidOwner();
        if (installerModule_ == address(0)) revert InvalidModuleAddress();

        // Verify that the `Installer` module configuration is as expected.
        IReflexModule.ModuleSettings memory moduleSettings_ = IReflexInstaller(installerModule_).moduleSettings();

        if (moduleSettings_.moduleId != _MODULE_ID_INSTALLER) revert InvalidModuleId();
        if (moduleSettings_.moduleType != _MODULE_TYPE_SINGLE_PROXY) revert InvalidModuleType();

        // Initialize the owner.
        _owner = owner_;

        // Register the built-in `Installer` module.
        _modules[_MODULE_ID_INSTALLER] = installerModule_;

        // Create and register the `Installer` proxy.
        _createProxy(moduleSettings_.moduleId, moduleSettings_.moduleType, installerModule_);

        emit OwnershipTransferred(address(0), owner_);
        emit ModuleAdded(_MODULE_ID_INSTALLER, installerModule_, IReflexInstaller(installerModule_).moduleVersion());
    }

    // ============
    // View methods
    // ============

    /**
     * @notice Returns the module implementation address by module id.
     * @param moduleId_ Module id.
     * @return address Module implementation address.
     */
    function moduleIdToModuleImplementation(uint32 moduleId_) external view virtual override returns (address) {
        return _modules[moduleId_];
    }

    /**
     * @notice Returns the proxy address by module id.
     * @param moduleId_ Module id.
     * @return address Proxy address.
     */
    function moduleIdToProxy(uint32 moduleId_) external view virtual override returns (address) {
        return _proxies[moduleId_];
    }

    // ================
    // Fallback methods
    // ================

    /**
     * @notice Dispatch call to module implementation.
     */
    fallback() external virtual reentrancyAllowed {
        uint32 moduleId = _relations[msg.sender].moduleId;
        address moduleImplementation = _relations[msg.sender].moduleImplementation;

        if (moduleId == 0) revert CallerNotTrusted();

        if (moduleImplementation == address(0)) moduleImplementation = _modules[moduleId];

        // Message length >= (4 + 20)
        // 4 bytes for selector used to call the proxy.
        // 20 bytes for the trailing msg.sender.
        if (msg.data.length < 24) revert MessageTooShort();

        // [dispatch() selector (4 bytes)][calldata (N bytes)][msg.sender (20 bytes)]
        assembly {
            // We take full control of memory in this inline assembly block because it will not return to Solidity code.

            // Copy msg.data into memory, starting at position 0.
            calldatacopy(0x00, 0x00, calldatasize())

            // Append proxy address to copied msg.data in memory, prepended by 12 bytes.
            mstore(calldatasize(), shl(96, caller()))

            // Calldata: [original calldata (N bytes)][original msg.sender (20 bytes)][proxy address (20 bytes)]
            let result := delegatecall(gas(), moduleImplementation, 0, add(calldatasize(), 20), 0, 0)

            // Copy the returned data into memory, starting at position 0.
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
