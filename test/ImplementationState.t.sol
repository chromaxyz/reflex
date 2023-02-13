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

    function setUp() public virtual override {
        super.setUp();

        state = new MockImplementationState();
    }

    // =====
    // Tests
    // =====

    function testFuzzVerifyStorageSlot(bytes32 message_) external BrutalizeMemory {
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
    ) external BrutalizeMemory {
        state.setStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
        // state.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
    }
}
