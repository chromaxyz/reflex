// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {BoundedHandler, UnboundedHandler} from "../../fixtures/InvariantTestHarness.sol";

// Mocks
import {MockImplementationERC20} from "../../mocks/MockImplementationERC20.sol";

// ==================
// Invariant handlers
// ==================

/**
 * @title Implementation ERC20 Handler Interface
 */
interface IImplementationERC20HandlerLike {
    function getCallCount(bytes32 message) external returns (uint256);

    function sum() external returns (uint256);

    function mint(address from, uint256 amount) external;

    function burn(address from, uint256 amount) external;

    function approve(address to, uint256 amount) external;

    function transferFrom(address from, address to, uint256 amount) external;

    function transfer(address to, uint256 amount) external;
}

/**
 * @title Unbounded Implementation ERC20 Handler
 */
contract UnboundedImplementationERC20Handler is UnboundedHandler {
    // =======
    // Storage
    // =======

    MockImplementationERC20 public token;

    uint256 public sum;

    // ===========
    // Constructor
    // ===========

    constructor(MockImplementationERC20 token_) {
        token = token_;
    }

    // ==========
    // Test stubs
    // ==========

    function mint(address from_, uint256 amount_) public virtual {
        increaseCallCount("unbounded.mint");

        token.mint(from_, amount_);
        sum += amount_;
    }

    function burn(address from_, uint256 amount_) public virtual {
        increaseCallCount("unbounded.burn");

        token.burn(from_, amount_);
        sum -= amount_;
    }

    function approve(address to_, uint256 amount_) public virtual {
        increaseCallCount("unbounded.approve");

        token.approve(to_, amount_);
    }

    function transferFrom(address from_, address to_, uint256 amount_) public virtual {
        increaseCallCount("unbounded.transferFrom");

        token.transferFrom(from_, to_, amount_);
    }

    function transfer(address to_, uint256 amount_) public virtual {
        increaseCallCount("unbounded.transfer");

        token.transfer(to_, amount_);
    }
}

/**
 * @title Bounded Implementation ERC20 Handler
 */
contract BoundedImplementationERC20Handler is UnboundedImplementationERC20Handler, BoundedHandler {
    // ===========
    // Constructor
    // ===========

    constructor(MockImplementationERC20 token_) UnboundedImplementationERC20Handler(token_) {}

    // ==========
    // Test stubs
    // ==========

    function mint(address from_, uint256 amount_) public override {
        if (type(uint256).max - token.totalSupply() == 0) return;

        uint256 boundAmount = bound(amount_, 0, type(uint256).max - token.totalSupply());

        increaseCallCount("bounded.mint");

        super.mint(from_, boundAmount);
    }

    function burn(address from_, uint256 amount_) public override {
        if (amount_ >= token.balanceOf(from_)) {
            mint(from_, amount_);
        }

        if (amount_ >= token.allowance(from_, address(this))) {
            vm.startPrank(from_);
            approve(address(this), amount_);
            vm.stopPrank();
        }

        uint256 boundAmount = bound(amount_, 0, token.balanceOf(from_));

        increaseCallCount("bounded.burn");

        super.burn(from_, boundAmount);
    }

    function approve(address to_, uint256 amount_) public override {
        increaseCallCount("bounded.approve");

        super.approve(to_, amount_);
    }

    function transferFrom(address from_, address to_, uint256 amount_) public override {
        if (amount_ >= token.balanceOf(from_)) {
            mint(from_, amount_);
        }

        if (amount_ >= token.allowance(from_, address(this))) {
            vm.startPrank(from_);
            approve(address(this), amount_);
            vm.stopPrank();
        }

        if (amount_ >= token.allowance(from_, to_)) {
            vm.startPrank(from_);
            approve(to_, amount_);
            vm.stopPrank();
        }

        uint256 boundAmount = bound(amount_, 0, token.balanceOf(from_));

        increaseCallCount("bounded.transferFrom");

        super.transferFrom(from_, to_, boundAmount);
    }

    function transfer(address to_, uint256 amount_) public override {
        vm.startPrank(msg.sender);

        if (amount_ >= token.balanceOf(msg.sender)) {
            mint(msg.sender, amount_);
        }

        if (amount_ >= token.allowance(msg.sender, address(this))) {
            approve(address(this), amount_);
        }

        if (amount_ >= token.allowance(msg.sender, to_)) {
            approve(to_, amount_);
        }

        uint256 boundAmount = bound(amount_, 0, token.balanceOf(msg.sender));

        increaseCallCount("bounded.transfer");

        super.transfer(to_, boundAmount);

        vm.stopPrank();
    }
}
