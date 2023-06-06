// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "../../interfaces/IReflexModule.sol";

/**
 * @title Reflex Batch Interface
 */
interface IReflexBatch is IReflexModule {
    // ======
    // Errors
    // ======

    error BatchSimulation(BatchActionResponse[] simulation);

    error BatchSimulationFailed();

    error ModuleNotRegistered(uint32 moduleId_);

    // =======
    // Structs
    // =======

    /**
     * @notice Single action in a batch request.
     */
    struct BatchAction {
        /**
         * @notice The endpoint address of the module to call with the call data.
         */
        address endpointAddress;
        /**
         * @notice Whether the action is allowed to fail.
         */
        bool allowFailure;
        /**
         * @notice Encoded call data.
         */
        bytes callData;
    }

    /**
     * @notice Single action in a batch response.
     */
    struct BatchActionResponse {
        /**
         * @notice Whether the action succeeded.
         */
        bool success;
        /**
         * @notice Encoded return data.
         */
        bytes returnData;
    }

    // =======
    // Methods
    // =======

    /**
     * @notice Execute a staticcall to an arbitrary address with an arbitrary payload.
     * @param contractAddress_ Address of the contract to call.
     * @param callData_ Encoded call data.
     * @return bytes Encoded return data.
     *
     * @dev Intended to be used in static-called batches, to e.g. provide
     * detailed information about the impacts of the simulated operation.
     */
    function performStaticCall(address contractAddress_, bytes memory callData_) external view returns (bytes memory);

    /**
     * @notice Perform a batch call to interact with multiple modules in a single transaction.
     * @param actions_ List of actions to perform.
     */
    function performBatchCall(BatchAction[] memory actions_) external;

    /**
     * @notice Simulate a batch call to interact with multiple modules in a single transaction.
     * @param actions_ List of actions to simulate.
     *
     * @dev During simulation all batch actions are executed, regardless of the `allowFailure` flag.
     * @dev Reverts with simulation results.
     */
    function simulateBatchCallRevert(BatchAction[] memory actions_) external;

    /**
     * @notice Simulate a batch call, catch the revert and parse it to BatchActionResponse[].
     * @param actions_ List of actions to simulate.
     * @return simulation_ The decoded simulation of the simulated batched actions.
     *
     * @dev During simulation all batch actions are executed, regardless of the `allowFailure` flag.
     * @dev Returns with simulation results.
     */
    function simulateBatchCallReturn(
        BatchAction[] memory actions_
    ) external returns (BatchActionResponse[] memory simulation_);
}
