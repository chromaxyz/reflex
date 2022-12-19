// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseInstaller} from "../src/interfaces/IBaseInstaller.sol";

// Fixtures
import {BaseFixture} from "./fixtures/BaseFixture.sol";

// Mocks
import {MockBaseModule} from "./mocks/MockBaseModule.sol";

/**
 * @title Base Installer Test
 */
contract BaseInstallerTest is TBaseInstaller, BaseFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MOCK_MODULE_ID = 100;
    uint16 internal constant _MOCK_MODULE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MOCK_MODULE_VERSION_V1 = 1;
    uint16 internal constant _MOCK_MODULE_VERSION_V2 = 2;

    // =======
    // Storage
    // =======

    MockBaseModule public moduleV1;
    MockBaseModule public moduleV2;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        moduleV1 = new MockBaseModule(
            _MOCK_MODULE_ID,
            _MOCK_MODULE_TYPE,
            _MOCK_MODULE_VERSION_V1
        );

        moduleV2 = new MockBaseModule(
            _MOCK_MODULE_ID,
            _MOCK_MODULE_TYPE,
            _MOCK_MODULE_VERSION_V2
        );
    }

    // =====
    // Tests
    // =====

    function testSetName(string memory name_) public {
        vm.expectEmit(true, false, false, false);
        emit NameChanged(address(this), name_);
        installerProxy.setName(name_);
    }

    function testTransferOwnership() public {
        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferStarted(address(this), _ALICE);
        installerProxy.transferOwnership(_ALICE);

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _ALICE);
    }

    function testAcceptOwnership() external {
        assertEq(installerProxy.pendingOwner(), address(0));

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferStarted(address(this), _ALICE);
        installerProxy.transferOwnership(_ALICE);

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _ALICE);

        vm.startPrank(_ALICE);

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferred(address(this), _ALICE);
        installerProxy.acceptOwnership();

        vm.stopPrank();

        assertEq(installerProxy.owner(), _ALICE);
        assertEq(installerProxy.pendingOwner(), address(0));
    }

    function testRevertTransferOwnershipNotPendingOwner() external {
        assertEq(installerProxy.pendingOwner(), address(0));

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferStarted(address(this), _ALICE);
        installerProxy.transferOwnership(_ALICE);

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _ALICE);

        vm.startPrank(_BOB);

        vm.expectRevert(Unauthorized.selector);
        installerProxy.acceptOwnership();

        vm.stopPrank();

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _ALICE);
    }

    function testRevertTransferOwnershipZeroAddress() external {
        vm.expectRevert(ZeroAddress.selector);
        installerProxy.transferOwnership(address(0));
    }

    function testAddModules() public {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(moduleV1);

        vm.expectEmit(true, true, false, false);
        emit ModuleAdded(
            _MOCK_MODULE_ID,
            address(moduleV1),
            _MOCK_MODULE_VERSION_V1
        );
        installerProxy.addModules(moduleAddresses);

        address moduleV1Implementation = dispatcher.moduleIdToImplementation(
            _MOCK_MODULE_ID
        );
        address moduleProxy = dispatcher.moduleIdToProxy(_MOCK_MODULE_ID);

        assertEq(moduleV1Implementation, address(moduleV1));
        assertTrue(moduleProxy != address(0));
        assertTrue(
            dispatcher.proxyAddressToTrustRelation(moduleProxy).moduleId ==
                _MOCK_MODULE_ID
        );
        assertTrue(
            dispatcher
                .proxyAddressToTrustRelation(moduleProxy)
                .moduleImplementation == moduleV1Implementation
        );
    }

    function testAddModulesMultiProxy() external {
        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(
            new MockBaseModule(2, _MODULE_TYPE_MULTI_PROXY, 1)
        );
        moduleAddresses[1] = address(
            new MockBaseModule(3, _MODULE_TYPE_MULTI_PROXY, 1)
        );
        installerProxy.addModules(moduleAddresses);

        assertEq(dispatcher.moduleIdToProxy(2), dispatcher.moduleIdToProxy(3));
        assertTrue(
            dispatcher.moduleIdToImplementation(2) !=
                dispatcher.moduleIdToImplementation(3)
        );
    }

    function testRevertAddNonContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(1);

        vm.expectRevert();
        installerProxy.addModules(moduleAddresses);
    }

    function testRevertNonModuleIdContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(dispatcher);

        vm.expectRevert();
        installerProxy.addModules(moduleAddresses);
    }

    function testUpgradeModules() external {
        testAddModules();

        address moduleV1Implementation = dispatcher.moduleIdToImplementation(
            _MOCK_MODULE_ID
        );
        address moduleProxy = dispatcher.moduleIdToProxy(_MOCK_MODULE_ID);

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(moduleV2);

        vm.expectEmit(true, true, false, false);
        emit ModuleUpgraded(
            _MOCK_MODULE_ID,
            address(moduleV2),
            _MOCK_MODULE_VERSION_V1
        );
        installerProxy.upgradeModules(moduleAddresses);

        address moduleV2Implementation = dispatcher.moduleIdToImplementation(
            _MOCK_MODULE_ID
        );

        assertEq(moduleProxy, dispatcher.moduleIdToProxy(_MOCK_MODULE_ID));
        assertTrue(moduleV1Implementation != moduleV2Implementation);
        assertEq(moduleV2Implementation, address(moduleV2));
        assertTrue(
            dispatcher.proxyAddressToTrustRelation(moduleProxy).moduleId ==
                _MOCK_MODULE_ID
        );
        assertTrue(
            dispatcher
                .proxyAddressToTrustRelation(moduleProxy)
                .moduleImplementation == moduleV2Implementation
        );
    }

    function testRevertUpgradeModulesModuleNonexistent() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(
            new MockBaseModule(777, _MOCK_MODULE_TYPE, 777)
        );

        vm.expectRevert(ModuleNonexistent.selector);
        installerProxy.upgradeModules(moduleAddresses);
    }

    function testRevertUpgradeModulesNonContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(1);

        vm.expectRevert();
        installerProxy.upgradeModules(moduleAddresses);
    }

    function testRevertUpgradeModulesNonModuleIdContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(dispatcher);

        vm.expectRevert();
        installerProxy.upgradeModules(moduleAddresses);
    }

    function testRemoveModules() external {
        testAddModules();

        address moduleProxy = dispatcher.moduleIdToProxy(_MOCK_MODULE_ID);

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(moduleV1);

        vm.expectEmit(true, true, false, false);
        emit ModuleRemoved(
            _MOCK_MODULE_ID,
            address(moduleV1),
            _MOCK_MODULE_VERSION_V1
        );
        installerProxy.removeModules(moduleAddresses);

        assertEq(dispatcher.moduleIdToProxy(_MOCK_MODULE_ID), address(0));
        assertEq(
            dispatcher.moduleIdToImplementation(_MOCK_MODULE_ID),
            address(0)
        );
        assertEq(
            dispatcher.proxyAddressToTrustRelation(moduleProxy).moduleId,
            uint32(0)
        );
        assertEq(
            dispatcher
                .proxyAddressToTrustRelation(moduleProxy)
                .moduleImplementation,
            address(0)
        );
    }

    function testRevertRemoveModulesModuleNonexistent() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(
            new MockBaseModule(777, _MOCK_MODULE_TYPE, 777)
        );

        vm.expectRevert(ModuleNonexistent.selector);
        installerProxy.removeModules(moduleAddresses);
    }

    function testRevertRemoveModulesAddNonContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(1);

        vm.expectRevert();
        installerProxy.removeModules(moduleAddresses);
    }

    function testRevertRemoveModulesNonModuleIdContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(dispatcher);

        vm.expectRevert();
        installerProxy.removeModules(moduleAddresses);
    }
}
