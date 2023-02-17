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
        address proxyAddress;
        bool allowFailure;
        bytes callData;
    }

    /**
     * @notice Single action in a batch response.
     */
    struct BatchActionResponse {
        bool success;
        bytes returnData;
    }

    // =======
    // Methods
    // =======

    function performBatchCall(IReflexBatch.BatchAction[] memory actions_) external;

    function performStaticCall(address contractAddress_, bytes memory payload_) external view returns (bytes memory);

    function simulateBatchCall(IReflexBatch.BatchAction[] memory actions_) external;

    function simulateBatchCallDecoded(
        IReflexBatch.BatchAction[] memory actions_
    ) external returns (IReflexBatch.BatchActionResponse[] memory simulation_);
}
