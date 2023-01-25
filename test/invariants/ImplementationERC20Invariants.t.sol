// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {InvariantTestHarness} from "../fixtures/InvariantTestHarness.sol";

// Handlers
import {IImplementationERC20HandlerLike, BoundedImplementationERC20Handler, UnboundedImplementationERC20Handler} from "./handlers/ImplementationERC20Handler.sol";

// Tests
import {ImplementationERC20Test} from "../ImplementationERC20.t.sol";

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
}

/**
 * @title Unbounded Invariant Test
 */
contract UnboundedInvariantTest is BaseInvariantTest {
    function setUp() public virtual override {
        super.setUp();

        handler = IImplementationERC20HandlerLike(address(new UnboundedImplementationERC20Handler(base.tokenProxy())));

        targetContract(address(handler));
    }

    function invariantA() external {
        _invariantA();
    }

    function invariantB() external {
        _invariantB();
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
    }

    function invariantA() external {
        _invariantA();
    }

    function invariantB() external {
        _invariantB();
    }
}
