// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TReflexBase} from "../src/interfaces/IReflexBase.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {MockReflexBase, ReentrancyAttack} from "./mocks/MockReflexBase.sol";

/**
 * @title Reflex Base Test
 */
contract ReflexBaseTest is TReflexBase, ReflexFixture {
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

        assertEq(base.getReentrancyStatus(), _REENTRANCY_LOCK_UNLOCKED);
        assertEq(base.reentrancyCounter(), 0);
    }

    // =====
    // Tests
    // =====

    function testRevertCreateProxyInvalidModuleId() external {
        vm.expectRevert(InvalidModuleId.selector);
        base.createProxy(uint32(0), uint16(0));
    }

    function testRevertCreateProxyInvalidModuleType() external {
        vm.expectRevert(InvalidModuleType.selector);
        base.createProxy(uint32(1), uint16(0));
    }

    function testRevertCreateProxyInternalModule() external {
        vm.expectRevert(InternalModule.selector);
        base.createProxy(102, _MODULE_TYPE_INTERNAL);
    }

    function testRevertBytes(bytes memory errorMessage_) external {
        vm.assume(errorMessage_.length > 0);

        vm.expectRevert(errorMessage_);
        base.revertBytes(errorMessage_);
    }

    function testRevertBytesEmptyError() external {
        vm.expectRevert(EmptyError.selector);
        base.revertBytes("");
    }

    // ======================
    // Reentrancy guard tests
    // ======================

    function testGuardedCheckLocked() external {
        assertEq(base.getReentrancyStatus(), _REENTRANCY_LOCK_UNLOCKED);

        base.guardedCheckLocked();

        assertEq(base.getReentrancyStatus(), _REENTRANCY_LOCK_UNLOCKED);
    }

    function testUnguardedCheckUnlocked() external {
        assertEq(base.getReentrancyStatus(), _REENTRANCY_LOCK_UNLOCKED);

        base.unguardedCheckUnlocked();

        assertEq(base.getReentrancyStatus(), _REENTRANCY_LOCK_UNLOCKED);
    }

    function testNonReentrantMethodCanBeCalled() external {
        assertEq(base.reentrancyCounter(), 0);

        base.callback();

        assertEq(base.reentrancyCounter(), 1);
    }

    function testRevertRemoteCallback() external {
        vm.expectRevert(ReentrancyAttack.ReentrancyAttackFailed.selector);
        base.countAndCall(reentrancyAttack);
    }

    function testRevertRecursiveDirectCall() external {
        vm.expectRevert(Reentrancy.selector);
        base.countDirectRecursive(10);
    }

    function testRevertRecursiveIndirectCall() external {
        vm.expectRevert(Reentrancy.selector);
        base.countIndirectRecursive(10);
    }
}
