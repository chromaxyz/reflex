// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendors
import {Test} from "forge-std/Test.sol";

// Modules
import {BaseInstaller} from "../../src/modules/BaseInstaller.sol";

// Sources
import {BaseConstants} from "../../src/BaseConstants.sol";

// Mocks
import {MockBaseInstaller} from "../mocks/MockBaseInstaller.sol";
import {MockDispatcher} from "../mocks/MockDispatcher.sol";

/**
 * @title Fixture
 */
abstract contract Fixture is Test, BaseConstants {
    // =========
    // Constants
    // =========

    address internal constant _ALICE = address(0xAAAA);
    address internal constant _BOB = address(0xBBBB);

    uint16 internal constant _MODULE_ID_INSTALLER_TYPE = 1;
    uint16 internal constant _MODULE_ID_INSTALLER_VERSION = 1;

    // =======
    // Storage
    // =======

    MockBaseInstaller public installer;
    MockDispatcher public reflex;
    BaseInstaller public installerProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        vm.label(_ALICE, "Alice");
        vm.label(_BOB, "Bob");

        installer = new MockBaseInstaller(
            _MODULE_ID_INSTALLER_TYPE,
            _MODULE_ID_INSTALLER_VERSION
        );
        reflex = new MockDispatcher(
            "Dispatcher",
            address(this),
            address(installer)
        );
        installerProxy = BaseInstaller(
            reflex.moduleIdToProxy(_MODULE_ID_INSTALLER)
        );
    }
}
