// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule, TReflexModule} from "../../interfaces/IReflexModule.sol";

/**
 * @title Reflex Batch Test Interface
 */
interface TReflexBatch is TReflexModule {
    // ======
    // Errors
    // ======

    error ModuleNotRegistered(uint32 moduleId_);
}

/**
 * @title Reflex Batch Interface
 */
interface IReflexBatch is IReflexModule, TReflexBatch {
    // ======
    // Errors
    // ======

    error BatchSimulation(BatchActionResponse[] simulation);

    error BatchSimulationFailed();

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

    function performBatchCall(BatchAction[] memory actions_) external;

    function performStaticCall(address contractAddress_, bytes memory payload_) external view returns (bytes memory);

    function simulateBatchCallRevert(BatchAction[] memory actions_) external;

    function simulateBatchCallReturn(
        BatchAction[] memory actions_
    ) external returns (BatchActionResponse[] memory simulation_);
}
