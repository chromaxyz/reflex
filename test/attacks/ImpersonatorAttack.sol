// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBatch} from "../../src/periphery/interfaces/IReflexBatch.sol";
import {IReflexDispatcher} from "../../src/interfaces/IReflexDispatcher.sol";

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

    IReflexDispatcher public dispatcher;
    IReflexBatch public batchEndpoint;

    // =====
    // Users
    // =====

    address public alice = _createUser("Alice");
    address public bob = _createUser("Bob");

    // ===========
    // Constructor
    // ===========

    constructor(IReflexDispatcher dispatcher_, IReflexBatch batchEndpoint_) {
        dispatcher = dispatcher_;
        batchEndpoint = batchEndpoint_;
    }

    // ==========
    // Test stubs
    // ==========

    function attackImpersonate() external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](0);

        // Reflex currently slices the `msg.sender` and the `endpoint address` from the end of the call data.
        // If called correctly it should always have these two values at the end of the call data.
        // Stuffing the calldata by an arbitrary address should not have any effect.

        // The only way to interact with the Dispatcher is through any approved endpoint.

        batchEndpoint.performBatchCall(actions);
    }

    // =========
    // Utilities
    // =========

    /**
     * @dev Create user address from user label.
     */
    function _createUser(string memory label_) internal pure returns (address payable user) {
        user = payable(address(uint160(uint256(keccak256(abi.encodePacked(label_))))));
    }
}
