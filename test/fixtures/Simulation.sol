// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {stdJson} from "forge-std/StdJson.sol";
import {Vm} from "forge-std/Vm.sol";

abstract contract Action {
    // =======
    // Storage
    // =======

    uint256 internal _timestamp;
    string internal _description;

    // ===========
    // Constructor
    // ===========

    constructor(uint256 timestamp_, string memory description_) {
        _timestamp = timestamp_;
        _description = description_;
    }

    // ==============
    // Public methods
    // ==============

    // Performs the action.
    function act() external virtual;

    // Returns a description of what the action does (used for logging purposes).
    function description() external view returns (string memory name_) {
        return _description;
    }

    // Defines at which time during the simulation this action should be performed.
    function timestamp() external view returns (uint256 timestamp_) {
        return _timestamp;
    }
}

contract Logger {
    using stdJson for string;

    // =========
    // Constants
    // =========

    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    // =======
    // Structs
    // =======

    struct Log {
        string key;
        string value;
    }

    // =======
    // Storage
    // =======

    Log[] internal _logs;
    string internal _filePath = "";

    // ===========
    // Constructor
    // ===========

    constructor(string memory filePath_) {
        _filePath = filePath_;
    }

    // ==============
    // Public methods
    // ==============

    function log(string memory key, string memory value) external {
        _logs.push(Log({key: key, value: value}));
    }

    function write() external {
        bytes[] memory logs = new bytes[](_logs.length);

        for (uint256 i = 0; i < _logs.length; i++) {
            logs[i] = abi.encodePacked(_logs[i].key, _logs[i].value);
        }

        string memory output = vm.serializeBytes("logs", "logs", logs);
        output.write(_filePath);
    }
}

contract Simulation {
    // =========
    // Constants
    // =========

    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    // ======
    // Errors
    // ======

    error NoActions();

    // =======
    // Storage
    // =======

    uint256 internal _logCounter;
    uint256 internal _actionIndex;
    uint256 internal _endTimestamp;

    Action[] internal _actions;
    Logger[] internal _loggers;

    // ==============
    // Public methods
    // ==============

    function registerLogger(Logger logger_) external {
        _loggers.push(logger_);
    }

    function addAction(Action action_) external {
        _actions.push(action_);
    }

    function addActions(Action[] memory actions_) external {
        for (uint256 i = 0; i < actions_.length; ++i) {
            _actions.push(actions_[i]);
        }
    }

    function runSimulation(uint256 timestep_) external {
        // Sort all actions based on their timestamp.
        if (_actions.length == 0) revert NoActions();

        for (uint256 i = 0; i < _actions.length - 1; ++i) {
            for (uint256 j = 0; j < _actions.length - 1 - i; ++j) {
                if (_actions[j].timestamp() > _actions[j + 1].timestamp()) {
                    (_actions[j], _actions[j + 1]) = (_actions[j + 1], _actions[j]);
                }
            }
        }

        _endTimestamp = _actions[_actions.length - 1].timestamp() + 1 days;

        // Snapshot the initial state of the simulation.
        vm.warp(block.timestamp);
        _writeLog("");

        while (true) {
            // Calculate when the next snapshot will be taken.
            uint256 nextTimestamp_ = block.timestamp + timestep_;

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

                // Perform the action and take a snapshot of the state afterwards.
                vm.warp(nextAction_.timestamp());
                nextAction_.act();
                _writeLog(nextAction_.description());

                // Increment the counter to point to the next action.
                ++_actionIndex;
            }

            // Take the snapshot.
            vm.warp(nextTimestamp_);
            _writeLog("");

            // If we are at the end, terminate the simulation.
            if (block.timestamp == _endTimestamp) break;
        }

        // Store all logs permanently.
        for (uint256 i = 0; i < _loggers.length; i++) {
            _loggers[i].write();
        }
    }

    // =========
    // Utilities
    // =========

    function _writeLog(string memory log_) internal {
        for (uint256 i = 0; i < _loggers.length; i++) {
            _loggers[i].log(_castUInt256toString(_logCounter), log_);
            _logCounter++;
        }
    }

    // =========
    // Utilities
    // =========

    function _castUInt256toString(uint256 value) internal pure returns (string memory str) {
        /// @solidity memory-safe-assembly
        assembly {
            let ptr := add(mload(0x40), 160)
            mstore(0x40, ptr)
            str := sub(ptr, 32)
            mstore(str, 0)

            let end := str

            for {
                let temp := value
            } 1 {

            } {
                str := sub(str, 1)
                mstore8(str, add(48, mod(temp, 10)))
                temp := div(temp, 10)

                if iszero(temp) {
                    break
                }
            }

            let length := sub(end, str)
            str := sub(str, 32)
            mstore(str, length)
        }
    }
}
