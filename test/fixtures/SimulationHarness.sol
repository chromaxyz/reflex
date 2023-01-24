// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {CommonBase} from "forge-std/Base.sol";
import {console2} from "forge-std/console2.sol";

// Fixtures
import {Users} from "./Users.sol";

// Libraries
import {Strings} from "../libraries/Strings.sol";

/**
 * @title Logger
 * @dev Logger for writing simulation output data to a CSV file.
 * @author `Logger` has been inspired by: Maple V2 Core (https://github.com/maple-labs/contract-test-utils/blob/f5e9765e66e7f81158aadde194a95aec4f7747ec/contracts/csv.sol) (AGPL-3.0-only)
 */
contract Logger is CommonBase {
    using Strings for uint256;

    // ======
    // Errors
    // ======

    error NoFilePath();

    error MissingValues();

    error RowLengthMismatch();

    // =======
    // Storage
    // =======

    string internal _filePath;

    string[][] internal _table;

    // ===========
    // Constructor
    // ===========

    /**
     * @param filePath_ File path of file to write to.
     */
    constructor(string memory filePath_) {
        if (bytes(filePath_).length == 0) revert NoFilePath();

        _filePath = filePath_;
    }

    // ==============
    // Public methods
    // ==============

    /**
     * @dev Add header to table.
     */
    function addHeader(string[] memory header_) external {
        _addHeader(header_);
    }

    /**
     * @dev Add header to table.
     */
    function addHeader(string memory header1_) external {
        string[] memory row = new string[](1);
        row[0] = header1_;

        _addHeader(row);
    }

    /**
     * @dev Add header to table.
     */
    function addHeader(string memory header1_, string memory header2_) external {
        string[] memory row = new string[](2);
        row[0] = header1_;
        row[1] = header2_;

        _addHeader(row);
    }

    /**
     * @dev Add header to table.
     */
    function addHeader(string memory header1_, string memory header2_, string memory header3_) external {
        string[] memory row = new string[](3);
        row[0] = header1_;
        row[1] = header2_;
        row[2] = header3_;

        _addHeader(row);
    }

    /**
     * @dev Add header to table.
     */
    function addHeader(
        string memory header1_,
        string memory header2_,
        string memory header3_,
        string memory header4_
    ) external {
        string[] memory row = new string[](4);
        row[0] = header1_;
        row[1] = header2_;
        row[2] = header3_;
        row[3] = header4_;

        _addHeader(row);
    }

    /**
     * @dev Add header to table.
     */
    function addHeader(
        string memory header1_,
        string memory header2_,
        string memory header3_,
        string memory header4_,
        string memory header5_
    ) external {
        string[] memory row = new string[](5);
        row[0] = header1_;
        row[1] = header2_;
        row[2] = header3_;
        row[3] = header4_;
        row[4] = header5_;

        _addHeader(row);
    }

    /**
     * @dev Add row to table.
     */
    function addRow(string[] memory row_) external {
        if (_table.length == 0) revert MissingValues();
        if (_table[0].length != row_.length) revert RowLengthMismatch();

        _addRow(row_);
    }

    /**
     * @dev Add row to table.
     */
    function addRow(string memory cell1_) external {
        if (_table.length == 0) revert MissingValues();
        if (_table[0].length != 1) revert RowLengthMismatch();

        string[] memory row = new string[](1);
        row[0] = cell1_;

        _addRow(row);
    }

    /**
     * @dev Add row to table.
     */
    function addRow(string memory cell1_, string memory cell2_) external {
        if (_table.length == 0) revert MissingValues();
        if (_table[0].length != 2) revert RowLengthMismatch();

        string[] memory row = new string[](2);
        row[0] = cell1_;
        row[1] = cell2_;

        _addRow(row);
    }

    /**
     * @dev Add row to table.
     */
    function addRow(string memory cell1_, string memory cell2_, string memory cell3_) external {
        if (_table.length == 0) revert MissingValues();
        if (_table[0].length != 3) revert RowLengthMismatch();

        string[] memory row = new string[](3);
        row[0] = cell1_;
        row[1] = cell2_;
        row[2] = cell3_;

        _addRow(row);
    }

    /**
     * @dev Add row to table.
     */
    function addRow(string memory cell1_, string memory cell2_, string memory cell3_, string memory cell4_) external {
        if (_table.length == 0) revert MissingValues();
        if (_table[0].length != 4) revert RowLengthMismatch();

        string[] memory row = new string[](4);
        row[0] = cell1_;
        row[1] = cell2_;
        row[2] = cell3_;
        row[3] = cell4_;

        _addRow(row);
    }

    /**
     * @dev Add row to table.
     */
    function addRow(
        string memory cell1_,
        string memory cell2_,
        string memory cell3_,
        string memory cell4_,
        string memory cell5_
    ) external {
        if (_table.length == 0) revert MissingValues();
        if (_table[0].length != 5) revert RowLengthMismatch();

        string[] memory row = new string[](5);
        row[0] = cell1_;
        row[1] = cell2_;
        row[2] = cell3_;
        row[3] = cell4_;
        row[4] = cell5_;

        _addRow(row);
    }

    /**
     * @dev Write file to disk.
     */
    function writeFile() external {
        try vm.readLine(_filePath) {
            vm.removeFile(_filePath);
        } catch {}

        string memory line;

        for (uint256 i = 0; i < _table.length; i++) {
            for (uint256 j = 0; j < _table[i].length; j++) {
                if (j == 0) {
                    line = _table[i][j];
                } else {
                    line = string(abi.encodePacked(line, ",", _table[i][j]));
                }
            }

            vm.writeLine(_filePath, line);
        }

        console2.log(string.concat("Wrote table to: ", _filePath, " (", _table.length.toString(), " entries)"));
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev Add header to table.
     */
    function _addHeader(string[] memory header_) internal {
        delete _table;

        _addRow(header_);
    }

    /**
     * @dev Add row to table.
     */
    function _addRow(string[] memory row_) internal {
        for (uint256 i = 0; i < row_.length; i++) {
            string memory cell = row_[i];

            if (bytes(cell).length == 0) revert MissingValues();
        }

        _table.push(row_);
    }
}

/**
 * @title Action
 * @dev Abstract action to execute in the simulation.
 * @author `Action` has been inspired by: Maple V2 Core (https://github.com/maple-labs/maple-core-v2/blob/25bca5b7a698235c612695e86d349c4e765ce6be/contracts/actions/Action.sol) (AGPL-3.0-only)
 */
abstract contract Action is Users {
    // ======
    // Errors
    // ======

    error NoDescription();

    error NoLogger();

    error InvalidTimestamp();

    // =======
    // Storage
    // =======

    Logger internal _logger;
    string internal _description;
    uint256 internal _timestamp;

    // ===========
    // Constructor
    // ===========

    /**
     * @param logger_ Action logger.
     * @param description_ Description of the action.
     * @param timestamp_ Timestamp of the action.
     */
    constructor(Logger logger_, string memory description_, uint256 timestamp_) {
        if (address(logger_) == address(0)) revert NoLogger();
        if (bytes(description_).length == 0) revert NoDescription();
        if (timestamp_ == 0) revert InvalidTimestamp();

        _logger = logger_;
        _description = description_;
        _timestamp = timestamp_;
    }

    // ==============
    // Public methods
    // ==============

    /**
     * @dev Performs the action.
     */
    function run() external virtual;

    /**
     * @dev Returns a description of what the action does (used for logging purposes).
     */
    function description() external view returns (string memory description_) {
        return _description;
    }

    /**
     * @dev Defines at which time during the simulation this action should be performed.
     */
    function timestamp() external view returns (uint256 timestamp_) {
        return _timestamp;
    }
}

/**
 * @title Simulation Harness
 * @dev Abstract simulation harness to execute a series of actions in chronological order by timestamp.
 * @author `Simulation` has been inspired by: Maple V2 Core (https://github.com/maple-labs/maple-core-v2/blob/aebc14ba7704da31cae8c7fe0c06d6a3396a600a/contracts/PoolSimulation.sol) (AGPL-3.0-only)
 * @author `Simulation` has been inspired by: Maple V2 Core (https://github.com/maple-labs/maple-core-v2/blob/aebc14ba7704da31cae8c7fe0c06d6a3396a600a/contracts/ActionHandler.sol) (AGPL-3.0-only)
 */
abstract contract SimulationHarness is CommonBase, Users {
    // =========
    // Constants
    // =========

    uint256 private constant _TIME_PER_BLOCK = 12 seconds;

    // ======
    // Errors
    // ======

    error NoDescription();

    error NoLogger();

    error InvalidTimeStep();

    error InvalidTimestamp();

    error NoActions();

    // =======
    // Storage
    // =======

    Logger internal _logger;
    string internal _description;
    uint256 internal _timeStep;

    Action[] internal _actions;
    uint256 internal _actionIndex;
    uint256 internal _startTimestamp;
    uint256 internal _endTimestamp;

    // ===========
    // Constructor
    // ===========

    /**
     * @param logger_ Simulation logger.
     * @param description_ Simulation description.
     * @param timeStep_ Time step per cycle.

     */
    constructor(Logger logger_, string memory description_, uint256 timeStep_) {
        if (address(logger_) == address(0)) revert NoLogger();
        if (bytes(description_).length == 0) revert NoDescription();
        if (timeStep_ == 0) revert InvalidTimeStep();

        _logger = logger_;
        _description = description_;
        _timeStep = timeStep_;
    }

    // ==============
    // Public methods
    // ==============

    /**
     * @dev Ran at the start of the simulation.
     */
    function start() public virtual {}

    /**
     * @dev Ran at the end of the simulation.
     */
    function end() public virtual {}

    /**
     * @dev Ran on every timestep iteration.
     */
    function snapshot() public virtual {}

    /**
     * @dev Add action to simulation to execute.
     */
    function add(Action[] memory actions_) external {
        for (uint256 i = 0; i < actions_.length; ++i) {
            _actions.push(actions_[i]);
        }
    }

    /**
     * @dev Run the simulation.
     */
    function run() external {
        console2.log(_description, "\n");

        // Early exit if no actions were registered.
        if (_actions.length == 0) revert NoActions();

        console2.log("Running", _actions.length, "actions with timestep @", _timeStep);

        // Sort all actions based on their timestamp.
        for (uint256 i = 0; i < _actions.length - 1; ++i) {
            for (uint256 j = 0; j < _actions.length - 1 - i; ++j) {
                if (_actions[j].timestamp() > _actions[j + 1].timestamp()) {
                    (_actions[j], _actions[j + 1]) = (_actions[j + 1], _actions[j]);
                }
            }
        }

        // Register start timestamp with negative time step padding if enough space.
        _startTimestamp = _actions[0].timestamp() > _timeStep ? _actions[0].timestamp() - _timeStep : block.timestamp;

        // Register end timestamp with positive time step padding.
        _endTimestamp = _actions[_actions.length - 1].timestamp() + _timeStep;

        // Warp to block.
        _warpBlock(_startTimestamp);

        // Snapshot the initial state of the simulation.
        start();

        console2.log("Starting timestamp @", block.timestamp);

        while (true) {
            // Calculate when the next snapshot will be taken.
            uint256 nextTimestamp_ = block.timestamp + _timeStep;

            // Round down the timestamp to the end of the simulation if it exceeds it.
            if (nextTimestamp_ > _endTimestamp) nextTimestamp_ = _endTimestamp;

            // Perform all actions that occur up to and including the given timestamp.
            while (_actionIndex != _actions.length) {
                Action nextAction_ = _actions[_actionIndex];

                // Ignore invalid actions that were set to occur in the past.
                if (nextAction_.timestamp() < block.timestamp) {
                    ++_actionIndex;
                    continue;
                }

                // If no more actions before the next timestamp exist, stop.
                if (nextAction_.timestamp() > nextTimestamp_) break;

                // Warp to the action timestamp.
                _warpBlock(nextAction_.timestamp());

                // Perform the action.
                console2.log("Running", nextAction_.description(), "@", block.timestamp);
                nextAction_.run();

                // Increment the counter to point to the next action.
                ++_actionIndex;
            }

            // Warp to block.
            _warpBlock(nextTimestamp_);

            // Capture state snapshot.
            snapshot();

            // If we are at the end, terminate the simulation.
            if (block.timestamp == _endTimestamp) break;
        }

        // Warp to final block.
        _warpBlock(block.timestamp);

        // Snapshot the final state of the simulation.
        end();

        console2.log("Ending timestamp @", block.timestamp);

        // Write to disk.
        _logger.writeFile();
    }

    // =========
    // Utilities
    // =========

    /**
     * @dev Warp timestamp and roll to estimated block.
     */
    function _warpBlock(uint256 timestamp_) internal {
        if (timestamp_ == block.timestamp) return;
        if (timestamp_ < block.timestamp) revert InvalidTimestamp();

        vm.roll(block.number + ((timestamp_ - block.timestamp) / _TIME_PER_BLOCK));
        vm.warp(timestamp_);
    }
}
