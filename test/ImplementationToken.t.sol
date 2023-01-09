// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Implementations
import {ImplementationState} from "./implementations/ImplementationState.sol";
import {ImplementationToken} from "./implementations/ImplementationToken.sol";

/**
 * @title Implementation Token Test
 */
contract ImplementationTokenTest is ImplementationFixture, ImplementationState {
    // =========
    // Constants
    // =========

    uint32 internal constant _TOKEN_A_MODULE_ID = 100;
    uint16 internal constant _TOKEN_A_MODULE_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _TOKEN_A_MODULE_VERSION = 1;

    // =======
    // Storage
    // =======

    ImplementationToken public tokenA;
    ImplementationToken public tokenAProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        tokenA = new ImplementationToken(
            _TOKEN_A_MODULE_ID,
            _TOKEN_A_MODULE_TYPE,
            _TOKEN_A_MODULE_VERSION
        );

        _tokens[address(tokenA)].name = "Token A";
        _tokens[address(tokenA)].symbol = "TKNA";
        _tokens[address(tokenA)].decimals = 18;

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(tokenA);
        installerProxy.addModules(moduleAddresses);

        tokenAProxy = ImplementationToken(
            dispatcher.moduleIdToProxy(_TOKEN_A_MODULE_ID)
        );
    }

    // =====
    // Tests
    // =====

    function testName() external {}

    // TODO: implement simple ERC20 test to verify the implementation
}
