// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBatch} from "./interfaces/IReflexBatch.sol";

// Sources
import {ReflexModule} from "../ReflexModule.sol";

/**
 * @title Reflex Batch
 *
 * @dev Execution takes place within the Dispatcher's storage context.
 * @dev Upgradeable, extendable.
 */
abstract contract ReflexBatch is IReflexBatch, ReflexModule {
    // ==============
    // Public methods
    // ==============

    /**
     * @inheritdoc IReflexBatch
     */
    function performBatchCall(BatchAction[] calldata actions_) public virtual nonReentrant {
        address messageSender = _unpackMessageSender();
        uint256 actionsLength = actions_.length;

        _beforeBatchCall(messageSender);

        for (uint256 i = 0; i < actionsLength; ) {
            BatchAction calldata action = actions_[i];

            (bool success, bytes memory result) = _performBatchAction(action, messageSender);

            if (!(success || action.allowFailure)) _revertBytes(result);

            unchecked {
                ++i;
            }
        }

        _afterBatchCall(messageSender);
    }

    /**
     * @inheritdoc IReflexBatch
     */
    function simulateBatchCall(BatchAction[] calldata actions_) public virtual onlyOffChain {
        // The `onlyOffChain` modifier ensures that this function is only called off-chain.

        // If somehow the transaction is performed on-chain, we rely on the correct
        // behavior of the `revert BatchSimulation(simulation)` statement.

        // To accurately simulate the conditions of a batch call symmetrically to `performBatchCall`
        // we opt to mark the function as non-reentrant and call the `_beforeBatchCall()` hook.
        //
        // It is assumed that in ALL cases the simulation will ALWAYS revert:
        // - Therefore it is safe to use `_beforeNonReentrant()` without the risk of bricking the contract.
        // - Therefore we omit the `_afterNonReentrant()` and `_afterBatchCall()` hooks.

        _beforeNonReentrant();

        address messageSender = _unpackMessageSender();
        uint256 actionsLength = actions_.length;

        _beforeBatchCall(messageSender);

        BatchActionResponse[] memory simulation = new BatchActionResponse[](actions_.length);

        for (uint256 i = 0; i < actionsLength; ) {
            BatchAction calldata action = actions_[i];

            (bool success, bytes memory result) = _performBatchAction(action, messageSender);

            simulation[i] = BatchActionResponse({success: success, result: result});

            unchecked {
                ++i;
            }
        }

        revert BatchSimulation(simulation);
    }

    // ============
    // Hook methods
    // ============

    /**
     * @notice Hook that is called before a batch call is made.
     * @param messageSender_ Message sender.
     */
    function _beforeBatchCall(address messageSender_) internal virtual {}

    /**
     * @notice Hook that is called after a batch call is made.
     * @param messageSender_ Message sender.
     */
    function _afterBatchCall(address messageSender_) internal virtual {}

    // ================
    // Internal methods
    // ================

    /**
     * @notice Perform a single batch action.
     * @param action_ Batch action.
     * @param messageSender_ Message sender.
     * @return success_ Whether the batch action was succesful.
     * @return result_ The return data of the performed batch action.
     */
    function _performBatchAction(
        BatchAction calldata action_,
        address messageSender_
    ) internal virtual returns (bool success_, bytes memory result_) {
        address moduleImplementation;
        address endpointAddress = action_.endpointAddress;

        assembly ("memory-safe") {
            // Load the relation of the `endpointAddress` from storage.
            // Store the `msg.sender` at memory position `0`.
            mstore(0x00, endpointAddress)
            // Store the relations slot at memory position `32`.
            mstore(0x20, _REFLEX_STORAGE_RELATIONS_SLOT)
            // Load the relation by `endpointAddress` from storage.
            let relation := sload(keccak256(0x00, 0x40))

            // Get module id from `relation` by extracting the lower 4 bytes.
            let moduleId_ := and(relation, 0xffffffff)

            // Revert if module id is 0.
            // This happens when the caller is not a trusted endpoint.
            if iszero(moduleId_) {
                // Store the function selector of `ModuleIdInvalid()`.
                mstore(0x00, 0xd4ec98db)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }

            // Get module implementation from `relation` by extracting the lower 20 bytes after shifting.
            moduleImplementation := and(shr(32, relation), 0xffffffffffffffffffffffffffffffffffffffff)

            // If module implementation is 0, load the module implementation from the modules mapping.
            // This is the case for multi-endpoint modules.
            if iszero(moduleImplementation) {
                // Store the module id at memory position `0` offset.
                mstore(0x00, moduleId_)
                // Store the module id slot at memory position `32` offset.
                mstore(0x20, _REFLEX_STORAGE_MODULES_SLOT)
                // Load the module implementation from storage.
                moduleImplementation := sload(keccak256(0x00, 0x40))
            }

            // Revert if module implementation is still 0, this happens when the
            // multi-module has been created but has not been registered yet.
            if iszero(moduleImplementation) {
                // Store the function selector of `ModuleNotRegistered()`.
                mstore(0x00, 0x9c4aee9e)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }
        }

        // TODO: implement in assembly.
        (success_, result_) = moduleImplementation.delegatecall(
            // TODO: optimize to avoid memory expansion.
            abi.encodePacked(action_.callData, uint160(messageSender_), uint160(endpointAddress))
        );
    }
}
