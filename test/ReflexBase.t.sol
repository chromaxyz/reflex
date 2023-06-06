// SPDX-License-Identifier: GPL-3.0-or-later
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

        assertEq(base.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);
        assertEq(base.getReentrancyStatusLocked(), false);
        assertEq(base.reentrancyCounter(), 0);
    }

    // =====
    // Tests
    // =====

    function testFuzzEarlyReturnRegisteredModule(uint32 moduleId_) external {
        vm.assume(moduleId_ > _MODULE_ID_INSTALLER);

        base.createEndpoint(moduleId_, _MODULE_TYPE_SINGLE_ENDPOINT, address(0));
        base.createEndpoint(moduleId_, _MODULE_TYPE_SINGLE_ENDPOINT, address(0));
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

    // ==============
    // Endpoint tests
    // ==============

    function testUnitRevertCreateEndpointInvalidModuleId() external {
        vm.expectRevert(InvalidModuleId.selector);
        base.createEndpoint(0, 0, address(0));
    }

    function testUnitRevertCreateEndpointInvalidModuleType() external {
        vm.expectRevert(InvalidModuleType.selector);
        base.createEndpoint(102, 0, address(0));

        vm.expectRevert(InvalidModuleType.selector);
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

        vm.expectRevert(ReadOnlyReentrancy.selector);
        base.readGuardedCheckProtected();

        base.readGuardedCheckUnprotected();

        assertEq(base.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);
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
