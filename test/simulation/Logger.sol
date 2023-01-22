// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

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
    string internal _filename;

    // ===========
    // Constructor
    // ===========

    /**
     * @param filename_ File name to read from.
     */
    constructor(string memory filename_) {
        if (bytes(filename_).length == 0) revert NoFilename();

        _filename = filename_;
    }

    // ==============
    // Public methods
    // ==============

    function filename() public view returns (string memory) {
        return _filename;
    }

    function logs() public view returns (Log[] memory) {
        return _logs;
    }

    // =========
    // Utilities
    // =========

    function writeLog(string memory message_) public {
        _logs.push(Log({blockTimestamp: block.timestamp, message: message_}));
    }
}
