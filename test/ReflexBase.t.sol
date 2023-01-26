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

    function testUnitRevertCreateProxyInvalidModuleId() external {
        vm.expectRevert(InvalidModuleId.selector);
        base.createProxy(uint256(0), uint256(0));
    }

    function testUnitRevertCreateProxyInvalidModuleType() external {
        vm.expectRevert(InvalidModuleType.selector);
        base.createProxy(uint256(1), uint256(0));
    }

    function testUnitRevertCreateProxyInternalModule() external {
        vm.expectRevert(InternalModule.selector);
        base.createProxy(102, _MODULE_TYPE_INTERNAL);
    }

    function testFuzzRevertBytes(bytes memory errorMessage_) external {
        vm.assume(errorMessage_.length > 0);

        vm.expectRevert(errorMessage_);
        base.revertBytes(errorMessage_);
    }

    function testUnitRevertBytesEmptyError() external {
        vm.expectRevert(EmptyError.selector);
        base.revertBytes("");
    }

    // ======================
    // Reentrancy guard tests
    // ======================

    function testUnitGuardedCheckLocked() external {
        assertEq(base.getReentrancyStatus(), _REENTRANCY_LOCK_UNLOCKED);

        base.guardedCheckLocked();

        assertEq(base.getReentrancyStatus(), _REENTRANCY_LOCK_UNLOCKED);
    }

    function testUnitUnguardedCheckUnlocked() external {
        assertEq(base.getReentrancyStatus(), _REENTRANCY_LOCK_UNLOCKED);

        base.unguardedCheckUnlocked();

        assertEq(base.getReentrancyStatus(), _REENTRANCY_LOCK_UNLOCKED);
    }

    function testUnitNonReentrantMethodCanBeCalled() external {
        assertEq(base.reentrancyCounter(), 0);

        base.callback();

        assertEq(base.reentrancyCounter(), 1);
    }

    function testUnitRevertRemoteCallback() external {
        vm.expectRevert(ReentrancyAttack.ReentrancyAttackFailed.selector);
        base.countAndCall(reentrancyAttack);
    }

    function testUnitRevertRecursiveDirectCall() external {
        vm.expectRevert(Reentrancy.selector);
        base.countDirectRecursive(10);
    }

    function testUnitRevertRecursiveIndirectCall() external {
        vm.expectRevert(Reentrancy.selector);
        base.countIndirectRecursive(10);
    }
}
