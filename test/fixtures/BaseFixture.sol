// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

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

        installer = new MockBaseInstaller(_INSTALLER_MODULE_VERSION);
        dispatcher = new MockBaseDispatcher(
            "Dispatcher",
            address(this),
            address(installer)
        );
        installerProxy = MockBaseInstaller(
            dispatcher.moduleIdToProxy(_BUILT_IN_MODULE_ID_INSTALLER)
        );
    }
}
