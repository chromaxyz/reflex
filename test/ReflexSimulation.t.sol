// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {Harness} from "./fixtures/Harness.sol";
import {Action, Simulation} from "./fixtures/Simulation.sol";

contract RAction is Action {
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

        simulation = new Simulation("simulations/simulation.json");

        Action[] memory actions = new Action[](3);
        actions[0] = new RAction(block.timestamp + 1 days, "first action");
        actions[1] = new RAction(block.timestamp + 2 days, "second action");
        actions[2] = new RAction(block.timestamp + 3 days, "third action");
        simulation.addActions(actions);
    }

    // =====
    // Tests
    // =====

    function testSimulation() external {
        simulation.runSimulation(1 days);
    }
}
