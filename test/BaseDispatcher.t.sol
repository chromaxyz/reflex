// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseDispatcher} from "../src/interfaces/IBaseDispatcher.sol";

// Fixtures
import {Fixture} from "./fixtures/Fixture.sol";

/**
 * @title Base Dispatcher Test
 */
contract BaseDispatcherTest is TBaseDispatcher, Fixture {
    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();
    }

    // =====
    // Tests
    // =====

    function testName() external {
        assertEq(dispatcher.name(), "Dispatcher");
    }

    function testInstallerConfiguration() external {
        assertEq(
            dispatcher.moduleIdToImplementation(_INSTALLER_MODULE_ID),
            address(installer)
        );

        TBaseDispatcher.TrustRelation memory installerTrust = dispatcher
            .proxyAddressToTrustRelation(address(installerProxy));

        assertEq(installerTrust.moduleId, _INSTALLER_MODULE_ID);
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
