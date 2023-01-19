// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {ReflexConstants} from "../../src/ReflexConstants.sol";

// Interfaces
import {IReflexModule} from "../../src/interfaces/IReflexModule.sol";

// Mocks
import {MockReflexInstaller} from "../mocks/MockReflexInstaller.sol";
import {MockReflexDispatcher} from "../mocks/MockReflexDispatcher.sol";

// Fixtures
import {Harness} from "./Harness.sol";

// Script
import {DeployConstants} from "../../script/Deploy.s.sol";

/**
 * @title Reflex Fixture
 */
abstract contract ReflexFixture is ReflexConstants, DeployConstants, Harness {
    // =======
    // Storage
    // =======

    MockReflexInstaller public installer;
    MockReflexDispatcher public dispatcher;
    MockReflexInstaller public installerProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        installer = new MockReflexInstaller(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: _MODULE_VERSION_INSTALLER,
                moduleUpgradeable: _MODULE_UPGRADEABLE_INSTALLER,
                moduleRemoveable: _MODULE_REMOVEABLE_INSTALLER
            })
        );
        dispatcher = new MockReflexDispatcher(address(this), address(installer));
        installerProxy = MockReflexInstaller(dispatcher.moduleIdToProxy(_MODULE_ID_INSTALLER));
    }

    // =========
    // Utilities
    // =========

    function _testModuleConfiguration(
        IReflexModule module_,
        uint32 moduleId_,
        uint16 moduleType_,
        uint32 moduleVersion_,
        bool moduleUpgradeable_,
        bool moduleRemoveable_
    ) internal {
        IReflexModule.ModuleSettings memory moduleSettings = module_.moduleSettings();

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
