// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseInstaller} from "../src/interfaces/IBaseInstaller.sol";
import {IBaseModule} from "../src/interfaces/IBaseModule.sol";

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

    uint32 internal constant _SINGLE_MODULE_ID = 100;
    uint16 internal constant _SINGLE_MODULE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _SINGLE_MODULE_VERSION_V1 = 1;
    uint16 internal constant _SINGLE_MODULE_VERSION_V2 = 2;

    // =======
    // Storage
    // =======

    MockBaseModule public singleModuleV1;
    MockBaseModule public singleModuleV2;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModuleV1 = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _SINGLE_MODULE_ID,
                moduleType: _SINGLE_MODULE_TYPE,
                moduleVersion: _SINGLE_MODULE_VERSION_V1,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );

        singleModuleV2 = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _SINGLE_MODULE_ID,
                moduleType: _SINGLE_MODULE_TYPE,
                moduleVersion: _SINGLE_MODULE_VERSION_V2,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );
    }

    // =====
    // Tests
    // =====

    // ===============
    // Ownership tests
    // ===============

    function testTransferOwnership() public {
        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferStarted(address(this), _users.Alice);
        installerProxy.transferOwnership(_users.Alice);

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _users.Alice);
    }

    function testAcceptOwnership() external {
        assertEq(installerProxy.pendingOwner(), address(0));

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferStarted(address(this), _users.Alice);
        installerProxy.transferOwnership(_users.Alice);

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _users.Alice);

        vm.startPrank(_users.Alice);

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferred(address(this), _users.Alice);
        installerProxy.acceptOwnership();

        vm.stopPrank();

        assertEq(installerProxy.owner(), _users.Alice);
        assertEq(installerProxy.pendingOwner(), address(0));
    }

    function testRevertTransferOwnershipNotPendingOwner() external {
        assertEq(installerProxy.pendingOwner(), address(0));

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferStarted(address(this), _users.Alice);
        installerProxy.transferOwnership(_users.Alice);

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _users.Alice);

        vm.startPrank(_users.Bob);

        vm.expectRevert(Unauthorized.selector);
        installerProxy.acceptOwnership();

        vm.stopPrank();

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _users.Alice);
    }

    function testRevertTransferOwnershipZeroAddress() external {
        vm.expectRevert(ZeroAddress.selector);
        installerProxy.transferOwnership(address(0));
    }

    // ====================
    // General module tests
    // ====================

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

    function testRevertUpgradeModulesModuleNonexistent() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(
            new MockBaseModule(
                IBaseModule.ModuleSettings({
                    moduleId: 777,
                    moduleType: _SINGLE_MODULE_TYPE,
                    moduleVersion: 777,
                    moduleUpgradeable: true,
                    moduleRemoveable: true
                })
            )
        );

        vm.expectRevert(
            abi.encodeWithSelector(ModuleNonexistent.selector, 777)
        );
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

    function testRevertRemoveModulesModuleNonexistent() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(
            new MockBaseModule(
                IBaseModule.ModuleSettings({
                    moduleId: 777,
                    moduleType: _SINGLE_MODULE_TYPE,
                    moduleVersion: 777,
                    moduleUpgradeable: true,
                    moduleRemoveable: true
                })
            )
        );

        vm.expectRevert(
            abi.encodeWithSelector(ModuleNonexistent.selector, 777)
        );
        installerProxy.removeModules(moduleAddresses);
    }

    function testRevertRemoveModulesNonContract() external {
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

    // =========================
    // Single-proxy module tests
    // =========================

    function testAddModulesSingleProxy() public {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV1);

        vm.expectEmit(true, true, false, false);
        emit ModuleAdded(
            _SINGLE_MODULE_ID,
            address(singleModuleV1),
            _SINGLE_MODULE_VERSION_V1
        );
        installerProxy.addModules(moduleAddresses);

        address singleModuleV1Implementation = dispatcher
            .moduleIdToImplementation(_SINGLE_MODULE_ID);
        address moduleProxy = dispatcher.moduleIdToProxy(_SINGLE_MODULE_ID);

        assertEq(singleModuleV1Implementation, address(singleModuleV1));
        assertTrue(moduleProxy != address(0));
        assertTrue(
            dispatcher.proxyAddressToTrustRelation(moduleProxy).moduleId ==
                _SINGLE_MODULE_ID
        );
        assertTrue(
            dispatcher
                .proxyAddressToTrustRelation(moduleProxy)
                .moduleImplementation == singleModuleV1Implementation
        );
    }

    function testUpgradeModulesSingleProxy() external {
        testAddModulesSingleProxy();

        address singleModuleV1Implementation = dispatcher
            .moduleIdToImplementation(_SINGLE_MODULE_ID);
        address moduleProxy = dispatcher.moduleIdToProxy(_SINGLE_MODULE_ID);

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV2);

        vm.expectEmit(true, true, false, false);
        emit ModuleUpgraded(
            _SINGLE_MODULE_ID,
            address(singleModuleV2),
            _SINGLE_MODULE_VERSION_V1
        );
        installerProxy.upgradeModules(moduleAddresses);

        address singleModuleV2Implementation = dispatcher
            .moduleIdToImplementation(_SINGLE_MODULE_ID);

        assertEq(moduleProxy, dispatcher.moduleIdToProxy(_SINGLE_MODULE_ID));
        assertTrue(
            singleModuleV1Implementation != singleModuleV2Implementation
        );
        assertEq(singleModuleV2Implementation, address(singleModuleV2));
        assertTrue(
            dispatcher.proxyAddressToTrustRelation(moduleProxy).moduleId ==
                _SINGLE_MODULE_ID
        );
        assertTrue(
            dispatcher
                .proxyAddressToTrustRelation(moduleProxy)
                .moduleImplementation == singleModuleV2Implementation
        );
    }

    function testRemoveModulesSingleProxy() external {
        testAddModulesSingleProxy();

        address moduleProxy = dispatcher.moduleIdToProxy(_SINGLE_MODULE_ID);

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV1);

        vm.expectEmit(true, true, false, false);
        emit ModuleRemoved(
            _SINGLE_MODULE_ID,
            address(singleModuleV1),
            _SINGLE_MODULE_VERSION_V1
        );
        installerProxy.removeModules(moduleAddresses);

        assertEq(dispatcher.moduleIdToProxy(_SINGLE_MODULE_ID), address(0));
        assertEq(
            dispatcher.moduleIdToImplementation(_SINGLE_MODULE_ID),
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

    // ========================
    // Multi-proxy module tests
    // ========================

    function testAddModulesMultiProxy() external {
        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(
            new MockBaseModule(
                IBaseModule.ModuleSettings({
                    moduleId: 2,
                    moduleType: _MODULE_TYPE_MULTI_PROXY,
                    moduleVersion: 1,
                    moduleUpgradeable: true,
                    moduleRemoveable: true
                })
            )
        );
        moduleAddresses[1] = address(
            new MockBaseModule(
                IBaseModule.ModuleSettings({
                    moduleId: 3,
                    moduleType: _MODULE_TYPE_MULTI_PROXY,
                    moduleVersion: 1,
                    moduleUpgradeable: true,
                    moduleRemoveable: true
                })
            )
        );
        installerProxy.addModules(moduleAddresses);

        assertEq(dispatcher.moduleIdToProxy(2), dispatcher.moduleIdToProxy(3));
        assertTrue(
            dispatcher.moduleIdToImplementation(2) !=
                dispatcher.moduleIdToImplementation(3)
        );
    }

    // =====================
    // Internal module tests
    // =====================

    // function testAddModulesInternal() external {
    //     address[] memory moduleAddresses = new address[](1);
    //     moduleAddresses[0] = address(
    //         new MockBaseModule(
    //             IBaseModule.ModuleSettings({
    //                 moduleId: 2,
    //                 moduleType: _MODULE_TYPE_INTERNAL,
    //                 moduleVersion: 1,
    //                 moduleUpgradeable: true,
    //                 moduleRemoveable: true
    //             })
    //         )
    //     );
    //     installerProxy.addModules(moduleAddresses);

    //     assertEq(singleModuleV1Implementation, address(singleModuleV1));
    //     assertTrue(moduleProxy != address(0));
    //     assertTrue(
    //         dispatcher.proxyAddressToTrustRelation(moduleProxy).moduleId ==
    //             _SINGLE_MODULE_ID
    //     );
    //     assertTrue(
    //         dispatcher
    //             .proxyAddressToTrustRelation(moduleProxy)
    //             .moduleImplementation == singleModuleV1Implementation
    //     );
    // }
}
