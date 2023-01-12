// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseConstants} from "../../src/BaseConstants.sol";

// Interfaces
import {IBaseModule} from "../../src/interfaces/IBaseModule.sol";

// Implementations
import {ImplementationDispatcher} from "../implementations/ImplementationDispatcher.sol";
import {ImplementationInstaller} from "../implementations/ImplementationInstaller.sol";

// Fixtures
import {Harness} from "./Harness.sol";

/**
 * @title Implementation Fixture
 */
abstract contract ImplementationFixture is BaseConstants, Harness {
    // =======
    // Storage
    // =======

    ImplementationInstaller public installer;
    ImplementationDispatcher public dispatcher;
    ImplementationInstaller public installerProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        installer = new ImplementationInstaller(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: 1,
                moduleUpgradeable: true,
                moduleRemoveable: false
            })
        );
        dispatcher = new ImplementationDispatcher(address(this), address(installer));
        installerProxy = ImplementationInstaller(dispatcher.moduleIdToProxy(_MODULE_ID_INSTALLER));
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
