// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseModule} from "../../src/interfaces/IBaseModule.sol";

// Mocks
import {MockBaseInstaller} from "../mocks/MockBaseInstaller.sol";
import {MockBaseDispatcher} from "../mocks/MockBaseDispatcher.sol";

// Fixtures
import {ConstantsFixture} from "./ConstantsFixture.sol";

/**
 * @title Base Fixture
 */
abstract contract BaseFixture is ConstantsFixture {
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
                moduleVersion: _INSTALLER_MODULE_VERSION,
                moduleUpgradeable: true,
                moduleRemoveable: false
            })
        );

        dispatcher = new MockBaseDispatcher(address(this), address(installer));

        installerProxy = MockBaseInstaller(
            dispatcher.moduleIdToProxy(_MODULE_ID_INSTALLER)
        );
    }
}
