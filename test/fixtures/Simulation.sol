// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {CommonBase} from "forge-std/Base.sol";
import {console2} from "forge-std/console2.sol";
import {StdAssertions} from "forge-std/StdAssertions.sol";

/**
 * @title Logger
 */
contract Logger is CommonBase, StdAssertions {
    // ======
    // Errors
    // ======

    error NoFilePath();

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

    function addHeader(string[] memory header_) external {
        _addHeader(header_);
    }

    function addHeader(string memory header1_) external {
        string[] memory row = new string[](1);
        row[0] = header1_;

        _addHeader(row);
    }

    function addHeader(string memory header1_, string memory header2_) external {
        string[] memory row = new string[](2);
        row[0] = header1_;
        row[1] = header2_;

        _addHeader(row);
    }

    function addHeader(string memory header1_, string memory header2_, string memory header3_) external {
        string[] memory row = new string[](3);
        row[0] = header1_;
        row[1] = header2_;
        row[2] = header3_;

        _addHeader(row);
    }

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

    function addRow(string[] memory row_) external {
        assertTrue(_table.length > 0);
        assertTrue(_table[0].length == row_.length);

        _addRow(row_);
    }

    function addRow(string memory cell1_) external {
        assertTrue(_table.length > 0);
        assertTrue(_table[0].length == 1);

        string[] memory row = new string[](1);
        row[0] = cell1_;

        _addRow(row);
    }

    function addRow(string memory cell1_, string memory cell2_) external {
        assertTrue(_table.length > 0);
        assertTrue(_table[0].length == 2);

        string[] memory row = new string[](2);
        row[0] = cell1_;
        row[1] = cell2_;

        _addRow(row);
    }

    function addRow(string memory cell1_, string memory cell2_, string memory cell3_) external {
        assertTrue(_table.length > 0);
        assertTrue(_table[0].length == 3);

        string[] memory row = new string[](3);
        row[0] = cell1_;
        row[1] = cell2_;
        row[2] = cell3_;

        _addRow(row);
    }

    function addRow(string memory cell1_, string memory cell2_, string memory cell3_, string memory cell4_) external {
        assertTrue(_table.length > 0);
        assertTrue(_table[0].length == 4);

        string[] memory row = new string[](4);
        row[0] = cell1_;
        row[1] = cell2_;
        row[2] = cell3_;
        row[3] = cell4_;

        _addRow(row);
    }

    function addRow(
        string memory cell1_,
        string memory cell2_,
        string memory cell3_,
        string memory cell4_,
        string memory cell5_
    ) external {
        assertTrue(_table.length > 0);
        assertTrue(_table[0].length == 5);

        string[] memory row = new string[](5);
        row[0] = cell1_;
        row[1] = cell2_;
        row[2] = cell3_;
        row[3] = cell4_;
        row[4] = cell5_;

        _addRow(row);
    }

    function writeFile() external {
        try vm.readLine(_filePath) {
            vm.removeFile(_filePath);
        } catch {}

        string[][] storage table = _table;

        for (uint256 line = 0; line < table.length; line++) {
            vm.writeLine(_filePath, _generateTableLineFromArray(_table[line]));
        }

        console2.log("Wrote table to:", _filePath);
    }

    // ================
    // Internal methods
    // ================

    function _addHeader(string[] memory header_) internal {
        delete _table;

        _addRow(header_);
    }

    function _addRow(string[] memory row_) internal {
        assertTrue(_validateAllRowCellsHaveValues(row_));

        _table.push(row_);
    }

    function _generateTableLineFromArray(string[] memory array_) internal pure returns (string memory line_) {
        for (uint256 i = 0; i < array_.length; i++) {
            line_ = i == 0 ? array_[i] : string(abi.encodePacked(line_, ",", array_[i]));
        }
    }

    function _validateAllRowCellsHaveValues(string[] memory row_) internal pure returns (bool allHaveValues_) {
        for (uint256 i = 0; i < row_.length; i++) {
            string memory cell = row_[i];

            if (bytes(cell).length == 0) return false;
        }

        return true;
    }
}

/**
 * @title Action
 */
abstract contract Action {
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
 * @title Simulation
 */
abstract contract Simulation is CommonBase, StdAssertions {
    // ======
    // Errors
    // ======

    error NoDescription();

    error NoLogger();

    error InvalidTimestep();

    error NoActions();

    // =======
    // Storage
    // =======

    Logger internal _logger;
    string internal _description;
    uint256 internal _timestep;

    Action[] internal _actions;
    uint256 internal _actionIndex;
    uint256 internal _endTimestamp;

    // ===========
    // Constructor
    // ===========

    /**
     * @param logger_ Simulation logger.
     * @param description_ Simulation description.
     * @param timestep_ Timestep per cycle.

     */
    constructor(Logger logger_, string memory description_, uint256 timestep_) {
        if (address(logger_) == address(0)) revert NoLogger();
        if (bytes(description_).length == 0) revert NoDescription();
        if (timestep_ == 0) revert InvalidTimestep();

        _logger = logger_;
        _description = description_;
        _timestep = timestep_;
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

        // Sort all actions based on their timestamp.
        if (_actions.length == 0) revert NoActions();

        console2.log("Running", _actions.length, "actions with timestep:", _timestep);

        for (uint256 i = 0; i < _actions.length - 1; ++i) {
            for (uint256 j = 0; j < _actions.length - 1 - i; ++j) {
                if (_actions[j].timestamp() > _actions[j + 1].timestamp()) {
                    (_actions[j], _actions[j + 1]) = (_actions[j + 1], _actions[j]);
                }
            }
        }

        // Register final timestamp for simulation termination.
        _endTimestamp = _actions[_actions.length - 1].timestamp();

        // Snapshot the initial state of the simulation.
        vm.warp(block.timestamp);
        start();

        console2.log("Starting timestamp @", block.timestamp);

        while (true) {
            // Calculate when the next snapshot will be taken.
            uint256 nextTimestamp_ = block.timestamp + _timestep;

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
                vm.warp(nextAction_.timestamp());

                // Perform the action.
                console2.log("Running", nextAction_.description(), "@", block.timestamp);
                nextAction_.run();

                // Increment the counter to point to the next action.
                ++_actionIndex;
            }

            // Warp to timestamp.
            vm.warp(nextTimestamp_);

            // Capture state snapshot.
            snapshot();

            // If we are at the end, terminate the simulation.
            if (block.timestamp == _endTimestamp) break;
        }

        // Snapshot the final state of the simulation.
        vm.warp(block.timestamp);
        end();
        console2.log("Ending timestamp @", block.timestamp);

        // Write to disk
        _logger.writeFile();
    }
}
