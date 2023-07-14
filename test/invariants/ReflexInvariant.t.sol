// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
// solhint-disable-next-line no-console
import {console2} from "forge-std/console2.sol";
import {Test} from "forge-std/Test.sol";

// Invariants
import {ReflexInvariantHandler} from "./ReflexInvariantHandler.sol";

/**
 * @title Reflex Invariant Test
 */
contract ReflexInvariantTest is Test {
    // =======
    // Storage
    // =======

    ReflexInvariantHandler public handler;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        handler = new ReflexInvariantHandler();
        handler.setUp();

        targetContract(address(handler));

        bytes4[] memory selectors = new bytes4[](4);
        selectors[0] = ReflexInvariantHandler.warp.selector;
        selectors[1] = ReflexInvariantHandler.transferOwnership.selector;
        selectors[2] = ReflexInvariantHandler.acceptOwnership.selector;
        selectors[3] = ReflexInvariantHandler.renounceOwnership.selector;
        // selectors[4] = ReflexInvariantHandler.addModules.selector;
        // selectors[5] = ReflexInvariantHandler.upgradeModules.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
    }

    // ===============
    // Invariant stubs
    // ===============

    // If nonReentrant method is entered, reentrancy status should be locked.
    // If a method not tagged as nonReentrant is entered, reentrancy status should be unlocked.

    function invariantA() external {
        // solhint-disable-next-line no-console
        console2.log("# INVARIANT: A #");
    }

    function invariantB() external {
        // solhint-disable-next-line no-console
        console2.log("# INVARIANT: B #");
    }

    function invariantCreateLog() external {
        /* solhint-disable no-console */
        console2.log("# CALL SUMMARY #");

        console2.log("warp", handler.getCallCount("warp"));
        /* solhint-enable no-console */
    }
}
