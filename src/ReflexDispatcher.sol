// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexDispatcher} from "./interfaces/IReflexDispatcher.sol";
import {IReflexInstaller} from "./interfaces/IReflexInstaller.sol";
import {IReflexModule} from "./interfaces/IReflexModule.sol";

// Sources
import {ReflexEndpoint} from "./ReflexEndpoint.sol";
import {ReflexStorage} from "./ReflexStorage.sol";

/**
 * @title Reflex Dispatcher
 *
 * @dev The `Dispatcher` will take a call from a trusted `Endpoint`, look up the associated module and `DELEGATECALL`
 * to the module with the `endpoint address` appended to the calldata. This calldata already includes the original
 * `msg.sender` address appended in the `Endpoint` contract.
 *
 * @dev Execution takes place within the Dispatchers' storage context.
 * @dev Non-upgradeable, extendable.
 */
abstract contract ReflexDispatcher is IReflexDispatcher, ReflexStorage {
    // ===========
    // Constructor
    // ===========

    /**
     * @param owner_ Contract owner.
     * @param installerModule_ Installer module address.
     */
    constructor(address owner_, address installerModule_) {
        // Initialize the global reentrancy guard as unlocked.
        _REFLEX_STORAGE().reentrancyStatus = _REENTRANCY_GUARD_UNLOCKED;

        // Verify that the `owner_` and `installerModule_` addresses are valid.
        if (owner_ == address(0) || installerModule_ == address(0)) revert ZeroAddress();

        // Verify that the `Installer` module configuration is as expected.
        IReflexModule.ModuleSettings memory moduleSettings_ = IReflexInstaller(installerModule_).moduleSettings();

        if (moduleSettings_.moduleId != _MODULE_ID_INSTALLER) revert ModuleIdInvalid();
        if (moduleSettings_.moduleType != _MODULE_TYPE_SINGLE_ENDPOINT) revert ModuleTypeInvalid();

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
            moduleImplementation: installerModule_
        });

        emit EndpointCreated(_MODULE_ID_INSTALLER, endpointAddress);
        emit OwnershipTransferred(address(0), owner_);
        emit ModuleAdded(_MODULE_ID_INSTALLER, installerModule_);
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
     * @dev Dispatch call to module implementation.
     */
    // solhint-disable-next-line payable-fallback, no-complex-fallback
    fallback() external virtual {
        // We take full control of memory because it will not return to Solidity code.
        // [calldata (N bytes)][msg.sender (20 bytes)]
        assembly {
            // Revert if calldata is less than 24 bytes:
            // - 4 bytes for selector used to call the endpoint
            // - 20 bytes for the trailing `msg.sender`.
            if lt(calldatasize(), 24) {
                // Store the function selector of `MessageTooShort()`.
                mstore(0x00, 0x7f5e6be5)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }

            // Load the relation of the `msg.sender` from storage.
            // Store the `msg.sender` at memory position `0`.
            mstore(0x00, caller())
            // Store the relations slot at memory position `32`.
            mstore(0x20, _REFLEX_STORAGE_RELATIONS_SLOT)
            // Load the relation by `msg.sender` from storage.
            let relation := sload(keccak256(0x00, 0x40))

            // Get module id from `relation` by extracting the lower 4 bytes.
            let moduleId := and(relation, 0xffffffff)

            // Revert if module id is `0`.
            // This happens when the caller is not a trusted endpoint.
            if iszero(moduleId) {
                // Store the function selector of `CallerNotTrusted()`.
                mstore(0x00, 0xe9cda707)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }

            // Get module implementation from `relation` by extracting the lower 20 bytes after shifting.
            let moduleImplementation := and(shr(32, relation), 0xffffffffffffffffffffffffffffffffffffffff)

            // If module implementation is 0, load the module implementation from the modules mapping.
            // This is the case for multi-endpoint modules.
            if iszero(moduleImplementation) {
                // Store the module id at memory position `0`.
                mstore(0x00, moduleId)
                // Store the module id slot at memory position `32`.
                mstore(0x20, _REFLEX_STORAGE_MODULES_SLOT)
                // Load the module implementation from storage.
                moduleImplementation := sload(keccak256(0x00, 0x40))
            }

            // Revert if module implementation is still 0, this happens when the
            // multi-module implementation has not been registered yet but the endpoint has been registered.
            // If not caught a delegatecall to `address(0)` would be made which could have potential side-effects.
            if iszero(moduleImplementation) {
                // Store the function selector of `ModuleNotRegistered()`.
                mstore(0x00, 0x9c4aee9e)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }

            // Copy `msg.data` into memory, starting at position `0`.
            calldatacopy(0x00, 0x00, calldatasize())

            // Append endpoint address with leading 12 bytes of padding removed to copied `msg.data` in memory.
            mstore(calldatasize(), shl(96, caller()))

            // Calldata: [original calldata (N bytes)][original msg.sender (20 bytes)][endpoint address (20 bytes)]
            let success := delegatecall(gas(), moduleImplementation, 0, add(calldatasize(), 20), 0, 0)

            // Copy the returned data into memory, starting at position `0`.
            returndatacopy(0x00, 0x00, returndatasize())

            switch success
            case 0 {
                // If success is 0, revert.
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
     * @return endpointCreationCode_ Endpoint creation code.
     */
    function _getEndpointCreationCode(uint32) internal virtual returns (bytes memory endpointCreationCode_) {
        endpointCreationCode_ = type(ReflexEndpoint).creationCode;
    }
}
