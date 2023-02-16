// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBatch} from "./interfaces/IReflexBatch.sol";
import {IReflexModule} from "../interfaces/IReflexModule.sol";

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
     * @notice Perform a batch call to interact with multiple modules in a single transaction.
     * @param actions_ List of actions to perform.
     */
    function performBatchCall(BatchAction[] calldata actions_) external virtual reentrancyAllowed {
        address messageSender = _unpackMessageSender();
        uint256 actionsLength = actions_.length;

        for (uint256 i = 0; i < actionsLength; ) {
            BatchAction calldata action = actions_[i];

            (bool success, bytes memory returnData) = _performBatchAction(messageSender, action);

            if (!(success || action.allowFailure)) _revertBytes(returnData);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Simulate a batch call to interact with multiple modules in a single transaction.
     * @param actions_ List of actions to simulate.
     * @dev Reverts with simulation results.
     */
    function simulateBatchCall(BatchAction[] calldata actions_) external virtual reentrancyAllowed {
        address messageSender = _unpackMessageSender();
        uint256 actionsLength = actions_.length;

        BatchActionResponse[] memory simulation = new BatchActionResponse[](actions_.length);

        for (uint256 i = 0; i < actionsLength; ) {
            BatchAction calldata action = actions_[i];

            (bool success, bytes memory returnData) = _performBatchAction(messageSender, action);

            simulation[i] = BatchActionResponse({success: success, returnData: returnData});

            unchecked {
                ++i;
            }
        }

        revert BatchSimulation(simulation);
    }

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
        address proxyAddress = action_.proxyAddress;

        uint32 moduleId_ = _relations[proxyAddress].moduleId;

        if (moduleId_ == 0) revert InvalidModuleId();

        address moduleImplementation_ = _relations[proxyAddress].moduleImplementation;

        if (moduleImplementation_ == address(0)) moduleImplementation_ = _modules[moduleId_];

        if (moduleImplementation_ == address(0)) revert ModuleNotRegistered(moduleId_);

        (success_, returnData_) = moduleImplementation_.delegatecall(
            abi.encodePacked(action_.callData, uint160(messageSender_), uint160(proxyAddress))
        );
    }
}
