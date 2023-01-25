// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {TestHarness} from "./fixtures/TestHarness.sol";

// Mocks
import {MockImplementationState} from "./mocks/MockImplementationState.sol";

/**
 * @title Implementation State Test
 *
 * @dev Storage layout:
 * | Name                    | Type                                                  | Slot | Offset | Bytes |
 * |-------------------------|-------------------------------------------------------|------|--------|-------|
 * | _reentrancyLock         | uint256                                               | 0    | 0      | 32    |
 * | _owner                  | address                                               | 1    | 0      | 20    |
 * | _pendingOwner           | address                                               | 2    | 0      | 20    |
 * | _modules                | mapping(uint32 => address)                            | 3    | 0      | 32    |
 * | _proxies                | mapping(uint32 => address)                            | 4    | 0      | 32    |
 * | _relations              | mapping(address => struct TReflexState.TrustRelation) | 5    | 0      | 32    |
 * | __gap                   | uint256[44]                                           | 6    | 0      | 1408  |
 * | _implementationState0   | bytes32                                               | 50   | 0      | 32    |
 * | _implementationState1   | uint256                                               | 51   | 0      | 32    |
 * | _implementationState2   | address                                               | 52   | 0      | 20    |
 * | getImplementationState3 | address                                               | 53   | 0      | 20    |
 * | getImplementationState4 | bool                                                  | 53   | 20     | 1     |
 * | _implementationState5   | mapping(address => uint256)                           | 54   | 0      | 32    |
 * | _tokens                 | mapping(address => struct ImplementationState.Token)  | 55   | 0      | 32    |
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

    function testFuzzVerifyStorageSlots(
        bytes32 message_,
        uint256 number_,
        address location_,
        address tokenA_,
        address tokenB_,
        bool flag_
    ) external BrutalizeMemory {
        state.setStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
        state.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
    }
}
