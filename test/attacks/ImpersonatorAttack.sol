// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBatch} from "../../src/periphery/interfaces/IReflexBatch.sol";

// Mocks
import {MockReflexBatch} from "../mocks/MockReflexBatch.sol";
import {MockReflexDispatcher} from "../mocks/MockReflexDispatcher.sol";

/**
 * @title Impersonator Attack
 * @dev Test contract to simulate an impersonator attack.
 */
contract ImpersonatorAttack {
    // ======
    // Errors
    // ======

    error ImpersonatorAttackFailed();

    // =======
    // Storage
    // =======

    MockReflexDispatcher public dispatcher;
    MockReflexBatch public batchEndpoint;

    // ===========
    // Constructor
    // ===========

    constructor(MockReflexDispatcher dispatcher_, MockReflexBatch batchEndpoint_) {
        dispatcher = dispatcher_;
        batchEndpoint = batchEndpoint_;
    }

    // ==========
    // Test stubs
    // ==========

    function attackImpersonate() external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](0);

        batchEndpoint.performBatchCall(actions);
    }
}
