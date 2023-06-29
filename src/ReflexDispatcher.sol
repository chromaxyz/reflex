// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexDispatcher} from "./interfaces/IReflexDispatcher.sol";
import {IReflexInstaller} from "./interfaces/IReflexInstaller.sol";
import {IReflexModule} from "./interfaces/IReflexModule.sol";

// Sources
import {ReflexEndpoint} from "./ReflexEndpoint.sol";
import {ReflexState} from "./ReflexState.sol";

/**
 * @title Reflex Dispatcher
 *
 * @dev Execution takes place within the Dispatcher's storage context.
 * @dev Non-upgradeable, extendable.
 */
abstract contract ReflexDispatcher is IReflexDispatcher, ReflexState {
    // ===========
    // Constructor
    // ===========

    /**
     * @param owner_ Protocol owner.
     * @param installerModule_ Installer module address.
     */
    constructor(address owner_, address installerModule_) {
        // Initialize the global reentrancy guard as unlocked.
        _REFLEX_STORAGE().reentrancyStatus = _REENTRANCY_GUARD_UNLOCKED;

        // Verify that the `owner_` and `installerModule_` addresses are valid.
        if (owner_ == address(0) || installerModule_ == address(0)) revert ZeroAddress();

        // Verify that the `Installer` module configuration is as expected.
        IReflexModule.ModuleSettings memory moduleSettings_ = IReflexInstaller(installerModule_).moduleSettings();

        if (moduleSettings_.moduleId != _MODULE_ID_INSTALLER) revert ModuleIdInvalid(moduleSettings_.moduleId);
        if (moduleSettings_.moduleType != _MODULE_TYPE_SINGLE_ENDPOINT)
            revert ModuleTypeInvalid(moduleSettings_.moduleType);

        // Initialize the owner.
        _REFLEX_STORAGE().owner = owner_;

        // Register the built-in `Installer` module.
        _REFLEX_STORAGE().modules[_MODULE_ID_INSTALLER] = installerModule_;

        // Fetch the endpoint implementation creation code for the `Installer` module.
        bytes memory endpointCreationCode = _getEndpointCreationCode(_MODULE_ID_INSTALLER);

        // Create and register the `Installer` endpoint.
        address endpointAddress;

        assembly ("memory-safe") {
            endpointAddress := create(0, add(endpointCreationCode, 0x20), mload(endpointCreationCode))

            // If the code size of `endpointAddress_` is zero, revert.
            if iszero(extcodesize(endpointAddress)) {
                // Store the function selector of `EndpointInvalid()`.
                mstore(0x00, 0x0b3b0bd1)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }
        }

        _REFLEX_STORAGE().endpoints[_MODULE_ID_INSTALLER] = endpointAddress;

        _REFLEX_STORAGE().relations[endpointAddress] = TrustRelation({
            moduleId: _MODULE_ID_INSTALLER,
            moduleType: _MODULE_TYPE_SINGLE_ENDPOINT,
            moduleImplementation: installerModule_
        });

        emit EndpointCreated(_MODULE_ID_INSTALLER, endpointAddress);
        emit OwnershipTransferred(address(0), owner_);
        emit ModuleAdded(_MODULE_ID_INSTALLER, installerModule_, IReflexInstaller(installerModule_).moduleVersion());
    }

    // ============
    // View methods
    // ============

    /**
     * @inheritdoc IReflexDispatcher
     */
    function getModuleImplementation(uint32 moduleId_) public view virtual returns (address) {
        return _REFLEX_STORAGE().modules[moduleId_];
    }

    /**
     * @inheritdoc IReflexDispatcher
     */
    function getEndpoint(uint32 moduleId_) public view virtual returns (address) {
        return _REFLEX_STORAGE().endpoints[moduleId_];
    }

    /**
     * @inheritdoc IReflexDispatcher
     */
    function getTrustRelation(address endpoint_) public view virtual returns (TrustRelation memory) {
        return _REFLEX_STORAGE().relations[endpoint_];
    }

    // ================
    // Fallback methods
    // ================

    /**
     * @notice Dispatch call to module implementation.
     */
    // solhint-disable-next-line payable-fallback, no-complex-fallback
    fallback() external virtual {
        uint32 moduleId = _REFLEX_STORAGE().relations[msg.sender].moduleId;

        if (moduleId == 0) revert CallerNotTrusted();

        address moduleImplementation = _REFLEX_STORAGE().relations[msg.sender].moduleImplementation;

        if (moduleImplementation == address(0)) moduleImplementation = _REFLEX_STORAGE().modules[moduleId];

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

    // ============
    // Hook methods
    // ============

    /**
     * @notice Hook that is called upon creation of an endpoint to get its implementation.
     * @dev This method may be overridden to customize the endpoint implementation.
     * To override the `Installer` endpoint implementation you override this method in your `Dispatcher` contract.
     * @param moduleId_ Module id.
     * @return endpointCreationCode_ Endpoint creation code.
     */
    function _getEndpointCreationCode(uint32 moduleId_) internal virtual returns (bytes memory endpointCreationCode_) {
        endpointCreationCode_ = abi.encodePacked(type(ReflexEndpoint).creationCode, abi.encode(moduleId_));
    }
}
