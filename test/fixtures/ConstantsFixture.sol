// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendors
import {Test} from "forge-std/Test.sol";

// Sources
import {BaseConstants} from "../../src/BaseConstants.sol";

// Test
import {Addresses} from "./Addresses.sol";

/**
 * @title Constants Fixture
 */
abstract contract ConstantsFixture is Test, BaseConstants, Addresses {
    // =========
    // Constants
    // =========

    uint16 internal constant _INSTALLER_MODULE_VERSION = 1;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        vm.label(_ALICE, "Alice");
        vm.label(_BOB, "Bob");
    }
}
