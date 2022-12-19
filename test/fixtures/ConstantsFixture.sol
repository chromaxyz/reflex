// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendors
import {Test} from "forge-std/Test.sol";

// Sources
import {BaseConstants} from "../../src/BaseState.sol";

/**
 * @title Constants Fixture
 */
abstract contract ConstantsFixture is Test, BaseConstants {
    // =========
    // Constants
    // =========

    address internal constant _ALICE = address(0xAAAA);
    address internal constant _BOB = address(0xBBBB);

    uint16 internal constant _INSTALLER_MODULE_VERSION = 1;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        vm.label(_ALICE, "Alice");
        vm.label(_BOB, "Bob");
    }
}
