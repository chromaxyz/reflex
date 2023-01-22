// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {CommonBase} from "forge-std/Base.sol";
import {console2} from "forge-std/console2.sol";

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

    string internal _filename;

    // ===========
    // Constructor
    // ===========

    /**
     * @param filename_ File name to read from.
     */
    constructor(string memory filename_) {
        if (bytes(filename_).length == 0) revert NoFileName();

        _filename = filename_;
    }

    function run() external view {
        string memory simulation = vm.readFile(string.concat("simulations/", _filename, ".json"));
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
