// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {console2} from "forge-std/console2.sol";
import {StdAssertions} from "forge-std/StdAssertions.sol";
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

    /**
     * @param timestamp_ Timestamp of the action.
     * @param description_ Description of the action.
     */
    constructor(uint256 timestamp_, string memory description_) {
        _timestamp = timestamp_;
        _description = description_;
    }

    // ==============
    // Public methods
    // ==============

    /**
     * @dev Performs the action.
     */
    function act() external virtual;

    /**
     * @dev Returns a description of what the action does (used for logging purposes).
     */
    function description() external view returns (string memory name_) {
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
 * @author `Simulation` as a concept has been inspired by: Compound V2 (https://github.com/compound-finance/compound-protocol/tree/master/scenario)
 * @author `Simulation` has been inspired by: Maple Core V2 (https://github.com/maple-labs/maple-core-v2/blob/aebc14ba7704da31cae8c7fe0c06d6a3396a600a/contracts/PoolSimulation.sol)
 */
contract Simulation is StdAssertions {
    // ======
    // Cheats
    // ======

    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    // =========
    // Constants
    // =========

    uint256 private constant _TIME_PER_BLOCK = 12 seconds;

    // ======
    // Errors
    // ======

    error NoFilePath();

    error InvalidTimestep();

    error NoActions();

    // =======
    // Structs
    // =======

    struct Log {
        uint256 blockTimestamp;
        uint256 blockNumber;
        string message;
    }

    // =======
    // Storage
    // =======

    string internal _filePath;
    uint256 internal _simulationTimestep;
    uint256 internal _simulationTimestepPadding;

    Action[] internal _actions;
    Log[] internal _logs;

    uint256 internal _actionIndex;
    uint256 internal _endTimestamp;

    // ===========
    // Constructor
    // ===========

    /**
     * @param filePath_ Path to output file.
     * @param simulationTimestep_ Timestep per cycle.
     * @param simulationTimestepPadding_ Time padding at the end of the simulation.
     */
    constructor(string memory filePath_, uint256 simulationTimestep_, uint256 simulationTimestepPadding_) {
        if (bytes(filePath_).length == 0) revert NoFilePath();
        if (simulationTimestep_ == 0) revert InvalidTimestep();

        _filePath = filePath_;
        _simulationTimestep = simulationTimestep_;
        _simulationTimestepPadding = simulationTimestepPadding_;
    }

    // ==============
    // Public methods
    // ==============

    function add(Action[] memory actions_) external {
        for (uint256 i = 0; i < actions_.length; ++i) {
            _actions.push(actions_[i]);
            console2.log("Added action:", actions_[i].description(), "@ timestamp", actions_[i].timestamp());
        }
    }

    function run() external {
        // Sort all actions based on their timestamp.
        if (_actions.length == 0) revert NoActions();

        console2.log("Running", _actions.length, "actions with timestep:", _simulationTimestep);

        for (uint256 i = 0; i < _actions.length - 1; ++i) {
            for (uint256 j = 0; j < _actions.length - 1 - i; ++j) {
                if (_actions[j].timestamp() > _actions[j + 1].timestamp()) {
                    (_actions[j], _actions[j + 1]) = (_actions[j + 1], _actions[j]);
                }
            }
        }

        _endTimestamp = _actions[_actions.length - 1].timestamp() + _simulationTimestepPadding;

        // Snapshot the initial state of the simulation.
        _warpBlock(block.timestamp);
        _logs.push(Log({blockTimestamp: block.timestamp, blockNumber: block.number, message: "start"}));

        console2.log("Starting timestamp:", block.timestamp, "@ block", block.number);

        while (true) {
            // Calculate when the next snapshot will be taken.
            uint256 nextTimestamp_ = block.timestamp + _simulationTimestep;

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
                _warpBlock(nextAction_.timestamp());
                nextAction_.act();
                _logs.push(
                    Log({
                        blockTimestamp: block.timestamp,
                        blockNumber: block.number,
                        message: nextAction_.description()
                    })
                );

                // Increment the counter to point to the next action.
                ++_actionIndex;
            }

            // Warp to timestamp.
            _warpBlock(nextTimestamp_);
            _logs.push(Log({blockTimestamp: nextTimestamp_, blockNumber: block.number, message: "snapshot"}));

            // If we are at the end, terminate the simulation.
            if (block.timestamp == _endTimestamp) break;
        }

        // Snapshot the final state of the simulation.
        _warpBlock(block.timestamp);
        _logs.push(Log({blockTimestamp: block.timestamp, blockNumber: block.number, message: "end"}));

        // Collect all logs and encode.
        bytes[] memory logs = new bytes[](_logs.length);

        // Write logs to serializable structure.
        for (uint256 i = 0; i < _logs.length; i++) {
            logs[i] = abi.encode(_logs[i].blockTimestamp, _logs[i].blockNumber, _logs[i].message);
        }

        // Encoding:
        // - blockTimestamp: `uint256`
        // - blockNumber: `uint256`
        // - message: `string`
        vm.serializeString("encoding", "encoding", "(uint256,uint256,string)");
        vm.serializeString("encoding", "header", "blockTimestamp,blockNumber,message");
        string memory output = vm.serializeBytes("encoding", "logs", logs);

        console2.log("Ending timestamp:", block.timestamp, "@ block", block.number);

        console2.log("Finished running", _actions.length, "actions");

        // Write to disk.
        vm.writeJson(output, _filePath);
        console2.log("Wrote log to:", _filePath);
    }

    // =========
    // Utilities
    // =========

    function _warpBlock(uint256 timestamp_) internal {
        assertGe(timestamp_, block.timestamp);

        vm.roll(block.number + ((timestamp_ - block.timestamp) / _TIME_PER_BLOCK));
        vm.warp(timestamp_);
    }
}
