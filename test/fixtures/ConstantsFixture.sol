// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendors
import {Test} from "forge-std/Test.sol";

// Sources
import {BaseConstants} from "../../src/BaseConstants.sol";

// Test
import {Harness} from "./Harness.sol";

/**
 * @title Constants Fixture
 */
abstract contract ConstantsFixture is Test, BaseConstants, Harness {
    // =========
    // Constants
    // =========

    uint16 internal constant _INSTALLER_MODULE_VERSION = 1;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();
    }
}
