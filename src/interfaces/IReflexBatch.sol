// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule, TReflexModule} from "./IReflexModule.sol";

/**
 * @title Reflex Batch Test Interface
 */
interface TReflexBatch is TReflexModule {
    // ======
    // Errors
    // ======

    error ModuleNonexistent(uint32 moduleId_);
}

/**
 * @title Reflex Batch Interface
 */
interface IReflexBatch is IReflexModule, TReflexBatch {
    // ======
    // Errors
    // ======

    error BatchSimulation(BatchItemResponse[] simulation);

    // =======
    // Structs
    // =======

    /**
     * @notice Single item in a batch request.
     */
    struct BatchItem {
        bool allowError;
        address proxyAddress;
        bytes data;
    }

    /**
     * @notice Single item in a batch response.
     */
    struct BatchItemResponse {
        bool success;
        bytes result;
    }
}
