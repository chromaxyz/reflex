// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {Harness} from "./fixtures/Harness.sol";
import {Action, Logger, Simulation} from "./fixtures/Simulation.sol";

// Libraries
import {Strings} from "./libraries/Strings.sol";

contract BorrowSimulation is Simulation {
    using Strings for uint256;

    constructor(
        Logger logger_,
        string memory description_,
        uint256 timestep_
    ) Simulation(logger_, description_, timestep_) {
        string[] memory header = new string[](3);
        header[0] = "blockTimestamp";
        header[1] = "blockNumber";
        header[2] = "message";

        _logger.addHeader(header);
    }

    function start() public override {
        string[] memory row = new string[](3);
        row[0] = block.timestamp.toString();
        row[1] = block.number.toString();
        row[2] = "start";

        _logger.addRow(row);
    }

    function end() public override {
        string[] memory row = new string[](3);
        row[0] = block.timestamp.toString();
        row[1] = block.number.toString();
        row[2] = "end";

        _logger.addRow(row);
    }

    function snapshot() public override {
        string[] memory row = new string[](3);
        row[0] = block.timestamp.toString();
        row[1] = block.number.toString();
        row[2] = "snapshot";

        _logger.addRow(row);
    }
}

contract BorrowAction is Action {
    using Strings for uint256;

    constructor(
        Logger logger_,
        string memory description_,
        uint256 timestamp_
    ) Action(logger_, description_, timestamp_) {}

    function run() external override {
        string[] memory row = new string[](3);
        row[0] = block.timestamp.toString();
        row[1] = block.number.toString();
        row[2] = _description;

        _logger.addRow(row);
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
    BorrowAction public borrowAction4;
    BorrowAction public borrowAction5;

    BorrowSimulation public borrowSimulation;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        logger = new Logger("simulations/example.csv");

        borrowAction1 = new BorrowAction(logger, "first action", block.timestamp);
        borrowAction2 = new BorrowAction(logger, "second action", block.timestamp);
        borrowAction3 = new BorrowAction(logger, "third action", block.timestamp + 10 days);
        borrowAction4 = new BorrowAction(logger, "fourth action", block.timestamp + 20 days);
        borrowAction5 = new BorrowAction(logger, "fifth action", block.timestamp + 30 days);

        borrowSimulation = new BorrowSimulation(logger, "Reflex#Example >> example actions", 1 days);
    }

    // =====
    // Tests
    // =====

    function testSimulation() external {
        Action[] memory actions = new Action[](5);
        actions[0] = borrowAction1;
        actions[1] = borrowAction2;
        actions[2] = borrowAction3;
        actions[3] = borrowAction4;
        actions[4] = borrowAction5;
        borrowSimulation.add(actions);

        borrowSimulation.run();
    }
}
