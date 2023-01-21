// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {Harness} from "./fixtures/Harness.sol";
import {Action, Simulation} from "./fixtures/Simulation.sol";

contract ReflexAction is Action {
    constructor(uint256 timestamp_, string memory description_) Action(timestamp_, description_) {}

    function act() external override {}
}

contract ReflexSimulation is Harness {
    // =======
    // Storage
    // =======

    Simulation public simulation;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        simulation = new Simulation("simulations/simulation.json", 1 days, 0);
    }

    // =====
    // Tests
    // =====

    function testSimulation() external {
        Action[] memory actions = new Action[](3);
        actions[0] = new ReflexAction(block.timestamp + 10 days, "first action");
        actions[1] = new ReflexAction(block.timestamp + 20 days, "second action");
        actions[2] = new ReflexAction(block.timestamp + 30 days, "third action");
        simulation.add(actions);

        simulation.run();
    }
}
