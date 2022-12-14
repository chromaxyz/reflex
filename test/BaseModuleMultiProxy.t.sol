// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {console2} from "forge-std/console2.sol";
import {Vm} from "forge-std/Vm.sol";

// Interfaces
import {TBaseModule} from "../src/interfaces/IBaseModule.sol";

// Fixtures
import {Fixture} from "./fixtures/Fixture.sol";

// Mocks
import {MockBaseModule, ICustomError} from "./mocks/MockBaseModule.sol";

/**
 * @title Base Module Multi Proxy Test
 */
contract BaseModuleMultiProxyTest is TBaseModule, Fixture {
    // ======
    // Errors
    // ======

    error FailedToLog();

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

    function testModuleId() external {
        assertEq(moduleMulti.moduleId(), _MOCK_MODULE_MULTI_ID);
    }

    function testModuleType() external {
        assertEq(moduleMulti.moduleType(), _MOCK_MODULE_MULTI_TYPE);
    }

    function testModuleVersion() external {
        assertEq(moduleMulti.moduleVersion(), _MOCK_MODULE_MULTI_VERSION);
    }

    // TODO: add tests
}
