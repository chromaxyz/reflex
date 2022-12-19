// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendors
import {Test} from "forge-std/Test.sol";
import {stdStorage, StdStorage} from "forge-std/StdStorage.sol";

// Tests
import {ImplementationState} from "./implementations/ImplementationState.sol";

/**
 * @title Implementation State Test
 */
contract ImplementationStateTest is Test {
    using stdStorage for StdStorage;

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
        address location_
    ) external {
        state.setSlot1(message_);
        state.setSlot2(number_);
        state.setSlot3(location_);
        state.setSlot4(location_);

        assertEq(stdstore.target(address(state)).sig("getSlot1()").find(), 51);
        assertEq(
            stdstore.target(address(state)).sig("getSlot1()").read_bytes32(),
            message_
        );
        assertEq(stdstore.target(address(state)).sig("getSlot2()").find(), 52);
        assertEq(
            stdstore.target(address(state)).sig("getSlot2()").read_uint(),
            number_
        );
        assertEq(stdstore.target(address(state)).sig("getSlot3()").find(), 53);
        assertEq(
            stdstore.target(address(state)).sig("getSlot3()").read_address(),
            location_
        );
        assertEq(stdstore.target(address(state)).sig("getSlot4()").find(), 54);
        assertEq(
            stdstore.target(address(state)).sig("getSlot4()").read_address(),
            location_
        );
    }
}
