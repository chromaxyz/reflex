// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendors
import {Test} from "forge-std/Test.sol";

// Modules
import {BaseInstaller} from "../../src/modules/BaseInstaller.sol";

// Sources
import {BaseConstants} from "../../src/BaseState.sol";

// Mocks
import {MockBaseInstaller} from "../mocks/MockBaseInstaller.sol";
import {MockBaseDispatcher} from "../mocks/MockBaseDispatcher.sol";

/**
 * @title Fixture
 */
abstract contract Fixture is Test, BaseConstants {
    // =========
    // Constants
    // =========

    address internal constant _ALICE = address(0xAAAA);
    address internal constant _BOB = address(0xBBBB);

    uint16 internal constant _INSTALLER_MODULE_VERSION = 1;

    // =======
    // Storage
    // =======

    MockBaseInstaller public installer;
    MockBaseDispatcher public dispatcher;
    BaseInstaller public installerProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        vm.label(_ALICE, "Alice");
        vm.label(_BOB, "Bob");

        installer = new MockBaseInstaller(_INSTALLER_MODULE_VERSION);
        dispatcher = new MockBaseDispatcher(
            "Dispatcher",
            address(this),
            address(installer)
        );
        installerProxy = BaseInstaller(
            dispatcher.moduleIdToProxy(_BUILT_IN_MODULE_ID_INSTALLER)
        );
    }
}
