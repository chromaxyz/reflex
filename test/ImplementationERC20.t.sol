// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {stdError} from "forge-std/StdError.sol";

// Interfaces
import {IBaseModule} from "../src/interfaces/IBaseModule.sol";

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
    string internal constant _TOKEN_MODULE_NAME = "TOKEN A";
    string internal constant _TOKEN_MODULE_SYMBOL = "TKNA";
    uint8 internal constant _TOKEN_MODULE_DECIMALS = 18;

    // =======
    // Storage
    // =======

    MockImplementationERC20Hub public tokenHub;
    MockImplementationERC20Hub public tokenHubProxy;

    MockImplementationERC20 public token;
    MockImplementationERC20 public tokenProxy;

    InvariantBalanceSum public tokenBalanceSum;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        tokenHub = new MockImplementationERC20Hub(
            IBaseModule.ModuleSettings({
                moduleId: _TOKEN_HUB_MODULE_ID,
                moduleType: _TOKEN_HUB_MODULE_TYPE,
                moduleVersion: _TOKEN_HUB_MODULE_VERSION,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );

        token = new MockImplementationERC20(
            IBaseModule.ModuleSettings({
                moduleId: _TOKEN_MODULE_ID,
                moduleType: _TOKEN_MODULE_TYPE,
                moduleVersion: _TOKEN_MODULE_VERSION,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(tokenHub);
        moduleAddresses[1] = address(token);
        installerProxy.addModules(moduleAddresses);

        tokenHubProxy = MockImplementationERC20Hub(
            dispatcher.moduleIdToProxy(_TOKEN_HUB_MODULE_ID)
        );

        tokenProxy = MockImplementationERC20(
            tokenHubProxy.addERC20(
                _TOKEN_MODULE_ID,
                _TOKEN_MODULE_TYPE,
                _TOKEN_MODULE_NAME,
                _TOKEN_MODULE_SYMBOL,
                _TOKEN_MODULE_DECIMALS
            )
        );

        tokenBalanceSum = new InvariantBalanceSum(tokenProxy);

        _addTargetContract(address(tokenBalanceSum));
    }

    // ==========
    // Invariants
    // ==========

    function invariantMetadata() public {
        assertEq(tokenProxy.name(), _TOKEN_MODULE_NAME);
        assertEq(tokenProxy.symbol(), _TOKEN_MODULE_SYMBOL);
        assertEq(tokenProxy.decimals(), _TOKEN_MODULE_DECIMALS);
    }

    function invariantBalanceSum() public {
        assertEq(tokenProxy.totalSupply(), tokenBalanceSum.sum());
    }

    // =====
    // Tests
    // =====

    function testMetadata() external {
        assertEq(tokenProxy.name(), _TOKEN_MODULE_NAME);
        assertEq(tokenProxy.symbol(), _TOKEN_MODULE_SYMBOL);
        assertEq(tokenProxy.decimals(), _TOKEN_MODULE_DECIMALS);
    }

    function testMint(uint256 amount_) external {
        tokenProxy.mint(_users.Alice, amount_);

        assertEq(tokenProxy.totalSupply(), amount_);
        assertEq(tokenProxy.balanceOf(_users.Alice), amount_);
    }

    function testBurn(uint256 mintAmount_, uint256 burnAmount_) public {
        vm.assume(mintAmount_ > burnAmount_);

        tokenProxy.mint(_users.Alice, mintAmount_);
        tokenProxy.burn(_users.Alice, burnAmount_);

        assertEq(tokenProxy.totalSupply(), mintAmount_ - burnAmount_);
        assertEq(tokenProxy.balanceOf(_users.Alice), mintAmount_ - burnAmount_);
    }

    function testApprove(uint256 amount_) public {
        assertTrue(tokenProxy.approve(_users.Alice, amount_));
        assertEq(tokenProxy.allowance(address(this), _users.Alice), amount_);
    }

    function testTransfer(uint256 amount_) public {
        tokenProxy.mint(address(this), amount_);

        assertTrue(tokenProxy.transfer(_users.Alice, amount_));
        assertEq(tokenProxy.totalSupply(), amount_);
        assertEq(tokenProxy.balanceOf(address(this)), 0);
        assertEq(tokenProxy.balanceOf(_users.Alice), amount_);
    }

    function testTransferFrom(uint256 amount_) public {
        vm.assume(amount_ > 0 && amount_ < type(uint256).max);

        tokenProxy.mint(_users.Alice, amount_);

        vm.prank(_users.Alice);
        tokenProxy.approve(address(this), amount_);

        assertTrue(tokenProxy.transferFrom(_users.Alice, _users.Bob, amount_));
        assertEq(tokenProxy.totalSupply(), amount_);
        assertEq(tokenProxy.allowance(_users.Alice, address(this)), 0);
        assertEq(tokenProxy.balanceOf(_users.Alice), 0);
        assertEq(tokenProxy.balanceOf(_users.Bob), amount_);
    }

    function testInfiniteApproveTransferFrom(uint256 amount_) public {
        vm.assume(amount_ > 0 && amount_ < type(uint256).max);

        tokenProxy.mint(_users.Alice, amount_);

        vm.prank(_users.Alice);
        tokenProxy.approve(address(this), type(uint256).max);

        assertTrue(tokenProxy.transferFrom(_users.Alice, _users.Bob, amount_));
        assertEq(tokenProxy.totalSupply(), amount_);
        assertEq(
            tokenProxy.allowance(_users.Alice, address(this)),
            type(uint256).max
        );
        assertEq(tokenProxy.balanceOf(_users.Alice), 0);
        assertEq(tokenProxy.balanceOf(_users.Bob), amount_);
    }

    function testRevertTransferInsufficientBalance(uint256 amount_) public {
        vm.assume(amount_ > 0 && amount_ < type(uint256).max);

        tokenProxy.mint(address(this), amount_ - 1);

        vm.expectRevert(stdError.arithmeticError);
        tokenProxy.transfer(_users.Alice, amount_);
    }

    function testRevertTransferFromInsufficientAllowance(
        uint256 amount_
    ) public {
        vm.assume(amount_ > 0 && amount_ < type(uint256).max);

        tokenProxy.mint(_users.Alice, amount_);

        vm.prank(_users.Alice);
        tokenProxy.approve(_users.Bob, amount_ - 1);

        vm.expectRevert(stdError.arithmeticError);
        tokenProxy.transferFrom(_users.Alice, _users.Bob, amount_);
    }

    function testRevertTransferFromInsufficientBalance(uint256 amount_) public {
        vm.assume(amount_ > 0 && amount_ < type(uint256).max);

        tokenProxy.mint(_users.Alice, amount_ - 1);

        vm.prank(_users.Alice);
        tokenProxy.approve(_users.Bob, amount_);

        vm.expectRevert(stdError.arithmeticError);
        tokenProxy.transferFrom(_users.Alice, _users.Bob, amount_);
    }

    function testRevertBurnInsufficientBalance(
        address to_,
        uint256 mintAmount_,
        uint256 burnAmount_
    ) external {
        vm.assume(burnAmount_ > mintAmount_);

        tokenProxy.mint(to_, mintAmount_);

        vm.expectRevert(stdError.arithmeticError);
        tokenProxy.burn(to_, burnAmount_);
    }

    function testMintBurn(uint256 amount_) external {
        _expectEmitTransfer(
            address(tokenProxy),
            address(0),
            _users.Alice,
            amount_
        );
        tokenProxy.mint(_users.Alice, amount_);

        assertEq(tokenProxy.balanceOf(_users.Alice), amount_);
        assertEq(tokenProxy.totalSupply(), amount_);

        _expectEmitTransfer(
            address(tokenProxy),
            _users.Alice,
            address(0),
            amount_
        );
        tokenProxy.burn(_users.Alice, amount_);

        assertEq(tokenProxy.balanceOf(_users.Alice), 0);
        assertEq(tokenProxy.totalSupply(), 0);
    }

    function testApproveTransfer(uint256 amount_) external {
        _expectEmitTransfer(
            address(tokenProxy),
            address(0),
            _users.Alice,
            amount_
        );
        tokenProxy.mint(_users.Alice, amount_);

        assertEq(tokenProxy.balanceOf(_users.Alice), amount_);
        assertEq(tokenProxy.balanceOf(_users.Bob), 0);
        assertEq(tokenProxy.totalSupply(), amount_);

        vm.startPrank(_users.Alice);
        _expectEmitApproval(
            address(tokenProxy),
            _users.Alice,
            _users.Bob,
            amount_
        );
        tokenProxy.approve(_users.Bob, amount_);
        vm.stopPrank();

        vm.startPrank(_users.Alice);
        _expectEmitTransfer(
            address(tokenProxy),
            _users.Alice,
            _users.Bob,
            amount_
        );
        tokenProxy.transfer(_users.Bob, amount_);
        assertEq(tokenProxy.balanceOf(_users.Alice), 0);
        assertEq(tokenProxy.balanceOf(_users.Bob), amount_);
        assertEq(tokenProxy.totalSupply(), amount_);
        vm.stopPrank();
    }

    function testApproveTransferFrom(uint256 amount_) external {
        _expectEmitTransfer(
            address(tokenProxy),
            address(0),
            _users.Alice,
            amount_
        );
        tokenProxy.mint(_users.Alice, amount_);

        assertEq(tokenProxy.balanceOf(_users.Alice), amount_);
        assertEq(tokenProxy.balanceOf(_users.Bob), 0);
        assertEq(tokenProxy.totalSupply(), amount_);

        vm.startPrank(_users.Alice);
        _expectEmitApproval(
            address(tokenProxy),
            _users.Alice,
            _users.Bob,
            amount_
        );
        tokenProxy.approve(_users.Bob, amount_);
        vm.stopPrank();

        vm.startPrank(_users.Bob);
        _expectEmitTransfer(
            address(tokenProxy),
            _users.Alice,
            _users.Bob,
            amount_
        );
        tokenProxy.transferFrom(_users.Alice, _users.Bob, amount_);
        assertEq(tokenProxy.balanceOf(_users.Alice), 0);
        assertEq(tokenProxy.balanceOf(_users.Bob), amount_);
        assertEq(tokenProxy.totalSupply(), amount_);
        vm.stopPrank();
    }

    function testRevertFailedProxyLog() external {
        vm.expectRevert(ImplementationERC20.ProxyEventEmittanceFailed.selector);
        tokenProxy.emitTransferEvent(
            address(dispatcher),
            address(0),
            address(0),
            100e18
        );

        vm.expectRevert(ImplementationERC20.ProxyEventEmittanceFailed.selector);
        tokenProxy.emitApprovalEvent(
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

contract InvariantBalanceSum {
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
