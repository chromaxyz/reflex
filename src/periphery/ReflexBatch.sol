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

        assembly {
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

            (bool success, bytes memory result) = _performBatchAction(messageSender, action);

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

            (bool success, bytes memory result) = _performBatchAction(messageSender, action);

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

        assembly {
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
     * @param messageSender_ Message sender.
     * @param action_ Action to perform.
     * @return success_ Whether the batch action was succesful.
     * @return returnData_ The return data of the performed batch action.
     */
    function _performBatchAction(
        address messageSender_,
        BatchAction calldata action_
    ) internal virtual returns (bool success_, bytes memory returnData_) {
        address endpointAddress = action_.endpointAddress;

        address moduleImplementation;

        assembly {
            // Cache the free memory pointer.
            let m := mload(0x40)

            // TrustRelation memory relation = _REFLEX_STORAGE().relations[msg.sender]
            // Store the `endpointAddress` at memory position `0` offset.
            mstore(0x00, endpointAddress)
            // Store the relations slot at memory position `32` offset.
            mstore(0x20, _REFLEX_STORAGE_RELATIONS_SLOT)
            // Load the relation by `endpointAddress` from storage.
            let relation := sload(keccak256(0x00, 0x40))

            // uint32 moduleId = relation.moduleId;
            let moduleId_ := and(relation, 0xffffffff)

            // if (relation.moduleId == 0) revert ModuleIdInvalid();
            if iszero(moduleId_) {
                // Store the function selector of `ModuleIdInvalid()`.
                mstore(0x00, 0xd4ec98db)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }

            // address moduleImplementation = relation.moduleImplementation;
            moduleImplementation := and(shr(32, relation), 0xffffffffffffffffffffffffffffffffffffffff)

            // if (moduleImplementation == address(0)) moduleImplementation = _REFLEX_STORAGE().modules[moduleId];
            if iszero(moduleImplementation) {
                // Store the module id at memory position `0` offset.
                mstore(0x00, moduleId_)
                // Store the module id slot at memory position `32` offset.
                mstore(0x20, _REFLEX_STORAGE_MODULES_SLOT)
                // Load the module implementation from storage.
                moduleImplementation := sload(keccak256(0x00, 0x40))
            }

            // if (moduleImplementation == address(0)) revert ModuleNotRegistered();
            if iszero(moduleImplementation) {
                // Store the function selector of `ModuleNotRegistered()`.
                mstore(0x00, 0x9c4aee9e)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }

            // Restore the free memory pointer.
            mstore(0x40, m)
        }

        (success_, returnData_) = moduleImplementation.delegatecall(
            abi.encodePacked(action_.callData, uint160(messageSender_), uint160(endpointAddress))
        );
    }
}
