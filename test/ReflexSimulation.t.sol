// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {Harness} from "./fixtures/Harness.sol";

// Fixtures
import {Action, Logger, Replay, Simulation} from "./fixtures/Simulation.sol";

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
        string memory description_,
        uint256 timestamp_
    ) Action(logger_, description_, timestamp_) {}

    function run() external override {
        _logger.writeLog(string.concat(_description, ": foo bar foo 1"));
        _logger.writeLog(string.concat(_description, ": foo bar foo 2"));
        _logger.writeLog(string.concat(_description, ": foo bar foo 3"));
        _logger.writeLog(string.concat(_description, ": foo bar foo 4"));
        _logger.writeLog(string.concat(_description, ": foo bar foo 5"));
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

        borrowAction1 = new BorrowAction(logger, "first action", block.timestamp + 10 days);
        borrowAction2 = new BorrowAction(logger, "second action", block.timestamp + 20 days);
        borrowAction3 = new BorrowAction(logger, "third action", block.timestamp + 30 days);

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
