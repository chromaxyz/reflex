// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBase} from "../src/interfaces/IReflexBase.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {MockReflexModule} from "./mocks/MockReflexModule.sol";

/**
 * @title Reflex Module Test
 */
contract ReflexModuleTest is ReflexFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_VALID_ID = 5;
    uint16 internal constant _MODULE_VALID_TYPE_SINGLE = _MODULE_TYPE_SINGLE_ENDPOINT;
    uint16 internal constant _MODULE_VALID_VERSION = 1;
    bool internal constant _MODULE_VALID_UPGRADEABLE = true;

    uint32 internal constant _MODULE_INVALID_ID = 0;
    uint16 internal constant _MODULE_INVALID_TYPE = 777;
    uint16 internal constant _MODULE_INVALID_TYPE_ZERO = 0;
    uint16 internal constant _MODULE_INVALID_VERSION = 0;

    // =======
    // Storage
    // =======

    MockReflexModule public module;
    MockReflexModule public moduleEndpoint;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();
    }

    // =====
    // Tests
    // =====

    function testUnitModuleSettings() external {
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_VALID_TYPE_SINGLE,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE
            })
        );

        _verifyModuleConfiguration(
            module,
            _MODULE_VALID_ID,
            _MODULE_VALID_TYPE_SINGLE,
            _MODULE_VALID_VERSION,
            _MODULE_VALID_UPGRADEABLE
        );
    }

    function testUnitRevertInvalidModuleIdZeroValue() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexBase.ModuleIdInvalid.selector, _MODULE_INVALID_ID));
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INVALID_ID,
                moduleType: _MODULE_VALID_TYPE_SINGLE,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE
            })
        );
    }

    function testUnitRevertInvalidModuleTypeZeroValue() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexBase.ModuleTypeInvalid.selector, _MODULE_INVALID_TYPE_ZERO));
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_INVALID_TYPE_ZERO,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE
            })
        );
    }

    function testUnitRevertInvalidModuleTypeOverflowValue() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexBase.ModuleTypeInvalid.selector, _MODULE_INVALID_TYPE));
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_INVALID_TYPE,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE
            })
        );
    }

    function testUnitRevertInvalidModuleVersionZeroValue() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleVersionInvalid.selector, _MODULE_INVALID_VERSION));
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_VALID_TYPE_SINGLE,
                moduleVersion: _MODULE_INVALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE
            })
        );
    }
}
