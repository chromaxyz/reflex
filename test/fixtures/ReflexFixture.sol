// SPDX-License-Identifier: GPL-3.0-or-later
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
import {MockHarness} from "./MockHarness.sol";

/**
 * @title Reflex Fixture
 */
abstract contract ReflexFixture is ReflexConstants, TestHarness, MockHarness {
    // =======
    // Storage
    // =======

    MockReflexDispatcher public dispatcher;

    MockReflexInstaller public installerImplementation;
    MockReflexInstaller public installerEndpoint;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        installerImplementation = new MockReflexInstaller(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_INSTALLER, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        dispatcher = new MockReflexDispatcher(address(this), address(installerImplementation));

        installerEndpoint = MockReflexInstaller(dispatcher.getEndpoint(_MODULE_ID_INSTALLER));
    }

    // ==========
    // Test stubs
    // ==========

    function _verifyModuleConfiguration(IReflexModule module_, uint32 moduleId_, uint16 moduleType_) internal {
        IReflexModule.ModuleSettings memory moduleSettings = module_.moduleSettings();

        assertEq(moduleSettings.moduleId, moduleId_);
        assertEq(module_.moduleId(), moduleId_);
        assertEq(moduleSettings.moduleType, moduleType_);
        assertEq(module_.moduleType(), moduleType_);
    }
}
