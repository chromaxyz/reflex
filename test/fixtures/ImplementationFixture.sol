// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseModule} from "../../src/interfaces/IBaseModule.sol";

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

        installer = new ImplementationInstaller(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: 1,
                moduleUpgradeable: true,
                moduleRemoveable: false
            })
        );
        dispatcher = new ImplementationDispatcher(
            address(this),
            address(installer)
        );
        installerProxy = ImplementationInstaller(
            dispatcher.moduleIdToProxy(_MODULE_ID_INSTALLER)
        );
    }
}
