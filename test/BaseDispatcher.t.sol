// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseDispatcher} from "../src/interfaces/IBaseDispatcher.sol";

// Fixtures
import {BaseFixture} from "./fixtures/BaseFixture.sol";

// Mocks
import {MockBaseDispatcher} from "./mocks/MockBaseDispatcher.sol";
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

    function testRevertInvalidNameZeroLength() external {
        vm.expectRevert(InvalidName.selector);
        new MockBaseDispatcher("", address(this), address(installer));
    }

    function testRevertInvalidOwnerZeroAddress() external {
        vm.expectRevert(InvalidOwner.selector);
        new MockBaseDispatcher("Dispatchher", address(0), address(installer));
    }

    function testRevertInvalidInstallerZeroAddress() external {
        vm.expectRevert(InvalidInstallerModuleAddress.selector);
        new MockBaseDispatcher("Dispatcher", address(this), address(0));
    }

    function testRevertInvalidInstallerModuleIdSentinel() external {
        vm.expectRevert();
        new MockBaseDispatcher("Dispatcher", address(this), address(_ALICE));
    }

    function testRevertInvalidInstallerModuleId(uint32 moduleId_) external {
        vm.assume(moduleId_ != 0);
        vm.assume(moduleId_ != _BUILT_IN_MODULE_ID_INSTALLER);

        MockBaseModule module = new MockBaseModule(
            moduleId_,
            _MODULE_TYPE_SINGLE_PROXY,
            1
        );

        vm.expectRevert(InvalidInstallerModuleId.selector);
        new MockBaseDispatcher("Dispatcher", address(this), address(module));
    }

    function testName() external {
        assertEq(dispatcher.name(), "Dispatcher");
    }

    function testInstallerConfiguration() external {
        assertEq(
            dispatcher.moduleIdToImplementation(_BUILT_IN_MODULE_ID_INSTALLER),
            address(installer)
        );

        TBaseDispatcher.TrustRelation memory installerTrust = dispatcher
            .proxyAddressToTrustRelation(address(installerProxy));

        assertEq(installerTrust.moduleId, _BUILT_IN_MODULE_ID_INSTALLER);
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
