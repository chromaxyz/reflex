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
     * @notice Execute a staticcall to an arbitrary address with an arbitrary payload.
     * @param contractAddress_ Address of the contract to call.
     * @param payload_ Encoded call payload.
     * @return bytes Encoded return data.
     *
     * @dev Intended to be used in static-called batches, to e.g. provide detailed information about the impacts of the simulated operation.
     */
    function performStaticCall(address contractAddress_, bytes memory payload_) external view returns (bytes memory) {
        (bool success, bytes memory result) = contractAddress_.staticcall(payload_);

        if (!success) _revertBytes(result);

        assembly {
            return(add(32, result), mload(result))
        }
    }

    /**
     * @notice Perform a batch call to interact with multiple modules in a single transaction.
     * @param actions_ List of actions to perform.
     */
    function performBatchCall(BatchAction[] calldata actions_) external virtual override reentrancyAllowed {
        address messageSender = _unpackMessageSender();
        uint256 actionsLength = actions_.length;

        for (uint256 i = 0; i < actionsLength; ) {
            BatchAction calldata action = actions_[i];

            (bool success, bytes memory result) = _performBatchAction(messageSender, action);

            if (!(success || action.allowFailure)) _revertBytes(result);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Simulate a batch call to interact with multiple modules in a single transaction.
     * @param actions_ List of actions to simulate.
     *
     * @dev During simulation all batch actions are executed, regardless of the `allowFailure` flag.
     * @dev Reverts with simulation results.
     */
    function simulateBatchCall(BatchAction[] calldata actions_) external virtual override reentrancyAllowed {
        address messageSender = _unpackMessageSender();
        uint256 actionsLength = actions_.length;

        BatchActionResponse[] memory simulation = new BatchActionResponse[](actions_.length);

        for (uint256 i = 0; i < actionsLength; ) {
            BatchAction calldata action = actions_[i];

            (bool success, bytes memory result) = _performBatchAction(messageSender, action);

            simulation[i] = BatchActionResponse({success: success, returnData: result});

            unchecked {
                ++i;
            }
        }

        revert BatchSimulation(simulation);
    }

    /**
     * @notice Simulate a batch call, catch the revert and parse it to BatchActionResponse[].
     * @param actions_ List of actions to simulate.
     * @return simulation_ The decoded simulation of the simulated batched actions.
     *
     * @dev During simulation all batch actions are executed, regardless of the `allowFailure` flag.
     * @dev Returns with simulation results.
     */
    function simulateBatchCallDecoded(
        BatchAction[] calldata actions_
    ) external virtual override reentrancyAllowed returns (BatchActionResponse[] memory simulation_) {
        (bool success, bytes memory result) = _modules[_moduleId].delegatecall(
            abi.encodePacked(
                abi.encodeWithSelector(ReflexBatch.simulateBatchCall.selector, actions_),
                uint160(_unpackMessageSender()),
                uint160(_unpackProxyAddress())
            )
        );

        if (success) revert BatchSimulationFailed();

        if (bytes4(result) != BatchSimulation.selector) _revertBytes(result);

        assembly {
            result := add(4, result)
        }

        simulation_ = abi.decode(result, (BatchActionResponse[]));
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
