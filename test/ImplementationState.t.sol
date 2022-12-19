// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendors
import {Test} from "forge-std/Test.sol";
import {stdStorageSafe, StdStorage} from "forge-std/StdStorage.sol";

// Tests
import {ImplementationState} from "./implementations/ImplementationState.sol";

/**
 * @title Implementation State Test
 *
 * @dev Storage layout:
 * | Name          | Type                                                | Slot | Offset | Bytes |
 * |---------------|-----------------------------------------------------|------|--------|-------|
 * | _name         | string                                              | 0    | 0      | 32    |
 * | _owner        | address                                             | 1    | 0      | 20    |
 * | _pendingOwner | address                                             | 2    | 0      | 20    |
 * | _modules      | mapping(uint32 => address)                          | 3    | 0      | 32    |
 * | _proxies      | mapping(uint32 => address)                          | 4    | 0      | 32    |
 * | _trusts       | mapping(address => struct TBaseState.TrustRelation) | 5    | 0      | 32    |
 * | __gap         | uint256[45]                                         | 6    | 0      | 1440  |
 * | _exampleSlot1 | bytes32                                             | 51   | 0      | 32    |
 * | _exampleSlot2 | uint256                                             | 52   | 0      | 32    |
 * | _exampleSlot3 | address                                             | 53   | 0      | 20    |
 * | getSlot4      | address                                             | 54   | 0      | 20    |
 * | getSlot5      | bool                                                | 54   | 20     | 1     |
 * | _exampleSlot6 | mapping(address => uint256)                         | 55   | 0      | 32    |
 */
contract ImplementationStateTest is Test {
    using stdStorageSafe for StdStorage;

    // =======
    // Storage
    // =======

    ImplementationState public state;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        state = new ImplementationState();
    }

    // =====
    // Tests
    // =====

    function testVerifyStorageSlots(
        bytes32 message_,
        uint256 number_,
        address location_,
        bool flag_
    ) external {
        vm.assume(number_ != 0);
        vm.assume(location_ != address(0));

        state.setSlot1(message_);
        state.setSlot2(number_);
        state.setSlot3(location_);
        state.setSlot4(location_);
        state.setSlot5(flag_);
        state.setSlot6(location_, number_);

        /**
         * | Name          | Type                                                | Slot | Offset | Bytes |
         * |---------------|-----------------------------------------------------|------|--------|-------|
         * | _exampleSlot1 | bytes32                                             | 51   | 0      | 32    |
         */
        assertEq(stdstore.target(address(state)).sig("getSlot1()").find(), 51);
        assertEq(
            stdstore.target(address(state)).sig("getSlot1()").read_bytes32(),
            message_
        );

        /**
         * | Name          | Type                                                | Slot | Offset | Bytes |
         * |---------------|-----------------------------------------------------|------|--------|-------|
         * | _exampleSlot2 | uint256                                             | 52   | 0      | 32    |
         */
        assertEq(stdstore.target(address(state)).sig("getSlot2()").find(), 52);
        assertEq(
            stdstore.target(address(state)).sig("getSlot2()").read_uint(),
            number_
        );

        /**
         * | Name          | Type                                                | Slot | Offset | Bytes |
         * |---------------|-----------------------------------------------------|------|--------|-------|
         * | _exampleSlot3 | address                                             | 53   | 0      | 20    |
         */
        assertEq(stdstore.target(address(state)).sig("getSlot3()").find(), 53);
        assertEq(
            stdstore.target(address(state)).sig("getSlot3()").read_address(),
            location_
        );

        // Due to StdStorage not supporting packed slots at this point in time we access
        // the underlying storage slots directly.

        bytes32[] memory reads;
        bytes32 current;

        /**
         * | Name          | Type                                                | Slot | Offset | Bytes |
         * |---------------|-----------------------------------------------------|------|--------|-------|
         * | getSlot4      | address                                             | 54   | 0      | 20    |
         */
        vm.record();
        state.getSlot4();
        (reads, ) = vm.accesses(address(state));
        assertEq(uint256(reads[0]), 54);
        current = vm.load(address(state), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), location_);

        /**
         * | Name          | Type                                                | Slot | Offset | Bytes |
         * |---------------|-----------------------------------------------------|------|--------|-------|
         * | getSlot5      | bool                                                | 54   | 20     | 1     |
         */
        vm.record();
        state.getSlot5();
        (reads, ) = vm.accesses(address(state));
        assertEq(uint256(reads[0]), 54);
        current = vm.load(address(state), bytes32(reads[0]));
        assertEq(uint8(uint256(current) >> (20 * 8)), _castBoolToUint8(flag_));

        /**
         * | Name          | Type                                                | Slot | Offset | Bytes |
         * |---------------|-----------------------------------------------------|------|--------|-------|
         * | _exampleSlot6 | mapping(address => uint256)                         | 55   | 0      | 32    |
         */

        vm.record();
        state.getSlot6(location_);
        (reads, ) = vm.accesses(address(state));
        assertEq((reads[0]), keccak256(abi.encode(location_, uint256(55))));
        current = vm.load(address(state), bytes32(reads[0]));
        assertEq(uint256(current), number_);
    }

    // =========
    // Utilities
    // =========

    function _castBoolToUint8(bool x) internal pure returns (uint8 r) {
        assembly {
            r := x
        }
    }
}
