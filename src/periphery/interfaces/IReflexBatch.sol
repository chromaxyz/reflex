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

    error ModuleNonexistent(uint32 moduleId_);
}

/**
 * @title Reflex Batch Interface
 */
interface IReflexBatch is IReflexModule, TReflexBatch {
    // ======
    // Errors
    // ======

    error BatchSimulation(BatchActionResponse[] simulation);

    // =======
    // Structs
    // =======

    /**
     * @notice Single action in a batch request.
     */
    struct BatchAction {
        bool allowError;
        address proxyAddress;
        bytes data;
    }

    /**
     * @notice Single action in a batch response.
     */
    struct BatchActionResponse {
        bool success;
        bytes result;
    }
}
