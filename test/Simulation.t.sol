// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {Harness} from "./fixtures/Harness.sol";
import {Logger} from "./fixtures/Simulation.sol";

contract SimulationTest is Harness {
    // =====
    // Setup
    // =====

    Logger internal logger;

    function setUp() public virtual override {
        super.setUp();
    }

    // =====
    // Tests
    // =====

    function testWriteTable() external {
        logger = new Logger("simulations/teammates.csv");
        uint256 rowLength = 5;

        string[] memory header = new string[](rowLength);
        header[0] = "id";
        header[1] = "name";
        header[2] = "position";
        header[3] = "location";
        header[4] = "animal";

        logger.addHeader(logger.fileName(), header);

        string[] memory row = new string[](5);
        row[0] = "0";
        row[1] = "Erick";
        row[2] = "Smart Contracts";
        row[3] = "Detroit";
        row[4] = "iguana";

        logger.addRow(logger.fileName(), row);

        row[0] = "1";
        row[1] = "Lucas";
        row[2] = "Smart Contracts";
        row[3] = "Toronto";
        row[4] = "kangaroo";

        logger.addRow(logger.fileName(), row);

        row[0] = "2";
        row[1] = "Bidin";
        row[2] = "Smart Contracts";
        row[3] = "Panama";
        row[4] = "giraffe";

        logger.addRow(logger.fileName(), row);

        row[0] = "3";
        row[1] = "JG";
        row[2] = "Smart Contracts";
        row[3] = "Rio";
        row[4] = "elephant";

        logger.addRow(logger.fileName(), row);

        logger.writeFile(logger.fileName());
    }

    function testWriteTableLarge() external {
        logger = new Logger("simulations/large.csv");

        uint256 rowLength = 50;
        uint256 numberOfRows = 100;

        string[] memory header = new string[](rowLength);
        for (uint256 i = 0; i < header.length; i++) {
            header[i] = string(abi.encodePacked("header_", _castUInt256ToString(i)));
        }

        logger.addHeader(logger.fileName(), header);

        for (uint256 i = 0; i < numberOfRows; i++) {
            string[] memory row = new string[](rowLength);

            for (uint256 j = 0; j < row.length; j++) {
                row[j] = _castUInt256ToString(
                    uint256(keccak256(abi.encodePacked("cell", _castUInt256ToString(i), _castUInt256ToString(j))))
                );
            }

            logger.addRow(logger.fileName(), row);
        }

        logger.writeFile(logger.fileName());
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
