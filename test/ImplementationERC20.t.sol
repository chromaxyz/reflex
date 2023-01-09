// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Implementations
import {ImplementationERC20} from "./implementations/abstracts/ImplementationERC20.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationERC20} from "./mocks/MockImplementationERC20.sol";
import {MockImplementationERC20Hub} from "./mocks/MockImplementationERC20Hub.sol";

/**
 * @title Implementation ERC20 Test
 */
contract ImplementationERC20Test is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _TOKEN_HUB_MODULE_ID = 100;
    uint16 internal constant _TOKEN_HUB_MODULE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _TOKEN_HUB_MODULE_VERSION = 1;

    uint32 internal constant _TOKEN_MODULE_ID = 101;
    uint16 internal constant _TOKEN_MODULE_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _TOKEN_MODULE_VERSION = 1;

    string internal constant _TOKEN_A_MODULE_NAME = "TOKEN A";
    string internal constant _TOKEN_A_MODULE_SYMBOL = "TKNA";
    uint8 internal constant _TOKEN_A_MODULE_DECIMALS = 18;

    // =======
    // Storage
    // =======

    MockImplementationERC20Hub public tokenHub;
    MockImplementationERC20Hub public tokenHubProxy;

    MockImplementationERC20 public tokenA;
    MockImplementationERC20 public tokenAProxy;

    VerifyBalanceSum public tokenABalanceSum;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        tokenHub = new MockImplementationERC20Hub(
            _TOKEN_HUB_MODULE_ID,
            _TOKEN_HUB_MODULE_TYPE,
            _TOKEN_HUB_MODULE_VERSION
        );

        tokenA = new MockImplementationERC20(
            _TOKEN_MODULE_ID,
            _TOKEN_MODULE_TYPE,
            _TOKEN_MODULE_VERSION
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(tokenHub);
        moduleAddresses[1] = address(tokenA);
        installerProxy.addModules(moduleAddresses);

        tokenHubProxy = MockImplementationERC20Hub(
            dispatcher.moduleIdToProxy(_TOKEN_HUB_MODULE_ID)
        );

        tokenAProxy = MockImplementationERC20(
            tokenHubProxy.addERC20(
                _TOKEN_MODULE_ID,
                _TOKEN_MODULE_TYPE,
                _TOKEN_A_MODULE_NAME,
                _TOKEN_A_MODULE_SYMBOL,
                _TOKEN_A_MODULE_DECIMALS
            )
        );

        tokenABalanceSum = new VerifyBalanceSum(tokenAProxy);

        _addTargetContract(address(tokenABalanceSum));
    }

    // ==========
    // Invariants
    // ==========

    function invariantMetadata() public {
        assertEq(tokenAProxy.name(), _TOKEN_A_MODULE_NAME);
        assertEq(tokenAProxy.symbol(), _TOKEN_A_MODULE_SYMBOL);
        assertEq(tokenAProxy.decimals(), _TOKEN_A_MODULE_DECIMALS);
    }

    function invariantBalanceSum() public {
        assertEq(tokenAProxy.totalSupply(), tokenABalanceSum.sum());
    }

    // =====
    // Tests
    // =====

    function testMint(uint256 amount_) external {
        tokenAProxy.mint(_users.Alice, amount_);

        assertEq(tokenAProxy.totalSupply(), amount_);
        assertEq(tokenAProxy.balanceOf(_users.Alice), amount_);
    }

    function testBurn(uint256 amountA_, uint256 amountB_) public {
        vm.assume(amountA_ > amountB_);

        tokenAProxy.mint(_users.Alice, amountA_);
        tokenAProxy.burn(_users.Alice, amountB_);

        assertEq(tokenAProxy.totalSupply(), amountA_ - amountB_);
        assertEq(tokenAProxy.balanceOf(_users.Alice), amountA_ - amountB_);
    }

    function testApprove(uint256 amount_) public {
        assertTrue(tokenAProxy.approve(_users.Alice, amount_));
        assertEq(tokenAProxy.allowance(address(this), _users.Alice), amount_);
    }

    function testTransfer(uint256 amount_) public {
        tokenAProxy.mint(address(this), amount_);

        assertTrue(tokenAProxy.transfer(_users.Alice, amount_));
        assertEq(tokenAProxy.totalSupply(), amount_);

        assertEq(tokenAProxy.balanceOf(address(this)), 0);
        assertEq(tokenAProxy.balanceOf(_users.Alice), amount_);
    }

    // function testTransferFrom(address from_, uint256 amount_) public {
    //     vm.assume(from_ != address(0));

    //     tokenAProxy.mint(from_, amount_);

    //     vm.prank(from_);
    //     tokenAProxy.approve(address(this), amount_);

    //     assertTrue(tokenAProxy.transferFrom(from_, _users.Alice, amount_));
    //     assertEq(tokenAProxy.totalSupply(), amount_);
    //     assertEq(tokenAProxy.allowance(from_, address(this)), 0);
    //     assertEq(tokenAProxy.balanceOf(from_), 0);
    //     assertEq(tokenAProxy.balanceOf(_users.Alice), amount_);
    // }

    // function testInfiniteApproveTransferFrom(address from_, address to_)
    //     public
    // {
    //     vm.assume(from_ != address(0));
    //     vm.assume(to_ != address(0));

    //     tokenAProxy.mint(from_, 1e18);

    //     vm.prank(from_);
    //     tokenAProxy.approve(address(to_), type(uint256).max);

    //     assertTrue(tokenAProxy.transferFrom(from_, to_, 1e18));
    //     assertEq(tokenAProxy.totalSupply(), 1e18);
    //     assertEq(tokenAProxy.allowance(from_, address(to_)), type(uint256).max);
    //     assertEq(tokenAProxy.balanceOf(from_), 0);
    //     assertEq(tokenAProxy.balanceOf(to_), 1e18);
    // }

    // TODO: emphasis on ERC20 implementation

    function testMintBurn() external {
        _expectEmitTransfer(
            address(tokenAProxy),
            address(0),
            _users.Alice,
            100e18
        );
        tokenAProxy.mint(_users.Alice, 100e18);

        assertEq(tokenAProxy.balanceOf(_users.Alice), 100e18);
        assertEq(tokenAProxy.totalSupply(), 100e18);

        _expectEmitTransfer(
            address(tokenAProxy),
            _users.Alice,
            address(0),
            100e18
        );
        tokenAProxy.burn(_users.Alice, 100e18);

        assertEq(tokenAProxy.balanceOf(_users.Alice), 0);
        assertEq(tokenAProxy.totalSupply(), 0);
    }

    function testApproveTransfer() external {
        _expectEmitTransfer(
            address(tokenAProxy),
            address(0),
            _users.Alice,
            100e18
        );
        tokenAProxy.mint(_users.Alice, 100e18);

        assertEq(tokenAProxy.balanceOf(_users.Alice), 100e18);
        assertEq(tokenAProxy.balanceOf(_users.Bob), 0);
        assertEq(tokenAProxy.totalSupply(), 100e18);

        vm.startPrank(_users.Alice);
        _expectEmitApproval(
            address(tokenAProxy),
            _users.Alice,
            _users.Bob,
            100e18
        );
        tokenAProxy.approve(_users.Bob, 100e18);
        vm.stopPrank();

        vm.startPrank(_users.Bob);
        _expectEmitTransfer(
            address(tokenAProxy),
            _users.Alice,
            _users.Bob,
            100e18
        );
        tokenAProxy.transferFrom(_users.Alice, _users.Bob, 100e18);
        assertEq(tokenAProxy.balanceOf(_users.Alice), 0);
        assertEq(tokenAProxy.balanceOf(_users.Bob), 100e18);
        assertEq(tokenAProxy.totalSupply(), 100e18);
        vm.stopPrank();
    }

    function testRevertFailedProxyLog() external {
        vm.expectRevert(ImplementationERC20.ProxyEventEmittanceFailed.selector);
        tokenAProxy.emitTransferEvent(
            address(dispatcher),
            address(0),
            address(0),
            100e18
        );

        vm.expectRevert(ImplementationERC20.ProxyEventEmittanceFailed.selector);
        tokenAProxy.emitApprovalEvent(
            address(dispatcher),
            address(0),
            address(0),
            100e18
        );
    }

    // =========
    // Utilities
    // =========

    function _expectEmitTransfer(
        address emitter_,
        address from_,
        address to_,
        uint256 amount_
    ) internal BrutalizeMemory {
        bytes32 message = bytes32(amount_);
        uint256 messageLength = message.length;

        bytes32 topic1 = bytes32(
            keccak256(bytes("Transfer(address,address,uint256"))
        );
        bytes32 topic2 = bytes32(uint256(uint160(from_)));
        bytes32 topic3 = bytes32(uint256(uint160(to_)));

        vm.expectEmit(true, true, true, true, emitter_);
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log3(ptr, messageLength, topic1, topic2, topic3)
        }
    }

    function _expectEmitApproval(
        address emitter_,
        address owner_,
        address spender_,
        uint256 amount_
    ) internal BrutalizeMemory {
        bytes32 message = bytes32(amount_);
        uint256 messageLength = message.length;

        bytes32 topic1 = bytes32(
            keccak256(bytes("Approval(address,address,uint256)"))
        );
        bytes32 topic2 = bytes32(uint256(uint160(owner_)));
        bytes32 topic3 = bytes32(uint256(uint160(spender_)));

        vm.expectEmit(true, true, true, true, emitter_);
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log3(ptr, messageLength, topic1, topic2, topic3)
        }
    }
}

contract VerifyBalanceSum {
    // =======
    // Storage
    // =======

    MockImplementationERC20 public token;
    uint256 public sum;

    // ===========
    // Constructor
    // ===========

    constructor(MockImplementationERC20 _token) {
        token = _token;
    }

    // ==========
    // Test stubs
    // ==========

    function mint(address from, uint256 amount) public {
        token.mint(from, amount);
        sum += amount;
    }

    function burn(address from, uint256 amount) public {
        token.burn(from, amount);
        sum -= amount;
    }

    function approve(address to, uint256 amount) public {
        token.approve(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public {
        token.transferFrom(from, to, amount);
    }

    function transfer(address to, uint256 amount) public {
        token.transfer(to, amount);
    }
}
