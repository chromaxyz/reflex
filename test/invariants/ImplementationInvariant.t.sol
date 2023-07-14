// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
// solhint-disable-next-line no-console
import {console2} from "forge-std/console2.sol";
import {Test} from "forge-std/Test.sol";

// Invariants
import {IInvariantHandler, InvariantHandler} from "./InvariantHandler.sol";

// Fixtures
import {BoundedHandler} from "../fixtures/TestHarness.sol";

/**
 * @title Implementation Invariant Base
 */
contract ImplementationInvariantBase is Test {
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

/**
 * @title Implementation Unbounded Invariant Test
 */
contract ImplementationUnboundedInvariantTest is ImplementationInvariantBase {
    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        handler = IInvariantHandler(address(new ImplementationUnboundedInvariantHandler()));
        handler.setUp();

        targetContract(address(handler));

        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = ImplementationUnboundedInvariantHandler.warp.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
    }

    // ===============
    // Invariant stubs
    // ===============

    function invariantA() external view {
        _invariantA();
    }

    function invariantB() external view {
        _invariantB();
    }

    function invariantCreateLog() external {
        _createLog();
    }
}

/**
 * @title Implementation Unbounded Invariant Test
 */
contract ImplementationBoundedInvariantTest is ImplementationInvariantBase {
    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        handler = IInvariantHandler(address(new ImplementationBoundedInvariantHandler()));
        handler.setUp();

        targetContract(address(handler));

        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = ImplementationBoundedInvariantHandler.warp.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
    }

    // ===============
    // Invariant stubs
    // ===============

    function invariantA() external view {
        _invariantA();
    }

    function invariantB() external view {
        _invariantB();
    }

    function invariantCreateLog() external {
        _createLog();
    }
}

/**
 * @title Unbounded Invariant Handler
 */
contract ImplementationUnboundedInvariantHandler is InvariantHandler {
    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();
    }

    // =================
    // Invariant methods
    // =================

    function warp(uint256 warpTime_) public virtual countCall("warp") useCurrentTimestamp {
        warpTime_ = bound(warpTime_, 1, 100 days);
        setCurrentTimestamp(block.timestamp + warpTime_);
        vm.warp(_currentTimestamp);
    }
}

/**
 * @title Bounded Invariant Handler
 */
contract ImplementationBoundedInvariantHandler is ImplementationUnboundedInvariantHandler, BoundedHandler {
    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();
    }

    // =================
    // Invariant methods
    // =================

    function warp(uint256 warpTime_) public virtual override {
        super.warp(warpTime_);
    }
}
