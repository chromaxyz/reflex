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

    function performBatchCall(BatchAction[] memory actions_) external;

    function simulateBatchCall(BatchAction[] memory actions_) external;

    function simulateBatchCallDecoded(
        BatchAction[] calldata actions_
    ) external returns (BatchActionResponse[] memory simulation_);

    function performStaticCall(address contractAddress, bytes memory payload) external view returns (bytes memory);
}