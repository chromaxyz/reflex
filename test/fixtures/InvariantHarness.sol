// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {InvariantTest} from "forge-std/InvariantTest.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {Test} from "forge-std/Test.sol";

// Fixtures
import {Users} from "./Users.sol";

/**
 * @title Invariant Harness
 * @dev A rigorous invariant harness.
 */
abstract contract InvariantHarness is Users, Test, InvariantTest {
    // =======
    // Storage
    // =======

    uint256 internal _currentTimestamp;
    uint256[] internal _timestamps;
    uint256 internal _timestampCount;

    // =========
    // Modifiers
    // =========

    modifier useCurrentTimestamp() {
        vm.warp(_currentTimestamp);
        _;
    }

    // ==============
    // Public methods
    // ==============

    function currentTimestamp() external view returns (uint256) {
        return _currentTimestamp;
    }

    function setCurrentTimestamp(uint256 currentTimestamp_) external {
        _timestamps.push(currentTimestamp_);
        _timestampCount++;
        _currentTimestamp = currentTimestamp_;
    }
}

/**
 * @title Unbounded Handler
 * @dev Abstract unbounded handler to inherit in invariant tests.
 * @dev Returns on failure.
 */
abstract contract UnboundedHandler is Users, StdUtils {
    // =======
    // Storage
    // =======

    uint256 public callCount;

    mapping(bytes32 => uint256) public callCounters;
}

/**
 * @title Bounded Handler
 * @dev Abstract bounded handler to inherit in invariant tests.
 * @dev Reverts on failure.
 */
abstract contract BoundedHandler is UnboundedHandler {

}
