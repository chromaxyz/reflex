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
    // =======
    // Storage
    // =======

    string internal _gasLabel;
    uint256 internal _gasStart;
    uint256 internal _gasUsed;

    // =========
    // Constants
    // =========

    uint16 internal constant _INSTALLER_MODULE_VERSION = 1;

    // =========
    // Modifiers
    // =========

    modifier GasCapture(string memory label_) {
        _startGasCapture(label_);

        _;

        _stopGasCapture();
    }

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        vm.label(_ALICE, "Alice");
        vm.label(_BOB, "Bob");
    }

    // =========
    // Utilities
    // =========

    function _startGasCapture(string memory label_) internal {
        _gasLabel = label_;
        _gasStart = gasleft();
    }

    function _stopGasCapture() internal {
        _gasUsed = _gasStart - gasleft();

        emit log_named_uint(
            string(abi.encodePacked("[GAS] ", _gasLabel)),
            _gasUsed
        );
    }
}
