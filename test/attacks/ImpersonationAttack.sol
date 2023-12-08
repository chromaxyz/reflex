// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexDispatcher} from "../../src/interfaces/IReflexDispatcher.sol";
import {IReflexModule} from "../../src/interfaces/IReflexModule.sol";
import {IReflexBatch} from "../../src/periphery/interfaces/IReflexBatch.sol";

/**
 * @title Impersonation Attack
 * @dev Test contract to simulate an impersonation attack.
 * https://blog.openzeppelin.com/arbitrary-address-spoofing-vulnerability-erc2771context-multicall-public-disclosure
 */
contract ImpersonationAttack {
    // ======
    // Errors
    // ======

    error ImpersonationAttackFailed();

    // =======
    // Storage
    // =======

    IReflexDispatcher public dispatcher;
    IReflexBatch public batchEndpoint;
    IReflexModule public singleModuleEndpoint;

    // ===========
    // Constructor
    // ===========

    constructor(IReflexDispatcher dispatcher_, IReflexBatch batchEndpoint_, IReflexModule singleModuleEndpoint_) {
        dispatcher = dispatcher_;
        batchEndpoint = batchEndpoint_;
        singleModuleEndpoint = singleModuleEndpoint_;
    }

    // ==========
    // Test stubs
    // ==========

    function attackRecursiveBatch() external {}
}
