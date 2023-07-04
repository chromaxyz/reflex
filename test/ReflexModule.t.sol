// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
import {VmSafe} from "forge-std/Vm.sol";

// Interfaces
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {MockReflexModule, ReentrancyAttack} from "./mocks/MockReflexModule.sol";

/**
 * @title Reflex Module Test
 */
contract ReflexModuleTest is ReflexFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_VALID = 777;
    uint16 internal constant _MODULE_TYPE_VALID = _MODULE_TYPE_SINGLE_ENDPOINT;

    uint32 internal constant _MODULE_ID_INVALID = 0;
    uint16 internal constant _MODULE_TYPE_INVALID = 777;
    uint16 internal constant _MODULE_TYPE_INVALID_ZERO = 0;

    // =======
    // Storage
    // =======

    MockReflexModule public module;
    MockReflexModule public moduleEndpoint;
    ReentrancyAttack public reentrancyAttack;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        module = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_VALID, moduleType: _MODULE_TYPE_VALID})
        );

        reentrancyAttack = new ReentrancyAttack();
    }

    // =====
    // Tests
    // =====

    function testUnitModuleSettings() external {
        _verifyModuleConfiguration(module, _MODULE_ID_VALID, _MODULE_TYPE_VALID);

        assertEq(module.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);
        assertEq(module.isReentrancyStatusLocked(), false);
        assertEq(module.reentrancyCounter(), 0);
    }

    function testUnitRevertInvalidModuleIdZeroValue() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleIdInvalid.selector, _MODULE_ID_INVALID));
        new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_INVALID, moduleType: _MODULE_TYPE_VALID})
        );
    }

    function testUnitRevertInvalidModuleTypeZeroValue() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleTypeInvalid.selector, _MODULE_TYPE_INVALID_ZERO));
        new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_VALID, moduleType: _MODULE_TYPE_INVALID_ZERO})
        );
    }

    function testUnitRevertInvalidModuleTypeOverflowValue() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleTypeInvalid.selector, _MODULE_TYPE_INVALID));
        new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_VALID, moduleType: _MODULE_TYPE_INVALID})
        );
    }

    // ==============
    // Endpoint tests
    // ==============

    function testUnitRevertCreateEndpointInvalidModuleId() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleIdInvalid.selector, 0));
        module.createEndpoint(0, 0, address(0));
    }

    function testUnitRevertCreateEndpointInvalidModuleType() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleTypeInvalid.selector, 0));
        module.createEndpoint(102, 0, address(0));

        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleTypeInvalid.selector, _MODULE_TYPE_INTERNAL));
        module.createEndpoint(102, _MODULE_TYPE_INTERNAL, address(0));
    }

    function testUnitRevertBytesEmptyError() external {
        vm.expectRevert(IReflexModule.EmptyError.selector);
        module.revertBytes("");
    }

    function testFuzzEarlyReturnRegisteredModule(uint32 moduleId_) external {
        vm.assume(moduleId_ > _MODULE_ID_INSTALLER);

        vm.recordLogs();

        address endpointAddress = module.createEndpoint(moduleId_, _MODULE_TYPE_SINGLE_ENDPOINT, address(0));

        VmSafe.Log[] memory entries = vm.getRecordedLogs();

        // 1 log is expected to be emitted.
        assertEq(entries.length, 1);

        // emit EndpointCreated(address,uint32)
        assertEq(entries[0].topics.length, 3);
        assertEq(entries[0].topics[0], keccak256("EndpointCreated(uint32,address)"));
        assertEq(entries[0].topics[1], bytes32(uint256(moduleId_)));
        assertEq(entries[0].topics[2], bytes32(uint256(uint160(address(endpointAddress)))));
        assertEq(entries[0].emitter, address(module));

        vm.recordLogs();

        module.createEndpoint(moduleId_, _MODULE_TYPE_SINGLE_ENDPOINT, address(0));

        entries = vm.getRecordedLogs();

        // No log is expected to be emitted.
        assertEq(entries.length, 0);
    }

    function testFuzzRevertBytes(bytes memory errorMessage_) external {
        vm.assume(errorMessage_.length > 0);

        vm.expectRevert(errorMessage_);
        module.revertBytes(errorMessage_);
    }

    // ================
    // Reentrancy tests
    // ================

    function testUnitGuardedCheckLocked() external {
        assertEq(module.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);

        module.guardedCheckLocked();

        assertEq(module.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);
    }

    function testUnitUnguardedCheckUnlocked() external {
        assertEq(module.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);

        module.unguardedCheckUnlocked();

        assertEq(module.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);
    }

    function testUnitRevertReadGuardedCheckLocked() external {
        assertEq(module.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);

        vm.expectRevert(IReflexModule.ReadOnlyReentrancy.selector);
        module.readGuardedCheckProtected();

        module.readGuardedCheckUnprotected();

        assertEq(module.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);
    }

    function testUnitRevertRemoteCallback() external {
        vm.expectRevert(ReentrancyAttack.ReentrancyAttackFailed.selector);
        module.countAndCall(reentrancyAttack);
    }

    function testUnitRevertRecursiveDirectCall() external {
        vm.expectRevert(IReflexModule.Reentrancy.selector);
        module.countDirectRecursive(10);
    }

    function testUnitRevertRecursiveIndirectCall() external {
        vm.expectRevert(IReflexModule.Reentrancy.selector);
        module.countIndirectRecursive(10);
    }
}
