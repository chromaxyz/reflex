// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Implementations
import {ImplementationToken} from "./implementations/ImplementationToken.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

/**
 * @title Implementation Module Test
 */
contract ImplementationModuleTest is ImplementationFixture {
    // ======
    // Events
    // ======

    /**
     * @notice Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /**
     * @notice Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    // =========
    // Constants
    // =========

    uint32 internal constant _TOKEN_MODULE_ID = 101;

    uint16 internal constant _TOKEN_A_MODULE_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _TOKEN_A_MODULE_VERSION = 1;
    string internal constant _TOKEN_A_MODULE_NAME = "TOKEN A";
    string internal constant _TOKEN_A_MODULE_SYMBOL = "TKNA";
    uint8 internal constant _TOKEN_A_MODULE_DECIMALS = 18;

    uint16 internal constant _TOKEN_B_MODULE_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _TOKEN_B_MODULE_VERSION = 1;
    string internal constant _TOKEN_B_MODULE_NAME = "TOKEN B";
    string internal constant _TOKEN_B_MODULE_SYMBOL = "TKNB";
    uint8 internal constant _TOKEN_B_MODULE_DECIMALS = 18;

    uint16 internal constant _TOKEN_C_MODULE_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _TOKEN_C_MODULE_VERSION = 1;
    string internal constant _TOKEN_C_MODULE_NAME = "TOKEN C";
    string internal constant _TOKEN_C_MODULE_SYMBOL = "TKNC";
    uint8 internal constant _TOKEN_C_MODULE_DECIMALS = 18;

    // =======
    // Storage
    // =======

    ImplementationToken public tokenA;
    ImplementationToken public tokenB;
    ImplementationToken public tokenC;

    ImplementationToken public tokenAProxy;
    ImplementationToken public tokenBProxy;
    ImplementationToken public tokenCProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        tokenA = new ImplementationToken(
            _TOKEN_MODULE_ID,
            _TOKEN_A_MODULE_TYPE,
            _TOKEN_A_MODULE_VERSION
        );
        tokenB = new ImplementationToken(
            _TOKEN_MODULE_ID,
            _TOKEN_B_MODULE_TYPE,
            _TOKEN_B_MODULE_VERSION
        );
        tokenC = new ImplementationToken(
            _TOKEN_MODULE_ID,
            _TOKEN_C_MODULE_TYPE,
            _TOKEN_C_MODULE_VERSION
        );

        address[] memory moduleAddresses = new address[](3);
        moduleAddresses[0] = address(tokenA);
        moduleAddresses[1] = address(tokenB);
        moduleAddresses[2] = address(tokenC);
        installerProxy.addModules(moduleAddresses);

        tokenAProxy = ImplementationToken(
            dispatcher.addToken(
                _TOKEN_MODULE_ID,
                _TOKEN_A_MODULE_TYPE,
                _TOKEN_A_MODULE_NAME,
                _TOKEN_A_MODULE_SYMBOL,
                _TOKEN_A_MODULE_DECIMALS
            )
        );
        tokenBProxy = ImplementationToken(
            dispatcher.addToken(
                _TOKEN_MODULE_ID,
                _TOKEN_B_MODULE_TYPE,
                _TOKEN_B_MODULE_NAME,
                _TOKEN_B_MODULE_SYMBOL,
                _TOKEN_B_MODULE_DECIMALS
            )
        );
        tokenCProxy = ImplementationToken(
            dispatcher.addToken(
                _TOKEN_MODULE_ID,
                _TOKEN_C_MODULE_TYPE,
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

    function testMintBurn() external {
        _expectEmitTransfer(address(0), _users.Alice, 100e18);
        tokenAProxy.mint(_users.Alice, 100e18);

        assertEq(tokenAProxy.balanceOf(_users.Alice), 100e18);
        assertEq(tokenAProxy.totalSupply(), 100e18);

        _expectEmitTransfer(_users.Alice, address(0), 100e18);
        tokenAProxy.burn(_users.Alice, 100e18);

        assertEq(tokenAProxy.balanceOf(_users.Alice), 0);
        assertEq(tokenAProxy.totalSupply(), 0);
    }

    // =========
    // Utilities
    // =========

    function _expectEmitTransfer(
        address from_,
        address to_,
        uint256 amount_
    ) internal {
        bytes32 message = bytes32(amount_);
        uint256 messageLength = message.length;

        bytes32 topic1 = bytes32(
            keccak256(bytes("Transfer(address,address,uint256"))
        );
        bytes32 topic2 = bytes32(uint256(uint160(from_)));
        bytes32 topic3 = bytes32(uint256(uint160(to_)));

        vm.expectEmit(true, true, true, true, address(tokenAProxy));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log3(ptr, messageLength, topic1, topic2, topic3)
        }
    }
}
