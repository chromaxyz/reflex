// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
import {VmSafe} from "forge-std/Vm.sol";

// Interfaces
import {IReflexDispatcher} from "../src/interfaces/IReflexDispatcher.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {MockReflexDispatcher} from "./mocks/MockReflexDispatcher.sol";
import {MockReflexModule} from "./mocks/MockReflexModule.sol";

/**
 * @title Reflex Dispatcher Test
 */
contract ReflexDispatcherTest is ReflexFixture {
    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();
    }

    // =====
    // Tests
    // =====

    function testUnitRevertInvalidOwnerZeroAddress() external {
        vm.expectRevert(IReflexDispatcher.ZeroAddress.selector);
        new MockReflexDispatcher(address(0), address(installerModuleV1));
    }

    function testUnitRevertInvalidInstallerZeroAddress() external {
        vm.expectRevert(IReflexDispatcher.ZeroAddress.selector);
        new MockReflexDispatcher(address(this), address(0));
    }

    function testUnitRevertInvalidInstallerModuleId() external {
        vm.expectRevert();
        new MockReflexDispatcher(address(this), address(_users.Alice));
    }

    function testFuzzRevertInvalidInstallerModuleId(uint32 moduleId_) external {
        vm.assume(moduleId_ != 0);
        vm.assume(moduleId_ != _MODULE_ID_INSTALLER);

        MockReflexModule module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: moduleId_,
                moduleType: _MODULE_TYPE_SINGLE_ENDPOINT,
                moduleVersion: _MODULE_VERSION_INSTALLER_V1,
                moduleUpgradeable: true
            })
        );

        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleIdInvalid.selector, moduleId_));
        new MockReflexDispatcher(address(this), address(module));
    }

    function testUnitRevertInvalidInstallerModuleType() external {
        MockReflexModule module = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_MULTI_ENDPOINT,
                moduleVersion: _MODULE_VERSION_INSTALLER_V1,
                moduleUpgradeable: true
            })
        );

        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleTypeInvalid.selector, _MODULE_TYPE_MULTI_ENDPOINT));
        new MockReflexDispatcher(address(this), address(module));
    }

    function testUnitLogEmittanceUponConstruction() external {
        vm.recordLogs();

        MockReflexDispatcher dispatcher = new MockReflexDispatcher(address(this), address(installerModuleV1));

        address installerEndpoint = dispatcher.getEndpoint(_MODULE_ID_INSTALLER);

        VmSafe.Log[] memory entries = vm.getRecordedLogs();

        // TODO: now only `indexed` parameters are checked

        // 3 logs are expected to be emitted.
        assertEq(entries.length, 3);

        // emit EndpointCreated(address,uint32)
        assertEq(entries[0].topics.length, 3);
        assertEq(entries[0].topics[0], keccak256("EndpointCreated(uint32,address)"));
        assertEq(entries[0].topics[1], bytes32(uint256(_MODULE_ID_INSTALLER)));
        assertEq(entries[0].topics[2], bytes32(uint256(uint160(address(installerEndpoint)))));
        assertEq(entries[0].emitter, address(dispatcher));

        // emit OwnershipTransferred(address,address);
        assertEq(entries[1].topics.length, 3);
        assertEq(entries[1].topics[0], keccak256("OwnershipTransferred(address,address)"));
        assertEq(entries[1].topics[1], bytes32(uint256(uint160(address(0)))));
        assertEq(entries[1].topics[2], bytes32(uint256(uint160(address(this)))));
        assertEq(entries[1].emitter, address(dispatcher));

        // emit ModuleAdded(uint32,address,uint32);
        assertEq(entries[2].topics.length, 3);
        assertEq(entries[2].topics[0], keccak256("ModuleAdded(uint32,address,uint32)"));
        assertEq(entries[2].topics[1], bytes32(uint256(_MODULE_ID_INSTALLER)));
        assertEq(entries[2].topics[2], bytes32(uint256(uint160(address(installerModuleV1)))));
        assertEq(entries[2].emitter, address(dispatcher));
    }

    function testUnitInstallerConfiguration() external {
        assertEq(dispatcher.getEndpoint(_MODULE_ID_INSTALLER), address(installerEndpoint));
        assertEq(dispatcher.getModuleImplementation(_MODULE_ID_INSTALLER), address(installerModuleV1));
    }

    function testUnitGetOwnerThroughInstallerEndpoint() external {
        assertEq(installerEndpoint.owner(), address(this));
    }

    function testUnitUpdateOwnerThroughInstallerEndpoint() external {
        assertEq(installerEndpoint.owner(), address(this));
        assertEq(installerEndpoint.pendingOwner(), address(0));

        installerEndpoint.transferOwnership(_users.Alice);

        assertEq(installerEndpoint.owner(), address(this));
        assertEq(installerEndpoint.pendingOwner(), address(_users.Alice));

        vm.startPrank(_users.Alice);

        installerEndpoint.acceptOwnership();

        assertEq(installerEndpoint.owner(), address(_users.Alice));
        assertEq(installerEndpoint.pendingOwner(), address(0));

        vm.stopPrank();
    }

    function testUnitRevertDispatchCalledNotTrusted() external {
        (bool success, bytes memory result) = address(dispatcher).call("");

        assertFalse(success);

        vm.expectRevert(IReflexDispatcher.CallerNotTrusted.selector);
        assembly ("memory-safe") {
            revert(add(32, result), mload(result))
        }
    }

    function testUnitRevertDispatchMessageTooShort() external {
        vm.prank(address(installerEndpoint));

        (bool success, bytes memory result) = address(dispatcher).call("");

        assertFalse(success);

        vm.expectRevert(IReflexDispatcher.MessageTooShort.selector);
        assembly ("memory-safe") {
            revert(add(32, result), mload(result))
        }
    }
}
