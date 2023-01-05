// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Implementations
import {ImplementationDispatcher} from "../implementations/ImplementationDispatcher.sol";
import {ImplementationInstaller} from "../implementations/ImplementationInstaller.sol";

// Fixtures
import {ConstantsFixture} from "./ConstantsFixture.sol";

/**
 * @title Implementation Fixture
 */
abstract contract ImplementationFixture is ConstantsFixture {
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

        installer = new ImplementationInstaller(_INSTALLER_MODULE_VERSION);
        dispatcher = new ImplementationDispatcher(
            address(this),
            address(installer)
        );
        installerProxy = ImplementationInstaller(
            dispatcher.moduleIdToProxy(_BUILT_IN_MODULE_ID_INSTALLER)
        );
    }
}
