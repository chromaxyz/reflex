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
 * @title Base Module Internal Test
 */
contract BaseModuleInternalTest is TBaseModule, Fixture {
    // ======
    // Errors
    // ======

    error FailedToLog();

    // =========
    // Constants
    // =========

    uint32 internal constant _MOCK_MODULE_INTERNAL_ID = 102;
    uint16 internal constant _MOCK_MODULE_INTERNAL_TYPE = _MODULE_TYPE_INTERNAL;
    uint16 internal constant _MOCK_MODULE_INTERNAL_VERSION = 1;

    // =======
    // Storage
    // =======

    MockBaseModule public moduleInternal;
    MockBaseModule public moduleInternalProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        moduleInternal = new MockBaseModule(
            _MOCK_MODULE_INTERNAL_ID,
            _MOCK_MODULE_INTERNAL_TYPE,
            _MOCK_MODULE_INTERNAL_VERSION
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(moduleInternal);

        installerProxy.addModules(moduleAddresses);

        assertTrue(
            dispatcher.moduleIdToProxy(_MOCK_MODULE_INTERNAL_ID) == address(0)
        );
    }

    // =====
    // Tests
    // =====

    function testModuleMultiProxyZeroAddress() external {
        assertTrue(
            dispatcher.moduleIdToProxy(_MOCK_MODULE_INTERNAL_ID) == address(0)
        );
    }

    // TODO: add specific tests
}
