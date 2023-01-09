// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Implementations
import {ImplementationERC20Hub} from "./implementations/ImplementationERC20Hub.sol";
import {ImplementationERC20} from "./implementations/ImplementationERC20.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

/**
 * @title Implementation Module Multi Proxy Test
 */
contract ImplementationModuleMultiProxyTest is ImplementationFixture {
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

    string internal constant _TOKEN_B_MODULE_NAME = "TOKEN B";
    string internal constant _TOKEN_B_MODULE_SYMBOL = "TKNB";
    uint8 internal constant _TOKEN_B_MODULE_DECIMALS = 6;

    string internal constant _TOKEN_C_MODULE_NAME = "TOKEN C";
    string internal constant _TOKEN_C_MODULE_SYMBOL = "TKNC";
    uint8 internal constant _TOKEN_C_MODULE_DECIMALS = 8;

    // =======
    // Storage
    // =======

    ImplementationERC20Hub public tokenHub;

    ImplementationERC20Hub public tokenHubProxy;

    ImplementationERC20 public tokenA;
    ImplementationERC20 public tokenB;
    ImplementationERC20 public tokenC;

    ImplementationERC20 public tokenAProxy;
    ImplementationERC20 public tokenBProxy;
    ImplementationERC20 public tokenCProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        tokenHub = new ImplementationERC20Hub(
            _TOKEN_HUB_MODULE_ID,
            _TOKEN_HUB_MODULE_TYPE,
            _TOKEN_HUB_MODULE_VERSION
        );

        tokenA = new ImplementationERC20(
            _TOKEN_MODULE_ID,
            _TOKEN_MODULE_TYPE,
            _TOKEN_MODULE_VERSION
        );
        tokenB = new ImplementationERC20(
            _TOKEN_MODULE_ID,
            _TOKEN_MODULE_TYPE,
            _TOKEN_MODULE_VERSION
        );
        tokenC = new ImplementationERC20(
            _TOKEN_MODULE_ID,
            _TOKEN_MODULE_TYPE,
            _TOKEN_MODULE_VERSION
        );

        address[] memory moduleAddresses = new address[](4);
        moduleAddresses[0] = address(tokenHub);
        moduleAddresses[1] = address(tokenA);
        moduleAddresses[2] = address(tokenB);
        moduleAddresses[3] = address(tokenC);
        installerProxy.addModules(moduleAddresses);

        tokenHubProxy = ImplementationERC20Hub(
            dispatcher.moduleIdToProxy(_TOKEN_HUB_MODULE_ID)
        );

        tokenAProxy = ImplementationERC20(
            tokenHubProxy.addERC20(
                _TOKEN_MODULE_ID,
                _TOKEN_MODULE_TYPE,
                _TOKEN_A_MODULE_NAME,
                _TOKEN_A_MODULE_SYMBOL,
                _TOKEN_A_MODULE_DECIMALS
            )
        );
        tokenBProxy = ImplementationERC20(
            tokenHubProxy.addERC20(
                _TOKEN_MODULE_ID,
                _TOKEN_MODULE_TYPE,
                _TOKEN_B_MODULE_NAME,
                _TOKEN_B_MODULE_SYMBOL,
                _TOKEN_B_MODULE_DECIMALS
            )
        );
        tokenCProxy = ImplementationERC20(
            tokenHubProxy.addERC20(
                _TOKEN_MODULE_ID,
                _TOKEN_MODULE_TYPE,
                _TOKEN_C_MODULE_NAME,
                _TOKEN_C_MODULE_SYMBOL,
                _TOKEN_C_MODULE_DECIMALS
            )
        );
    }

    // =====
    // Tests
    // =====

    function testName() external {
        assertEq(tokenAProxy.name(), _TOKEN_A_MODULE_NAME);
        assertEq(tokenBProxy.name(), _TOKEN_B_MODULE_NAME);
        assertEq(tokenCProxy.name(), _TOKEN_C_MODULE_NAME);
    }

    function testSymbol() external {
        assertEq(tokenAProxy.symbol(), _TOKEN_A_MODULE_SYMBOL);
        assertEq(tokenBProxy.symbol(), _TOKEN_B_MODULE_SYMBOL);
        assertEq(tokenCProxy.symbol(), _TOKEN_C_MODULE_SYMBOL);
    }

    function testDecimals() external {
        assertEq(tokenAProxy.decimals(), _TOKEN_A_MODULE_DECIMALS);
        assertEq(tokenBProxy.decimals(), _TOKEN_B_MODULE_DECIMALS);
        assertEq(tokenCProxy.decimals(), _TOKEN_C_MODULE_DECIMALS);
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
