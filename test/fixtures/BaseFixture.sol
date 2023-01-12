// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseConstants} from "../../src/BaseConstants.sol";

// Interfaces
import {IBaseModule} from "../../src/interfaces/IBaseModule.sol";

// Mocks
import {MockBaseInstaller} from "../mocks/MockBaseInstaller.sol";
import {MockBaseDispatcher} from "../mocks/MockBaseDispatcher.sol";

// Fixtures
import {Harness} from "./Harness.sol";

// Script
import {DeployConstants} from "../../script/Deploy.s.sol";

/**
 * @title Base Fixture
 */
abstract contract BaseFixture is BaseConstants, DeployConstants, Harness {
    // =======
    // Storage
    // =======

    MockBaseInstaller public installer;
    MockBaseDispatcher public dispatcher;
    MockBaseInstaller public installerProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        installer = new MockBaseInstaller(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: _MODULE_VERSION_INSTALLER,
                moduleUpgradeable: _MODULE_UPGRADEABLE_INSTALLER,
                moduleRemoveable: _MODULE_REMOVEABLE_INSTALLER
            })
        );
        dispatcher = new MockBaseDispatcher(address(this), address(installer));
        installerProxy = MockBaseInstaller(dispatcher.moduleIdToProxy(_MODULE_ID_INSTALLER));
    }

    // =========
    // Utilities
    // =========

    function _testModuleConfiguration(
        IBaseModule module_,
        uint32 moduleId_,
        uint16 moduleType_,
        uint16 moduleVersion_,
        bool moduleUpgradeable_,
        bool moduleRemoveable_
    ) internal {
        IBaseModule.ModuleSettings memory moduleSettings = module_.moduleSettings();

        assertEq(moduleSettings.moduleId, moduleId_);
        assertEq(module_.moduleId(), moduleId_);
        assertEq(moduleSettings.moduleType, moduleType_);
        assertEq(module_.moduleType(), moduleType_);
        assertEq(moduleSettings.moduleVersion, moduleVersion_);
        assertEq(module_.moduleVersion(), moduleVersion_);
        assertEq(moduleSettings.moduleUpgradeable, moduleUpgradeable_);
        assertEq(module_.moduleUpgradeable(), moduleUpgradeable_);
        assertEq(moduleSettings.moduleRemoveable, moduleRemoveable_);
        assertEq(module_.moduleRemoveable(), moduleRemoveable_);
    }
}
