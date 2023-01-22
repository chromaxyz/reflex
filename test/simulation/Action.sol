// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Simulation
import {Logger} from "./Logger.sol";

/**
 * @title Action
 */
abstract contract Action {
    // =======
    // Storage
    // =======

    Logger internal _logger;

    uint256 internal _timestamp;
    string internal _description;

    // ===========
    // Constructor
    // ===========

    /**
     * @param logger_ Action logger.
     * @param timestamp_ Timestamp of the action.
     * @param description_ Description of the action.
     */
    constructor(Logger logger_, uint256 timestamp_, string memory description_) {
        _logger = logger_;
        _timestamp = timestamp_;
        _description = description_;
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
