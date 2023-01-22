// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {CommonBase} from "forge-std/Base.sol";
import {console2} from "forge-std/console2.sol";
import {StdAssertions} from "forge-std/StdAssertions.sol";
import {Vm} from "forge-std/Vm.sol";

/**
 * @title Logger
 */
contract Logger {
    // ======
    // Errors
    // ======

    error NoFilename();

    // =======
    // Structs
    // =======

    struct Log {
        uint256 blockTimestamp;
        string message;
    }

    // =======
    // Storage
    // =======

    Log[] internal _logs;

    string internal _fileName;

    // ===========
    // Constructor
    // ===========

    /**
     * @param fileName_ File name of file to write to.
     */
    constructor(string memory fileName_) {
        if (bytes(fileName_).length == 0) revert NoFilename();

        _fileName = fileName_;
    }

    // ==============
    // Public methods
    // ==============

    /**
     * @dev Returns the file name to which the log will be written.
     */
    function fileName() public view returns (string memory) {
        return _fileName;
    }

    /**
     * @dev Returns all logs captured until now.
     */
    function logs() public view returns (Log[] memory) {
        return _logs;
    }

    // =========
    // Utilities
    // =========

    /**
     * @dev Write to logs.
     */
    function writeLog(string memory message_) external {
        _logs.push(Log({blockTimestamp: block.timestamp, message: message_}));
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

        // Collect all logs and encode.
        bytes[] memory logs = new bytes[](_logger.logs().length);

        // Write logs to serializable structure.
        for (uint256 i = 0; i < _logger.logs().length; i++) {
            logs[i] = abi.encode(_logger.logs()[i].blockTimestamp, _logger.logs()[i].message);
        }

        vm.serializeString("simulation", "encoding", "(uint256,string)");
        vm.serializeString("simulation", "header", "blockTimestamp,message");
        vm.serializeString("simulation", "description", _description);

        // Encoding:
        // - blockTimestamp: `uint256`
        // - message: `string`
        string memory output = vm.serializeBytes("simulation", "logs", logs);

        console2.log("Serialized", _logger.logs().length, "log entries");
        console2.log("Ending timestamp @", block.timestamp);
        console2.log("Finished running", _actions.length, "actions");

        // Write to disk.
        vm.writeJson(output, string.concat("simulations/", _logger.fileName(), ".json"));

        console2.log("Wrote log to:", string.concat("simulations/", _logger.fileName(), ".json"));
    }
}

/**
 * @title Replay
 */
contract Replay is CommonBase {
    // ======
    // Errors
    // ======

    error NoFileName();

    // =======
    // Storage
    // =======

    string internal _fileName;

    // ===========
    // Constructor
    // ===========

    /**
     * @param fileName_ File name of file to read from.
     */
    constructor(string memory fileName_) {
        if (bytes(fileName_).length == 0) revert NoFileName();

        _fileName = fileName_;
    }

    /**
     * @dev Run the replay.
     */
    function run() external view {
        string memory simulation = vm.readFile(string.concat("simulations/", _fileName, ".json"));
        string memory description = abi.decode(vm.parseJson(simulation, "description"), (string));
        bytes[] memory logs = abi.decode(vm.parseJson(simulation, "logs"), (bytes[]));

        console2.log(description, "\n");

        // Read logs from serialized structure.
        for (uint256 i = 0; i < logs.length; i++) {
            (uint256 blockTimestamp, string memory message) = abi.decode(
                logs[i],
                // Encoding:
                // - blockTimestamp: `uint256`
                // - message: `string`
                (uint256, string)
            );

            console2.log(message, "@", blockTimestamp);
        }
    }
}
