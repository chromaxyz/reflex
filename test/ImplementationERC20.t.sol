// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
import {stdError} from "forge-std/StdError.sol";

// Interfaces
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {ImplementationERC20} from "./mocks/abstracts/ImplementationERC20.sol";
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
    uint16 internal constant _TOKEN_HUB_MODULE_TYPE = _MODULE_TYPE_SINGLE_ENDPOINT;
    uint16 internal constant _TOKEN_HUB_MODULE_VERSION = 1;

    uint32 internal constant _TOKEN_MODULE_ID = 101;
    uint16 internal constant _TOKEN_MODULE_TYPE = _MODULE_TYPE_MULTI_ENDPOINT;
    uint16 internal constant _TOKEN_MODULE_VERSION = 1;

    string public constant TOKEN_MODULE_NAME = "TOKEN A";
    string public constant TOKEN_MODULE_SYMBOL = "TKNA";
    uint8 public constant TOKEN_MODULE_DECIMALS = 18;

    // =======
    // Storage
    // =======

    MockImplementationERC20Hub public tokenHub;
    MockImplementationERC20Hub public tokenHubEndpoint;

    MockImplementationERC20 public token;
    MockImplementationERC20 public tokenEndpoint;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        tokenHub = new MockImplementationERC20Hub(
            IReflexModule.ModuleSettings({
                moduleId: _TOKEN_HUB_MODULE_ID,
                moduleType: _TOKEN_HUB_MODULE_TYPE,
                moduleVersion: _TOKEN_HUB_MODULE_VERSION,
                moduleUpgradeable: true
            })
        );

        token = new MockImplementationERC20(
            IReflexModule.ModuleSettings({
                moduleId: _TOKEN_MODULE_ID,
                moduleType: _TOKEN_MODULE_TYPE,
                moduleVersion: _TOKEN_MODULE_VERSION,
                moduleUpgradeable: true
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(tokenHub);
        moduleAddresses[1] = address(token);
        installerEndpoint.addModules(moduleAddresses);

        tokenHubEndpoint = MockImplementationERC20Hub(dispatcher.getEndpoint(_TOKEN_HUB_MODULE_ID));

        tokenEndpoint = MockImplementationERC20(
            tokenHubEndpoint.addERC20(
                _TOKEN_MODULE_ID,
                _TOKEN_MODULE_TYPE,
                TOKEN_MODULE_NAME,
                TOKEN_MODULE_SYMBOL,
                TOKEN_MODULE_DECIMALS
            )
        );
    }

    // =====
    // Tests
    // =====

    function testUnitMetadata() external {
        assertEq(tokenEndpoint.name(), TOKEN_MODULE_NAME);
        assertEq(tokenEndpoint.symbol(), TOKEN_MODULE_SYMBOL);
        assertEq(tokenEndpoint.decimals(), TOKEN_MODULE_DECIMALS);
    }

    function testFuzzMint(uint256 amount_) external {
        tokenEndpoint.mint(_users.Alice, amount_);

        assertEq(tokenEndpoint.totalSupply(), amount_);
        assertEq(tokenEndpoint.balanceOf(_users.Alice), amount_);
    }

    function testFuzzBurn(uint256 mintAmount_, uint256 burnAmount_) external {
        vm.assume(mintAmount_ > burnAmount_);

        tokenEndpoint.mint(_users.Alice, mintAmount_);
        tokenEndpoint.burn(_users.Alice, burnAmount_);

        assertEq(tokenEndpoint.totalSupply(), mintAmount_ - burnAmount_);
        assertEq(tokenEndpoint.balanceOf(_users.Alice), mintAmount_ - burnAmount_);
    }

    function testFuzzApprove(uint256 amount_) external {
        assertTrue(tokenEndpoint.approve(_users.Alice, amount_));
        assertEq(tokenEndpoint.allowance(address(this), _users.Alice), amount_);
    }

    function testFuzzTransfer(uint256 amount_) external {
        tokenEndpoint.mint(address(this), amount_);

        assertTrue(tokenEndpoint.transfer(_users.Alice, amount_));
        assertEq(tokenEndpoint.totalSupply(), amount_);
        assertEq(tokenEndpoint.balanceOf(address(this)), 0);
        assertEq(tokenEndpoint.balanceOf(_users.Alice), amount_);
    }

    function testFuzzTransferFrom(uint256 amount_) external {
        vm.assume(amount_ > 0 && amount_ < type(uint256).max);

        tokenEndpoint.mint(_users.Alice, amount_);

        vm.prank(_users.Alice);
        tokenEndpoint.approve(address(this), amount_);

        assertTrue(tokenEndpoint.transferFrom(_users.Alice, _users.Bob, amount_));
        assertEq(tokenEndpoint.totalSupply(), amount_);
        assertEq(tokenEndpoint.allowance(_users.Alice, address(this)), 0);
        assertEq(tokenEndpoint.balanceOf(_users.Alice), 0);
        assertEq(tokenEndpoint.balanceOf(_users.Bob), amount_);
    }

    function testFuzzInfiniteApproveTransferFrom(uint256 amount_) external {
        vm.assume(amount_ > 0 && amount_ < type(uint256).max);

        tokenEndpoint.mint(_users.Alice, amount_);

        vm.prank(_users.Alice);
        tokenEndpoint.approve(address(this), type(uint256).max);

        assertTrue(tokenEndpoint.transferFrom(_users.Alice, _users.Bob, amount_));
        assertEq(tokenEndpoint.totalSupply(), amount_);
        assertEq(tokenEndpoint.allowance(_users.Alice, address(this)), type(uint256).max);
        assertEq(tokenEndpoint.balanceOf(_users.Alice), 0);
        assertEq(tokenEndpoint.balanceOf(_users.Bob), amount_);
    }

    function testFuzzRevertTransferInsufficientBalance(uint256 amount_) external {
        vm.assume(amount_ > 0 && amount_ < type(uint256).max);

        tokenEndpoint.mint(address(this), amount_ - 1);

        vm.expectRevert(stdError.arithmeticError);
        tokenEndpoint.transfer(_users.Alice, amount_);
    }

    function testFuzzRevertTransferFromInsufficientAllowance(uint256 amount_) external {
        vm.assume(amount_ > 0 && amount_ < type(uint256).max);

        tokenEndpoint.mint(_users.Alice, amount_);

        vm.prank(_users.Alice);
        tokenEndpoint.approve(_users.Bob, amount_ - 1);

        vm.expectRevert(stdError.arithmeticError);
        tokenEndpoint.transferFrom(_users.Alice, _users.Bob, amount_);
    }

    function testFuzzRevertTransferFromInsufficientBalance(uint256 amount_) external {
        vm.assume(amount_ > 0 && amount_ < type(uint256).max);

        tokenEndpoint.mint(_users.Alice, amount_ - 1);

        vm.prank(_users.Alice);
        tokenEndpoint.approve(_users.Bob, amount_);

        vm.expectRevert(stdError.arithmeticError);
        tokenEndpoint.transferFrom(_users.Alice, _users.Bob, amount_);
    }

    function testFuzzRevertBurnInsufficientBalance(address to_, uint256 mintAmount_, uint256 burnAmount_) external {
        assumeNoPrecompiles(to_);
        vm.assume(burnAmount_ > mintAmount_);

        tokenEndpoint.mint(_brutalize(to_), mintAmount_);

        vm.expectRevert(stdError.arithmeticError);
        tokenEndpoint.burn(_brutalize(to_), burnAmount_);
    }

    function testFuzzMintBurn(uint256 amount_) external {
        _expectEmitTransfer(address(tokenEndpoint), address(0), _users.Alice, amount_);
        tokenEndpoint.mint(_users.Alice, amount_);

        assertEq(tokenEndpoint.balanceOf(_users.Alice), amount_);
        assertEq(tokenEndpoint.totalSupply(), amount_);

        _expectEmitTransfer(address(tokenEndpoint), _users.Alice, address(0), amount_);
        tokenEndpoint.burn(_users.Alice, amount_);

        assertEq(tokenEndpoint.balanceOf(_users.Alice), 0);
        assertEq(tokenEndpoint.totalSupply(), 0);
    }

    function testFuzzApproveTransfer(uint256 amount_) external {
        _expectEmitTransfer(address(tokenEndpoint), address(0), _users.Alice, amount_);
        tokenEndpoint.mint(_users.Alice, amount_);

        assertEq(tokenEndpoint.balanceOf(_users.Alice), amount_);
        assertEq(tokenEndpoint.balanceOf(_users.Bob), 0);
        assertEq(tokenEndpoint.totalSupply(), amount_);

        vm.startPrank(_users.Alice);
        _expectEmitApproval(address(tokenEndpoint), _users.Alice, _users.Bob, amount_);
        tokenEndpoint.approve(_users.Bob, amount_);
        vm.stopPrank();

        vm.startPrank(_users.Alice);
        _expectEmitTransfer(address(tokenEndpoint), _users.Alice, _users.Bob, amount_);
        tokenEndpoint.transfer(_users.Bob, amount_);
        assertEq(tokenEndpoint.balanceOf(_users.Alice), 0);
        assertEq(tokenEndpoint.balanceOf(_users.Bob), amount_);
        assertEq(tokenEndpoint.totalSupply(), amount_);
        vm.stopPrank();
    }

    function testFuzzApproveTransferFrom(uint256 amount_) external {
        _expectEmitTransfer(address(tokenEndpoint), address(0), _users.Alice, amount_);
        tokenEndpoint.mint(_users.Alice, amount_);

        assertEq(tokenEndpoint.balanceOf(_users.Alice), amount_);
        assertEq(tokenEndpoint.balanceOf(_users.Bob), 0);
        assertEq(tokenEndpoint.totalSupply(), amount_);

        vm.startPrank(_users.Alice);
        _expectEmitApproval(address(tokenEndpoint), _users.Alice, _users.Bob, amount_);
        tokenEndpoint.approve(_users.Bob, amount_);
        vm.stopPrank();

        vm.startPrank(_users.Bob);
        _expectEmitTransfer(address(tokenEndpoint), _users.Alice, _users.Bob, amount_);
        tokenEndpoint.transferFrom(_users.Alice, _users.Bob, amount_);
        assertEq(tokenEndpoint.balanceOf(_users.Alice), 0);
        assertEq(tokenEndpoint.balanceOf(_users.Bob), amount_);
        assertEq(tokenEndpoint.totalSupply(), amount_);
        vm.stopPrank();
    }

    function testUnitRevertFailedEndpointLog() external {
        vm.expectRevert(ImplementationERC20.EndpointEventEmittanceFailed.selector);
        tokenEndpoint.emitTransferEvent(address(dispatcher), address(0), address(0), 100e18);

        vm.expectRevert(ImplementationERC20.EndpointEventEmittanceFailed.selector);
        tokenEndpoint.emitApprovalEvent(address(dispatcher), address(0), address(0), 100e18);
    }

    // =========
    // Utilities
    // =========

    function _expectEmitTransfer(
        address emitter_,
        address from_,
        address to_,
        uint256 amount_
    ) internal brutalizeMemory {
        bytes32 message = bytes32(amount_);
        uint256 messageLength = message.length;

        bytes32 topic1 = bytes32(keccak256(bytes("Transfer(address,address,uint256")));
        bytes32 topic2 = bytes32(uint256(uint160(from_)));
        bytes32 topic3 = bytes32(uint256(uint160(to_)));

        vm.expectEmit(true, true, true, true, emitter_);
        assembly ("memory-safe") {
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
    ) internal brutalizeMemory {
        bytes32 message = bytes32(amount_);
        uint256 messageLength = message.length;

        bytes32 topic1 = bytes32(keccak256(bytes("Approval(address,address,uint256)")));
        bytes32 topic2 = bytes32(uint256(uint160(owner_)));
        bytes32 topic3 = bytes32(uint256(uint160(spender_)));

        vm.expectEmit(true, true, true, true, emitter_);
        assembly ("memory-safe") {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log3(ptr, messageLength, topic1, topic2, topic3)
        }
    }
}
