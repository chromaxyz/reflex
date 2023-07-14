// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
// solhint-disable-next-line no-console
import {console2} from "forge-std/console2.sol";
import {Test} from "forge-std/Test.sol";

// Invariants
import {IInvariantHandler} from "./InvariantHandler.sol";

/**
 * @title Invariant Base
 */
contract InvariantBase is Test {
    // =======
    // Storage
    // =======

    IInvariantHandler public handler;

    // =====
    // Setup
    // =====

    function setUp() public virtual {}

    function _invariantA() internal view {
        // solhint-disable-next-line no-console
        console2.log("# INVARIANT: A #");
    }

    function _invariantB() internal view {
        // solhint-disable-next-line no-console
        console2.log("# INVARIANT: B #");
    }

    function _createLog() internal {
        /* solhint-disable no-console */
        console2.log("# CALL SUMMARY #");

        console2.log("warp", handler.getCallCount("warp"));
        /* solhint-enable no-console */
    }
}
