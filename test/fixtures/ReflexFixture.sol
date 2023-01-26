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
import {TestHarness} from "./TestHarness.sol";

// Script
import {DeployConstants} from "../../script/Deploy.s.sol";

/**
 * @title Reflex Fixture
 */
abstract contract ReflexFixture is ReflexConstants, DeployConstants, TestHarness {
    // =======
    // Storage
    // =======

    MockReflexDispatcher public dispatcher;

    MockReflexInstaller public installer;
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
                moduleUpgradeable: _MODULE_UPGRADEABLE_INSTALLER
            })
        );
        dispatcher = new MockReflexDispatcher(address(this), address(installer));
        installerProxy = MockReflexInstaller(dispatcher.moduleIdToProxy(_MODULE_ID_INSTALLER));
    }

    // ================
    // Internal methods
    // ================

    function _testModuleConfiguration(
        IReflexModule module_,
        uint256 moduleId_,
        uint256 moduleType_,
        uint256 moduleVersion_,
        bool moduleUpgradeable_
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
    }
}
