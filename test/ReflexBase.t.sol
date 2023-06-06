// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
import {VmSafe} from "forge-std/Vm.sol";

// Interfaces
import {IReflexBase} from "../src/interfaces/IReflexBase.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {MockReflexBase, ReentrancyAttack} from "./mocks/MockReflexBase.sol";

/**
 * @title Reflex Base Test
 */
contract ReflexBaseTest is ReflexFixture {
    // =======
    // Storage
    // =======

    MockReflexBase public base;
    ReentrancyAttack public reentrancyAttack;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        base = new MockReflexBase();
        reentrancyAttack = new ReentrancyAttack();

        assertEq(base.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);
        assertEq(base.getReentrancyStatusLocked(), false);
        assertEq(base.reentrancyCounter(), 0);
    }

    // =====
    // Tests
    // =====

    function testFuzzEarlyReturnRegisteredModule(uint32 moduleId_) external {
        vm.assume(moduleId_ > _MODULE_ID_INSTALLER);

        vm.recordLogs();

        address endpoint = base.createEndpoint(moduleId_, _MODULE_TYPE_SINGLE_ENDPOINT, address(0));

        VmSafe.Log[] memory entries = vm.getRecordedLogs();

        // 1 log is expected to be emitted.
        assertEq(entries.length, 1);

        // emit EndpointCreated(address,uint32)
        assertEq(entries[0].topics.length, 3);
        assertEq(entries[0].topics[0], keccak256("EndpointCreated(uint32,address)"));
        assertEq(entries[0].topics[1], bytes32(uint256(moduleId_)));
        assertEq(entries[0].topics[2], bytes32(uint256(uint160(address(endpoint)))));
        assertEq(entries[0].emitter, address(base));

        vm.recordLogs();

        base.createEndpoint(moduleId_, _MODULE_TYPE_SINGLE_ENDPOINT, address(0));

        entries = vm.getRecordedLogs();

        // No log is expected to be emitted.
        assertEq(entries.length, 0);
    }

    function testFuzzRevertBytes(bytes memory errorMessage_) external {
        vm.assume(errorMessage_.length > 0);

        vm.expectRevert(errorMessage_);
        base.revertBytes(errorMessage_);
    }

    function testUnitRevertBytesEmptyError() external {
        vm.expectRevert(IReflexBase.EmptyError.selector);
        base.revertBytes("");
    }

    // ==============
    // Endpoint tests
    // ==============

    function testUnitRevertCreateEndpointInvalidModuleId() external {
        vm.expectRevert(IReflexBase.ModuleIdInvalid.selector);
        base.createEndpoint(0, 0, address(0));
    }

    function testUnitRevertCreateEndpointInvalidModuleType() external {
        vm.expectRevert(IReflexBase.ModuleTypeInvalid.selector);
        base.createEndpoint(102, 0, address(0));

        vm.expectRevert(IReflexBase.ModuleTypeInvalid.selector);
        base.createEndpoint(102, _MODULE_TYPE_INTERNAL, address(0));
    }

    // ======================
    // Reentrancy guard tests
    // ======================

    function testUnitGuardedCheckLocked() external {
        assertEq(base.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);

        base.guardedCheckLocked();

        assertEq(base.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);
    }

    function testUnitUnguardedCheckUnlocked() external {
        assertEq(base.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);

        base.unguardedCheckUnlocked();

        assertEq(base.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);
    }

    function testUnitRevertReadGuardedCheckLocked() external {
        assertEq(base.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);

        vm.expectRevert(IReflexBase.ReadOnlyReentrancy.selector);
        base.readGuardedCheckProtected();

        base.readGuardedCheckUnprotected();

        assertEq(base.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);
    }

    function testUnitRevertRemoteCallback() external {
        vm.expectRevert(ReentrancyAttack.ReentrancyAttackFailed.selector);
        base.countAndCall(reentrancyAttack);
    }

    function testUnitRevertRecursiveDirectCall() external {
        vm.expectRevert(IReflexBase.Reentrancy.selector);
        base.countDirectRecursive(10);
    }

    function testUnitRevertRecursiveIndirectCall() external {
        vm.expectRevert(IReflexBase.Reentrancy.selector);
        base.countIndirectRecursive(10);
    }
}
