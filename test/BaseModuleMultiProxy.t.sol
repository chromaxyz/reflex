// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseModule} from "../src/interfaces/IBaseModule.sol";

// Fixtures
import {BaseFixture} from "./fixtures/BaseFixture.sol";

// Mocks
import {MockBaseModule} from "./mocks/MockBaseModule.sol";

/**
 * @title Base Module Multi Proxy Test
 */
contract BaseModuleMultiProxyTest is TBaseModule, BaseFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MOCK_MODULE_MULTI_ID = 101;
    uint16 internal constant _MOCK_MODULE_MULTI_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _MOCK_MODULE_MULTI_VERSION = 1;

    // =======
    // Storage
    // =======

    MockBaseModule public moduleMulti;
    MockBaseModule public moduleMultiProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        moduleMulti = new MockBaseModule(
            _MOCK_MODULE_MULTI_ID,
            _MOCK_MODULE_MULTI_TYPE,
            _MOCK_MODULE_MULTI_VERSION
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(moduleMulti);
        installerProxy.addModules(moduleAddresses);

        moduleMultiProxy = MockBaseModule(
            dispatcher.moduleIdToProxy(_MOCK_MODULE_MULTI_ID)
        );
    }

    // =====
    // Tests
    // =====

    function testProxyZeroAddress() external {
        assertTrue(
            dispatcher.moduleIdToProxy(_MOCK_MODULE_MULTI_ID) == address(0)
        );
    }

    function testModuleImplementation() external {
        assertTrue(
            dispatcher.moduleIdToImplementation(_MOCK_MODULE_MULTI_ID) ==
                address(moduleMulti)
        );
    }

    // TODO: add tests
}
