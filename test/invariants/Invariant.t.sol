// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Invariants
import {InvariantBase} from "./InvariantBase.sol";
import {IInvariantHandler, InvariantHandler} from "./InvariantHandler.sol";

// Fixtures
import {BoundedHandler} from "../fixtures/TestHarness.sol";

/**
 * @title  Unbounded Invariant Test
 */
contract UnboundedInvariantTest is InvariantBase {
    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        handler = IInvariantHandler(address(new UnboundedInvariantHandler()));
        handler.setUp();

        targetContract(address(handler));

        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = UnboundedInvariantHandler.warp.selector;

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
 * @title  Unbounded Invariant Test
 */
contract BoundedInvariantTest is InvariantBase {
    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        handler = IInvariantHandler(address(new BoundedInvariantHandler()));
        handler.setUp();

        targetContract(address(handler));

        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = BoundedInvariantHandler.warp.selector;

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
contract UnboundedInvariantHandler is InvariantHandler {
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
contract BoundedInvariantHandler is UnboundedInvariantHandler, BoundedHandler {
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
