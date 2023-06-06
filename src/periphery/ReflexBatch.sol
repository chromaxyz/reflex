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
        // NOTE: it is assumed user will never be able to control _modules (storage) nor _moduleId (immutable).
        // TODO: _unpackEndpointAddress could be replaced by msg.sender.

        (bool success, bytes memory result) = _modules[_moduleId].delegatecall(
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
        uint32 moduleId_ = _relations[endpointAddress].moduleId;

        if (moduleId_ == 0) revert ModuleIdInvalid();

        address moduleImplementation = _relations[endpointAddress].moduleImplementation;

        if (moduleImplementation == address(0)) moduleImplementation = _modules[moduleId_];

        if (moduleImplementation == address(0)) revert ModuleNotRegistered(moduleId_);

        (success_, returnData_) = moduleImplementation.delegatecall(
            abi.encodePacked(action_.callData, uint160(messageSender_), uint160(endpointAddress))
        );
    }
}
