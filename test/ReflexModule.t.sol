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

    uint32 internal constant _MODULE_VALID_ID = 5;
    uint16 internal constant _MODULE_VALID_TYPE_SINGLE = _MODULE_TYPE_SINGLE_ENDPOINT;
    uint16 internal constant _MODULE_VALID_VERSION = 1;
    bool internal constant _MODULE_VALID_UPGRADEABLE = true;

    uint32 internal constant _MODULE_INVALID_ID = 0;
    uint16 internal constant _MODULE_INVALID_TYPE = 777;
    uint16 internal constant _MODULE_INVALID_TYPE_ZERO = 0;
    uint16 internal constant _MODULE_INVALID_VERSION = 0;

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
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_VALID_TYPE_SINGLE,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE
            })
        );

        reentrancyAttack = new ReentrancyAttack();
    }

    // =====
    // Tests
    // =====

    function testUnitModuleSettings() external {
        _verifyModuleConfiguration(
            module,
            _MODULE_VALID_ID,
            _MODULE_VALID_TYPE_SINGLE,
            _MODULE_VALID_VERSION,
            _MODULE_VALID_UPGRADEABLE
        );

        assertEq(module.getReentrancyStatus(), _REENTRANCY_GUARD_UNLOCKED);
        assertEq(module.isReentrancyStatusLocked(), false);
        assertEq(module.reentrancyCounter(), 0);
    }

    function testUnitRevertInvalidModuleIdZeroValue() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleIdInvalid.selector, _MODULE_INVALID_ID));
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INVALID_ID,
                moduleType: _MODULE_VALID_TYPE_SINGLE,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE
            })
        );
    }

    function testUnitRevertInvalidModuleTypeZeroValue() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleTypeInvalid.selector, _MODULE_INVALID_TYPE_ZERO));
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_INVALID_TYPE_ZERO,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE
            })
        );
    }

    function testUnitRevertInvalidModuleTypeOverflowValue() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleTypeInvalid.selector, _MODULE_INVALID_TYPE));
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_INVALID_TYPE,
                moduleVersion: _MODULE_VALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE
            })
        );
    }

    function testUnitRevertInvalidModuleVersionZeroValue() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleVersionInvalid.selector, _MODULE_INVALID_VERSION));
        module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_VALID_ID,
                moduleType: _MODULE_VALID_TYPE_SINGLE,
                moduleVersion: _MODULE_INVALID_VERSION,
                moduleUpgradeable: _MODULE_VALID_UPGRADEABLE
            })
        );
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

    function testUnitRevertBytesEmptyError() external {
        vm.expectRevert(IReflexModule.EmptyError.selector);
        module.revertBytes("");
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

    // ======================
    // Reentrancy guard tests
    // ======================

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
