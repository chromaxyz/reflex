// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {Vm} from "forge-std/Vm.sol";

// Interfaces
import {TBaseDispatcher} from "../src/interfaces/IBaseDispatcher.sol";

// Fixtures
import {BaseFixture} from "./fixtures/BaseFixture.sol";

// Mocks
import {MockBaseDispatcher} from "./mocks/MockBaseDispatcher.sol";
import {MockBaseInstaller} from "./mocks/MockBaseInstaller.sol";
import {MockBaseModule} from "./mocks/MockBaseModule.sol";

/**
 * @title Base Dispatcher Test
 */
contract BaseDispatcherTest is TBaseDispatcher, BaseFixture {
    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();
    }

    // =====
    // Tests
    // =====

    function testRevertInvalidOwnerZeroAddress() external {
        vm.expectRevert(InvalidOwner.selector);
        new MockBaseDispatcher(address(0), address(installer));
    }

    function testRevertInvalidInstallerZeroAddress() external {
        vm.expectRevert(InvalidInstallerModuleAddress.selector);
        new MockBaseDispatcher(address(this), address(0));
    }

    function testRevertInvalidInstallerModuleIdSentinel() external {
        vm.expectRevert();
        new MockBaseDispatcher(address(this), address(_ALICE));
    }

    function testRevertInvalidInstallerModuleId(uint32 moduleId_) external {
        vm.assume(moduleId_ != 0);
        vm.assume(moduleId_ != _MODULE_ID_INSTALLER);

        MockBaseModule module = new MockBaseModule(
            moduleId_,
            _MODULE_TYPE_SINGLE_PROXY,
            1
        );

        vm.expectRevert(InvalidInstallerModuleId.selector);
        new MockBaseDispatcher(address(this), address(module));
    }

    function testLogEmittanceUponConstruction() external {
        vm.recordLogs();

        MockBaseDispatcher dispatcher = new MockBaseDispatcher(
            address(this),
            address(installer)
        );

        Vm.Log[] memory entries = vm.getRecordedLogs();

        // 2 logs are expected to be emitted.
        assertEq(entries.length, 2);

        // emit OwnershipTransferred(address(0), address(this));
        assertEq(entries[0].topics.length, 3);
        assertEq(
            entries[0].topics[0],
            keccak256("OwnershipTransferred(address,address)")
        );
        assertEq(entries[0].topics[1], bytes32(uint256(uint160(address(0)))));
        assertEq(
            entries[0].topics[2],
            bytes32(uint256(uint160(address(this))))
        );
        assertEq(entries[0].emitter, address(dispatcher));

        // emit ModuleAdded(
        //     _MODULE_ID_INSTALLER,
        //     address(installer),
        //     MockBaseInstaller(installer).moduleVersion()
        // );
        assertEq(entries[1].topics.length, 4);
        assertEq(
            entries[1].topics[0],
            keccak256("ModuleAdded(uint32,address,uint16)")
        );
        assertEq(entries[1].topics[1], bytes32(uint256(_MODULE_ID_INSTALLER)));
        assertEq(
            entries[1].topics[2],
            bytes32(uint256(uint160(address(installer))))
        );
        assertEq(
            entries[1].topics[3],
            bytes32(uint256(_INSTALLER_MODULE_VERSION))
        );
        assertEq(entries[1].emitter, address(dispatcher));
    }

    function testInstallerConfiguration() external {
        assertEq(
            dispatcher.moduleIdToImplementation(_MODULE_ID_INSTALLER),
            address(installer)
        );

        TBaseDispatcher.TrustRelation memory installerTrust = dispatcher
            .proxyAddressToTrustRelation(address(installerProxy));

        assertEq(installerTrust.moduleId, _MODULE_ID_INSTALLER);
        assertEq(address(installer), installerTrust.moduleImplementation);
    }

    function testGetOwnerThroughInstaller() external {
        assertEq(installerProxy.owner(), address(this));
    }

    function testUpdateOwnerThroughInstaller() external {
        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), address(0));

        installerProxy.transferOwnership(_ALICE);

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), address(_ALICE));

        vm.startPrank(_ALICE);

        installerProxy.acceptOwnership();

        assertEq(installerProxy.owner(), address(_ALICE));
        assertEq(installerProxy.pendingOwner(), address(0));

        vm.stopPrank();
    }

    function testRevertDispatchCalledNotTrusted() external {
        vm.expectRevert(CallerNotTrusted.selector);
        dispatcher.dispatch();
    }

    function testRevertDispatchMessageTooShort() external {
        vm.prank(address(installerProxy));
        vm.expectRevert(MessageTooShort.selector);
        dispatcher.dispatch();
    }
}
