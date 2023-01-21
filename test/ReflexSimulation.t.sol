// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {Harness} from "./fixtures/Harness.sol";
import {Action, Logger, Simulation} from "./fixtures/Simulation.sol";

contract RAction is Action {
    constructor(uint256 timestamp_, string memory description_) Action(timestamp_, description_) {}

    function act() external override {}
}

contract ReflexSimulation is Harness {
    // =======
    // Storage
    // =======

    Simulation public simulation;
    Logger public logger;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        simulation = new Simulation();
        logger = new Logger("simulations/simulation.json");
        simulation.registerLogger(logger);

        RAction action = new RAction(block.timestamp, "foo bar");

        simulation.addAction(action);

        // simulation.addAction();
    }

    // =====
    // Tests
    // =====

    function testSimulation() external {
        simulation.runSimulation(1 days);
    }
}
