// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBase} from "../src/interfaces/IBase.sol";

// Fixtures
import {BaseFixture} from "./fixtures/BaseFixture.sol";

// Mocks
import {MockBase, ReentrancyAttack} from "./mocks/MockBase.sol";

/**
 * @title Base Test
 */
contract BaseTest is TBase, BaseFixture {
    // =======
    // Storage
    // =======

    MockBase public base;
    ReentrancyAttack public reentrancyAttack;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        base = new MockBase();
        reentrancyAttack = new ReentrancyAttack();

        assertEq(base.reentrancyCounter(), 0);
    }

    // =====
    // Tests
    // =====

    function testReentrancyLock() external {
        assertEq(base.getReentrancyStatus(), _REENTRANCY_LOCK_UNLOCKED);

        base.lockReentrancyLock();

        assertEq(base.getReentrancyStatus(), _REENTRANCY_LOCK_LOCKED);

        base.unlockReentrancyLock();

        assertEq(base.getReentrancyStatus(), _REENTRANCY_LOCK_UNLOCKED);
    }

    function testCallNonReentrantMethod() external {
        assertEq(base.reentrancyCounter(), 0);

        base.callback();

        assertEq(base.reentrancyCounter(), 1);
    }

    function testRevertCallRemoteCallback() external {
        vm.expectRevert(ReentrancyAttack.ReentrancyAttackFailed.selector);
        base.countAndCall(reentrancyAttack);
    }

    function testGuardedCheckLocked() external {
        base.guardedCheckLocked();
    }

    function testGuardedCheckUnlocked() external view {
        base.unguardedCheckUnlocked();
    }

    function testRevertRecursiveDirectCall() external {
        vm.expectRevert(Reentrancy.selector);
        base.countDirectRecursive(10);
    }

    function testRevertRecursiveIndirectCall() external {
        vm.expectRevert(Reentrancy.selector);
        base.countIndirectRecursive(10);
    }

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
}
