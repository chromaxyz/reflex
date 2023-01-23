// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {Harness} from "./fixtures/Harness.sol";

// Fixtures
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
        string[] memory header = new string[](2);
        header[0] = "timestamp";
        header[1] = "message";

        _logger.addHeader(header);
    }

    function start() public override {
        string[] memory row = new string[](2);
        row[0] = block.timestamp.toString();
        row[1] = "start";

        _logger.addRow(row);
    }

    function end() public override {
        string[] memory row = new string[](2);
        row[0] = block.timestamp.toString();
        row[1] = "end";

        _logger.addRow(row);
    }

    function snapshot() public override {
        string[] memory row = new string[](2);
        row[0] = block.timestamp.toString();
        row[1] = "snapshot";

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
        string[] memory row = new string[](2);
        row[0] = block.timestamp.toString();
        row[1] = _description;

        _logger.addRow(row);
    }

    // =========
    // Utilities
    // =========

    function _castUInt256ToString(uint256 input_) internal pure returns (string memory output_) {
        if (input_ == 0) return "0";

        uint256 j = input_;
        uint256 length;

        while (j != 0) {
            length++;
            j /= 10;
        }

        bytes memory output = new bytes(length);
        uint256 k = length;

        while (input_ != 0) {
            k = k - 1;

            uint8 temp = (48 + uint8(input_ - (input_ / 10) * 10));
            bytes1 b1 = bytes1(temp);

            output[k] = b1;
            input_ /= 10;
        }

        return string(output);
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

        logger = new Logger("simulations/team.csv");

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
}
