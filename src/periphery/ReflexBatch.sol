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
    function performStaticCall(address contractAddress_, bytes memory callData_) public view returns (bytes memory) {
        if (contractAddress_ == address(0)) revert ZeroAddress();

        (bool success, bytes memory result) = contractAddress_.staticcall(callData_);

        if (!success) _revertBytes(result);

        assembly ("memory-safe") {
            return(add(32, result), mload(result))
        }
    }

    /**
     * @inheritdoc IReflexBatch
     */
    function performBatchCall(BatchAction[] calldata actions_) public virtual reentrancyAllowed {
        address messageSender = _unpackMessageSender();
        uint256 actionsLength = actions_.length;

        _beforeBatchCall(messageSender);

        for (uint256 i = 0; i < actionsLength; ) {
            BatchAction calldata action = actions_[i];

            (bool success, bytes memory result) = _performBatchAction(
                action.callData,
                messageSender,
                action.endpointAddress
            );

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
    function simulateBatchCallRevert(BatchAction[] calldata actions_) public virtual reentrancyAllowed {
        address messageSender = _unpackMessageSender();
        uint256 actionsLength = actions_.length;

        _beforeBatchCall(messageSender);

        BatchActionResponse[] memory simulation = new BatchActionResponse[](actions_.length);

        for (uint256 i = 0; i < actionsLength; ) {
            BatchAction calldata action = actions_[i];

            (bool success, bytes memory result) = _performBatchAction(
                action.callData,
                messageSender,
                action.endpointAddress
            );

            simulation[i] = BatchActionResponse({success: success, returnData: result});

            unchecked {
                ++i;
            }
        }

        _afterBatchCall(messageSender);

        revert BatchSimulation(simulation);
    }

    /**
     * @inheritdoc IReflexBatch
     */
    function simulateBatchCallReturn(
        BatchAction[] calldata actions_
    ) public virtual reentrancyAllowed returns (BatchActionResponse[] memory simulation_) {
        // WARNING: It is assumed attacker will never be able to control _modules (storage) nor _moduleId (immutable).
        (bool success, bytes memory result) = _REFLEX_STORAGE().modules[_moduleId].delegatecall(
            abi.encodePacked(
                abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector, actions_),
                uint160(_unpackMessageSender()),
                uint160(_unpackEndpointAddress())
            )
        );

        if (success) revert BatchSimulationFailed();

        if (bytes4(result) != BatchSimulation.selector) _revertBytes(result);

        assembly ("memory-safe") {
            result := add(4, result)
        }

        simulation_ = abi.decode(result, (BatchActionResponse[]));
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
     * @param callData_ Call data.
     * @param messageSender_ Message sender.
     * @param endpointAddress_ Endpoint address.
     * @return success_ Whether the batch action was succesful.
     * @return returnData_ The return data of the performed batch action.
     */
    function _performBatchAction(
        bytes memory callData_,
        address messageSender_,
        address endpointAddress_
    ) internal virtual returns (bool success_, bytes memory returnData_) {
        address moduleImplementation;

        // TODO: technically not memory-safe but not problematic
        // because it only allocates the lower 64 bytes of memory
        // before the free memory pointer.
        assembly {
            // Load the relation of the `endpointAddress` from storage.
            // Store the `msg.sender` at memory position `0`.
            mstore(0x00, endpointAddress_)
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

        // TODO: optimize, write in assembly
        // TODO: memory expansion is incredibly expensive, re-use memory.
        // it is also safer to not return to Solidity
        // NOTE: restoring the free memory pointer is not necessary because it remains untouched
        (success_, returnData_) = moduleImplementation.delegatecall(
            abi.encodePacked(callData_, messageSender_, endpointAddress_)
        );
    }
}
