// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {console2} from "forge-std/console2.sol";

// Fixtures
import {InvariantTestHarness} from "../fixtures/InvariantTestHarness.sol";

// Tests
import {IImplementationERC20HandlerLike, BoundedImplementationERC20Handler, UnboundedImplementationERC20Handler, ImplementationERC20Test} from "../ImplementationERC20.t.sol";

/**
 * @title Base Invariant Test
 */
contract BaseInvariantTest is InvariantTestHarness {
    ImplementationERC20Test public base;
    IImplementationERC20HandlerLike public handler;

    function setUp() public virtual override {
        super.setUp();

        base = new ImplementationERC20Test();
        base.setUp();
    }

    // ==========
    // Invariants
    // ==========

    function _invariantA() internal {
        assertEq(base.tokenProxy().name(), base._TOKEN_MODULE_NAME());
        assertEq(base.tokenProxy().symbol(), base._TOKEN_MODULE_SYMBOL());
        assertEq(base.tokenProxy().decimals(), base._TOKEN_MODULE_DECIMALS());
    }

    function _invariantB() internal {
        assertEq(base.tokenProxy().totalSupply(), handler.sum());
    }

    function _createLog() public {
        console2.log("\nCall Summary\n");

        console2.log("unbounded.mint", handler.getCallCount("unbounded.mint"));
        console2.log("unbounded.burn", handler.getCallCount("unbounded.burn"));
        console2.log("unbounded.approve", handler.getCallCount("unbounded.approve"));
        console2.log("unbounded.transfer", handler.getCallCount("unbounded.transfer"));
        console2.log("unbounded.transferFrom", handler.getCallCount("unbounded.transferFrom"));

        console2.log("bounded.mint", handler.getCallCount("bounded.mint"));
        console2.log("bounded.burn", handler.getCallCount("bounded.burn"));
        console2.log("bounded.approve", handler.getCallCount("bounded.approve"));
        console2.log("bounded.transfer", handler.getCallCount("bounded.transfer"));
        console2.log("bounded.transferFrom", handler.getCallCount("bounded.transferFrom"));
    }
}

/**
 * @title Unbounded Invariant Test
 */
contract UnboundedInvariantTest is BaseInvariantTest {
    function setUp() public virtual override {
        super.setUp();

        console2.log(address(base.tokenProxy()));

        handler = IImplementationERC20HandlerLike(address(new UnboundedImplementationERC20Handler(base.tokenProxy())));

        targetContract(address(handler));
    }

    function invariantA() external {
        _invariantA();
    }

    function invariantB() external {
        _invariantB();
    }

    function invariantCreateLog() external {
        _createLog();
    }
}

/**
 * @title Bounded Invariant Test
 */
contract BoundedInvariantTest is BaseInvariantTest {
    function setUp() public virtual override {
        super.setUp();

        handler = IImplementationERC20HandlerLike(address(new BoundedImplementationERC20Handler(base.tokenProxy())));

        targetContract(address(handler));

        targetSender(_users.Alice);
        targetSender(_users.Bob);
        targetSender(_users.Caroll);
        targetSender(_users.Dave);
    }

    function invariantA() external {
        _invariantA();
    }

    function invariantB() external {
        _invariantB();
    }

    function invariantDumpLog() external {
        _createLog();
    }
}
