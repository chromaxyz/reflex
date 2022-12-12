// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TDispatcher} from "../src/interfaces/IDispatcher.sol";

// Fixtures
import {Fixture} from "./fixtures/Fixture.sol";

/**
 * @title Dispatcher Test
 */
contract DispatcherTest is TDispatcher, Fixture {
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
        assertEq(reflex.name(), "Dispatcher");
    }

    function testInstallerConfiguration() external {
        assertEq(
            reflex.moduleIdToImplementation(_MODULE_ID_INSTALLER),
            address(installer)
        );

        TDispatcher.TrustRelation memory installerTrust = reflex
            .proxyAddressToTrust(address(installerProxy));

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
        reflex.dispatch();
    }

    function testRevertDispatchMessageTooShort() external {
        vm.prank(address(installerProxy));
        vm.expectRevert(MessageTooShort.selector);
        reflex.dispatch();
    }

    // TODO: add test for moduleImplementation == 0
}
