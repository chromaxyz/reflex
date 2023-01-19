// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule, TReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {MockReflexModule} from "./mocks/MockReflexModule.sol";

/**
 * @title Reflex Module Test
 */
contract ReflexModuleTest is TReflexModule, ReflexFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_VALID_ID = 5;
    uint16 internal constant _MODULE_VALID_TYPE_SINGLE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_VALID_VERSION = 1;
    bool internal constant _MODULE_VALID_UPGRADEABLE = true;
    bool internal constant _MODULE_VALID_REMOVEABLE = true;

    uint32 internal constant _MODULE_INVALID_ID = 0;
    uint16 internal constant _MODULE_INVALID_TYPE = 777;
    uint16 internal constant _MODULE_INVALID_TYPE_ZERO = 0;
    uint16 internal constant _MODULE_INVALID_VERSION = 0;

    // =======
    // Storage
    // =======

    MockReflexModule public module;
    MockReflexModule public moduleProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();
    }

    // =====
    // Tests
    // =====

    function testModuleSettings() external {
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_VALID_TYPE_SINGLE,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE,
                moduleRemoveable: _MODULE_VALID_REMOVEABLE
            })
        );

        _testModuleConfiguration(
            module,
            _MODULE_VALID_ID,
            _MODULE_VALID_TYPE_SINGLE,
            _MODULE_VALID_VERSION,
            _MODULE_VALID_UPGRADEABLE,
            _MODULE_VALID_REMOVEABLE
        );
    }

    function testRevertInvalidModuleIdZeroValue() external {
        vm.expectRevert(InvalidModuleId.selector);
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INVALID_ID,
                moduleType: _MODULE_VALID_TYPE_SINGLE,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE,
                moduleRemoveable: _MODULE_VALID_REMOVEABLE
            })
        );
    }

    function testRevertInvalidModuleTypeZeroValue() external {
        vm.expectRevert(InvalidModuleType.selector);
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_INVALID_TYPE_ZERO,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE,
                moduleRemoveable: _MODULE_VALID_REMOVEABLE
            })
        );
    }

    function testRevertInvalidModuleTypeOverflowValue() external {
        vm.expectRevert(InvalidModuleType.selector);
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_INVALID_TYPE,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE,
                moduleRemoveable: _MODULE_VALID_REMOVEABLE
            })
        );
    }

    function testRevertInvalidModuleVersionZeroValue() external {
        vm.expectRevert(InvalidModuleVersion.selector);
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_VALID_TYPE_SINGLE,
                moduleVersion: _MODULE_INVALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE,
                moduleRemoveable: _MODULE_VALID_REMOVEABLE
            })
        );
    }
}