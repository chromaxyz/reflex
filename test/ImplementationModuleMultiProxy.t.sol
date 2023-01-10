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
    uint16 internal constant _TOKEN_MODULE_VERSION_V1 = 1;
    uint16 internal constant _TOKEN_MODULE_VERSION_V2 = 2;

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

    MockImplementationERC20Hub public tokenHub;

    MockImplementationERC20Hub public tokenHubProxy;

    MockImplementationERC20 public tokenA;
    MockImplementationERC20 public tokenB;
    MockImplementationERC20 public tokenC;

    MockImplementationERC20 public tokenAProxy;
    MockImplementationERC20 public tokenBProxy;
    MockImplementationERC20 public tokenCProxy;

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
            _TOKEN_MODULE_VERSION_V1
        );
        tokenB = new MockImplementationERC20(
            _TOKEN_MODULE_ID,
            _TOKEN_MODULE_TYPE,
            _TOKEN_MODULE_VERSION_V1
        );
        tokenC = new MockImplementationERC20(
            _TOKEN_MODULE_ID,
            _TOKEN_MODULE_TYPE,
            _TOKEN_MODULE_VERSION_V1
        );

        address[] memory moduleAddresses = new address[](4);
        moduleAddresses[0] = address(tokenHub);
        moduleAddresses[1] = address(tokenA);
        moduleAddresses[2] = address(tokenB);
        moduleAddresses[3] = address(tokenC);
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
        tokenBProxy = MockImplementationERC20(
            tokenHubProxy.addERC20(
                _TOKEN_MODULE_ID,
                _TOKEN_MODULE_TYPE,
                _TOKEN_B_MODULE_NAME,
                _TOKEN_B_MODULE_SYMBOL,
                _TOKEN_B_MODULE_DECIMALS
            )
        );
        tokenCProxy = MockImplementationERC20(
            tokenHubProxy.addERC20(
                _TOKEN_MODULE_ID,
                _TOKEN_MODULE_TYPE,
                _TOKEN_C_MODULE_NAME,
                _TOKEN_C_MODULE_SYMBOL,
                _TOKEN_C_MODULE_DECIMALS
            )
        );
    }

    // ==========
    // Invariants
    // ==========

    function invariantMetadata() public {
        assertEq(tokenAProxy.name(), _TOKEN_A_MODULE_NAME);
        assertEq(tokenAProxy.symbol(), _TOKEN_A_MODULE_SYMBOL);
        assertEq(tokenAProxy.decimals(), _TOKEN_A_MODULE_DECIMALS);

        assertEq(tokenBProxy.name(), _TOKEN_B_MODULE_NAME);
        assertEq(tokenBProxy.symbol(), _TOKEN_B_MODULE_SYMBOL);
        assertEq(tokenBProxy.decimals(), _TOKEN_B_MODULE_DECIMALS);

        assertEq(tokenCProxy.name(), _TOKEN_C_MODULE_NAME);
        assertEq(tokenCProxy.symbol(), _TOKEN_C_MODULE_SYMBOL);
        assertEq(tokenCProxy.decimals(), _TOKEN_C_MODULE_DECIMALS);
    }

    // =====
    // Tests
    // =====

    function testUpgradeMultiProxySingleImplementation() external {
        assertEq(tokenAProxy.moduleVersion(), _TOKEN_MODULE_VERSION_V1);
        assertEq(tokenBProxy.moduleVersion(), _TOKEN_MODULE_VERSION_V1);
        assertEq(tokenCProxy.moduleVersion(), _TOKEN_MODULE_VERSION_V1);

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(
            new MockImplementationERC20(
                _TOKEN_MODULE_ID,
                _TOKEN_MODULE_TYPE,
                _TOKEN_MODULE_VERSION_V2
            )
        );
        installerProxy.upgradeModules(moduleAddresses);

        assertEq(tokenAProxy.moduleVersion(), _TOKEN_MODULE_VERSION_V2);
        assertEq(tokenBProxy.moduleVersion(), _TOKEN_MODULE_VERSION_V2);
        assertEq(tokenCProxy.moduleVersion(), _TOKEN_MODULE_VERSION_V2);
    }
}
