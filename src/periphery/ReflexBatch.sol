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

            simulation[i] = BatchActionResponse({success: success, result: result});

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
     * @return result_ The return data of the performed batch action.
     */
    function _performBatchAction(
        bytes memory callData_,
        address messageSender_,
        address endpointAddress_
    ) internal virtual returns (bool success_, bytes memory result_) {
        TrustRelation memory relation = _REFLEX_STORAGE().relations[endpointAddress_];

        uint32 moduleId_ = relation.moduleId;

        if (moduleId_ == 0) revert ModuleIdInvalid();

        address moduleImplementation = relation.moduleImplementation;

        if (moduleImplementation == address(0)) moduleImplementation = _REFLEX_STORAGE().modules[moduleId_];

        if (moduleImplementation == address(0)) revert ModuleNotRegistered();

        (success_, result_) = moduleImplementation.delegatecall(
            abi.encodePacked(callData_, messageSender_, endpointAddress_)
        );
    }
}
