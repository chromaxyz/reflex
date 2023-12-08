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

    /**
     * @dev Thrown with the result of a batch simulation.
     */
    error BatchSimulation(BatchActionResponse[] simulation);

    /**
     * @dev Thrown when a module is not registered.
     */
    error ModuleNotRegistered();

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
        bytes result;
    }

    // =======
    // Methods
    // =======

    /**
     * @notice Perform a batch call to interact with multiple modules in a single transaction.
     * @param actions_ List of actions to perform.
     */
    function performBatchCall(BatchAction[] memory actions_) external;

    /**
     * @notice Simulate a batch call to interact with multiple modules in a single transaction.
     * It is not possible to simulate a batch call on-chain. To simulate a batch call, use `eth_call`.
     * @param actions_ List of actions to simulate.
     *
     * @dev During simulation all batch actions are executed, regardless of the `allowFailure` flag.
     * @dev Reverts with simulation results.
     */
    function simulateBatchCall(BatchAction[] memory actions_) external;
}
