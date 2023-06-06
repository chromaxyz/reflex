// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Fixtures
import {TestHarness} from "./fixtures/TestHarness.sol";

// Mocks
import {MockImplementationState} from "./mocks/MockImplementationState.sol";

/**
 * @title Implementation State Test
 */
contract ImplementationStateTest is TestHarness {
    // =======
    // Storage
    // =======

    MockImplementationState public state;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        state = new MockImplementationState();
    }

    // =====
    // Tests
    // =====

    function testFuzzVerifyStorageSlot(bytes32 message_) external brutalizeMemory {
        state.setStorageSlot(message_);
        state.verifyStorageSlot(message_);
    }

    function testFuzzVerifyStorageSlots(
        bytes32 message_,
        uint256 number_,
        address location_,
        address tokenA_,
        address tokenB_,
        bool flag_
    ) external brutalizeMemory {
        state.setStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);

        // NOTE: `via-ir` throws `Index out of bounds`
        if (!_isProfile("via-ir") && !_isProfile("min-solc-via-ir")) {
            state.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
        }
    }
}
