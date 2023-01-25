// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {BoundedHandler, UnboundedHandler} from "../../fixtures/InvariantHarness.sol";

// Mocks
import {MockImplementationERC20} from "../../mocks/MockImplementationERC20.sol";

// ==================
// Invariant handlers
// ==================

// // ==========
// // Invariants
// // ==========

// function invariantMetadata() public {
//     assertEq(tokenProxy.name(), _TOKEN_MODULE_NAME);
//     assertEq(tokenProxy.symbol(), _TOKEN_MODULE_SYMBOL);
//     assertEq(tokenProxy.decimals(), _TOKEN_MODULE_DECIMALS);
// }

// function invariantBalanceSum() public {
//     assertEq(tokenProxy.totalSupply(), tokenInvariant.sum());
// }

// function invariantLogDump() public {
//     console2.log("\nCall Summary\n");

//     console2.log("unbounded.mint", tokenInvariant.getCallCount("unbounded.mint"));
//     console2.log("unbounded.burn", tokenInvariant.getCallCount("unbounded.burn"));
//     console2.log("unbounded.approve", tokenInvariant.getCallCount("unbounded.approve"));
//     console2.log("unbounded.transfer", tokenInvariant.getCallCount("unbounded.transfer"));
//     console2.log("unbounded.transferFrom", tokenInvariant.getCallCount("unbounded.transferFrom"));

//     console2.log("bounded.mint", tokenInvariant.getCallCount("bounded.mint"));
//     console2.log("bounded.burn", tokenInvariant.getCallCount("bounded.burn"));
//     console2.log("bounded.approve", tokenInvariant.getCallCount("bounded.approve"));
//     console2.log("bounded.transfer", tokenInvariant.getCallCount("bounded.transfer"));
//     console2.log("bounded.transferFrom", tokenInvariant.getCallCount("bounded.transferFrom"));
// }

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
        increaseCallCount("bounded.mint");

        super.mint(from_, amount_);
    }

    function burn(address from_, uint256 amount_) public override {
        increaseCallCount("bounded.burn");

        super.burn(from_, amount_);
    }

    function approve(address to_, uint256 amount_) public override {
        increaseCallCount("bounded.approve");

        super.approve(to_, amount_);
    }

    function transferFrom(address from_, address to_, uint256 amount_) public override {
        increaseCallCount("bounded.transferFrom");

        super.transferFrom(from_, to_, amount_);
    }

    function transfer(address to_, uint256 amount_) public override {
        increaseCallCount("bounded.transfer");

        super.transfer(to_, amount_);
    }
}
