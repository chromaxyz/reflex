// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {Harness} from "./fixtures/Harness.sol";

// Simulation
import {Action} from "./simulation/Action.sol";
import {Logger} from "./simulation/Logger.sol";
import {Replay} from "./simulation/Replay.sol";
import {Simulation} from "./simulation/Simulation.sol";

contract BorrowSimulation is Simulation {
    constructor(
        Logger logger_,
        string memory description_,
        uint256 timestep_
    ) Simulation(logger_, description_, timestep_) {}

    function start() public override {
        _logger.writeLog("start!");
    }

    function end() public override {
        _logger.writeLog("end!");
    }

    function snapshot() public override {
        _logger.writeLog("snapshot!");
    }
}

contract BorrowAction is Action {
    constructor(
        Logger logger_,
        uint256 timestamp_,
        string memory description_
    ) Action(logger_, timestamp_, description_) {}

    function run() external override {
        _logger.writeLog("foo bar foo");
    }
}

contract ReflexSimulation is Harness {
    // =======
    // Storage
    // =======

    Logger public logger;

    BorrowAction public borrowAction1;
    BorrowAction public borrowAction2;
    BorrowAction public borrowAction3;

    BorrowSimulation public borrowSimulation;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        logger = new Logger("simulation");

        borrowAction1 = new BorrowAction(logger, block.timestamp + 10 days, "first action");
        borrowAction2 = new BorrowAction(logger, block.timestamp + 20 days, "second action");
        borrowAction3 = new BorrowAction(logger, block.timestamp + 30 days, "third action");

        borrowSimulation = new BorrowSimulation(logger, "Reflex#Simulacra >> borrow actions", 1 days);
    }

    // =====
    // Tests
    // =====

    function testSimulation() external {
        Action[] memory actions = new Action[](3);
        actions[0] = borrowAction1;
        actions[1] = borrowAction2;
        actions[2] = borrowAction3;
        borrowSimulation.add(actions);

        borrowSimulation.run();
    }

    function testReplay() external {
        Replay replay = new Replay("simulation");

        replay.run();
    }
}
