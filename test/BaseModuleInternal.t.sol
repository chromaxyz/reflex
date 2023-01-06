// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseModule, TBaseModule} from "../src/interfaces/IBaseModule.sol";

// Fixtures
import {BaseFixture} from "./fixtures/BaseFixture.sol";

// Mocks
import {MockBaseModule} from "./mocks/MockBaseModule.sol";

/**
 * @title Base Module Internal Test
 */
contract BaseModuleInternalTest is TBaseModule, BaseFixture {
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
            IBaseModule.ModuleSettings({
                moduleId: _MOCK_MODULE_INTERNAL_ID,
                moduleType: _MOCK_MODULE_INTERNAL_TYPE,
                moduleVersion: _MOCK_MODULE_INTERNAL_VERSION,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(moduleInternal);
        installerProxy.addModules(moduleAddresses);
    }

    // =====
    // Tests
    // =====

    function testModuleImplementation() external {
        assertTrue(
            dispatcher.moduleIdToImplementation(_MOCK_MODULE_INTERNAL_ID) ==
                address(moduleInternal)
        );
    }

    // TODO: add tests
}
