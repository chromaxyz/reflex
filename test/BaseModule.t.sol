// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseModule, TBaseModule} from "../src/interfaces/IBaseModule.sol";

// Fixtures
import {BaseFixture} from "./fixtures/BaseFixture.sol";

// Mocks
import {MockBaseModule} from "./mocks/MockBaseModule.sol";

/**
 * @title Base Module  Test
 */
contract BaseModuleTest is TBaseModule, BaseFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_VALID_ID = 5;
    uint16 internal constant _MODULE_VALID_TYPE_SINGLE =
        _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_VALID_TYPE_MULTI =
        _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _MODULE_VALID_TYPE_INTERNAL =
        _MODULE_TYPE_INTERNAL;
    uint16 internal constant _MODULE_VALID_VERSION = 1;

    uint32 internal constant _MODULE_INVALID_ID = 0;
    uint16 internal constant _MODULE_INVALID_TYPE = 777;
    uint16 internal constant _MODULE_INVALID_TYPE_ZERO = 0;
    uint16 internal constant _MODULE_INVALID_VERSION = 0;

    // =======
    // Storage
    // =======

    MockBaseModule public module;
    MockBaseModule public moduleProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();
    }

    // =====
    // Tests
    // =====

    function testValidModuleSettings() external {
        module = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_VALID_TYPE_SINGLE,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );

        assertEq(module.moduleId(), _MODULE_VALID_ID);
        assertEq(module.moduleType(), _MODULE_VALID_TYPE_SINGLE);
        assertEq(module.moduleVersion(), _MODULE_VALID_VERSION);
        assertEq(module.moduleUpgradeable(), true);
        assertEq(module.moduleRemoveable(), true);
    }

    function testRevertInvalidModuleIdZeroValue() external {
        vm.expectRevert(InvalidModuleId.selector);
        module = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_INVALID_ID,
                moduleType: _MODULE_VALID_TYPE_SINGLE,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );
    }

    function testRevertInvalidModuleTypeZeroValue() external {
        vm.expectRevert(InvalidModuleType.selector);
        module = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_INVALID_TYPE_ZERO,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );
    }

    function testRevertInvalidModuleTypeOverflowValue() external {
        vm.expectRevert(InvalidModuleType.selector);
        module = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_INVALID_TYPE,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );
    }

    function testRevertInvalidModuleVersionZeroValue() external {
        vm.expectRevert(InvalidModuleVersion.selector);
        module = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_VALID_TYPE_SINGLE,
                moduleVersion: _MODULE_INVALID_VERSION,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );
    }
}
