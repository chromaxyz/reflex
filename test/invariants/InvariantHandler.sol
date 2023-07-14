// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Fixtures
import {UnboundedHandler} from "../fixtures/TestHarness.sol";

/**
 * @title Invariant Handler Interface
 */
interface IInvariantHandler {
    function setUp() external;

    function warp(uint256 warpTime_) external;

    function getCallCount(bytes32 message_) external returns (uint256);
}

/**
 * @title Invariant Handler
 */
contract InvariantHandler is UnboundedHandler {
    // =====
    // Setup
    // =====

    function setUp() public virtual {
        setCurrentTimestamp(block.timestamp);
        vm.warp(_currentTimestamp);

        addActor(_users.Alice);
        addActor(_users.Bob);
        addActor(_users.Caroll);
        addActor(_users.Dave);
    }
}
