// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {CommonBase} from "forge-std/Base.sol";
import {console2} from "forge-std/console2.sol";
import {StdAssertions} from "forge-std/StdAssertions.sol";
import {Vm} from "forge-std/Vm.sol";

// Simulation
import {Action} from "./Action.sol";
import {Logger} from "./Logger.sol";

/**
 * @title Simulation
 */
abstract contract Simulation is CommonBase, StdAssertions {
    // ======
    // Errors
    // ======

    error NoDescription();

    error InvalidTimestep();

    error NoActions();

    // =======
    // Storage
    // =======

    Logger internal _logger;
    Action[] internal _actions;

    string internal _description;
    uint256 internal _timestep;

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
        if (bytes(description_).length == 0) revert NoDescription();
        if (timestep_ == 0) revert InvalidTimestep();

        _logger = logger_;
        _description = description_;
        _timestep = timestep_;
    }

    // ==============
    // Public methods
    // ==============

    function start() public virtual {}

    function end() public virtual {}

    function snapshot() public virtual {}

    function add(Action[] memory actions_) external {
        for (uint256 i = 0; i < actions_.length; ++i) {
            _actions.push(actions_[i]);
        }
    }

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

        vm.serializeString("simulation", "encoding", "(uint256,uint256,string)");
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
        vm.writeJson(output, string.concat("simulations/", _logger.filename(), ".json"));

        console2.log("Wrote log to:", string.concat("simulations/", _logger.filename(), ".json"));
    }
}
