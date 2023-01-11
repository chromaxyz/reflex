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

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION_V1 = 1;
    uint16 internal constant _MODULE_SINGLE_VERSION_V2 = 2;
    uint16 internal constant _MODULE_SINGLE_VERSION_V3 = 3;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V2 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V3 = false;
    bool internal constant _MODULE_SINGLE_REMOVEABLE_V1 = true;
    bool internal constant _MODULE_SINGLE_REMOVEABLE_V2 = true;
    bool internal constant _MODULE_SINGLE_REMOVEABLE_V3 = false;

    uint32 internal constant _MODULE_MULTI_ID = 101;
    uint16 internal constant _MODULE_MULTI_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _MODULE_MULTI_VERSION_V1 = 1;
    uint16 internal constant _MODULE_MULTI_VERSION_V2 = 2;
    uint16 internal constant _MODULE_MULTI_VERSION_V3 = 3;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V2 = true;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V3 = false;
    bool internal constant _MODULE_MULTI_REMOVEABLE_V1 = true;
    bool internal constant _MODULE_MULTI_REMOVEABLE_V2 = true;
    bool internal constant _MODULE_MULTI_REMOVEABLE_V3 = false;

    uint32 internal constant _MODULE_INTERNAL_ID = 102;
    uint16 internal constant _MODULE_INTERNAL_TYPE = _MODULE_TYPE_INTERNAL;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V1 = 1;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V2 = 2;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V3 = 3;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V2 = true;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V3 = false;
    bool internal constant _MODULE_INTERNAL_REMOVEABLE_V1 = true;
    bool internal constant _MODULE_INTERNAL_REMOVEABLE_V2 = true;
    bool internal constant _MODULE_INTERNAL_REMOVEABLE_V3 = false;

    // =======
    // Storage
    // =======

    MockBaseModule public singleModuleV1;
    MockBaseModule public singleModuleV2;
    MockBaseModule public singleModuleV3;

    MockBaseModule public multiModuleV1;
    MockBaseModule public multiModuleV2;
    MockBaseModule public multiModuleV3;

    MockBaseModule public internalModuleV1;
    MockBaseModule public internalModuleV2;
    MockBaseModule public internalModuleV3;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModuleV1 = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V1,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V1,
                moduleRemoveable: _MODULE_SINGLE_REMOVEABLE_V1
            })
        );

        singleModuleV2 = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V2,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V2,
                moduleRemoveable: _MODULE_SINGLE_REMOVEABLE_V2
            })
        );

        singleModuleV3 = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V3,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V3,
                moduleRemoveable: _MODULE_SINGLE_REMOVEABLE_V3
            })
        );

        multiModuleV1 = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V1,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V1,
                moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V1
            })
        );

        multiModuleV2 = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V2,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V2,
                moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V2
            })
        );

        multiModuleV3 = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V3,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V3,
                moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V3
            })
        );

        internalModuleV1 = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V1,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V1,
                moduleRemoveable: _MODULE_INTERNAL_REMOVEABLE_V1
            })
        );

        internalModuleV2 = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V2,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V2,
                moduleRemoveable: _MODULE_INTERNAL_REMOVEABLE_V2
            })
        );

        internalModuleV3 = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V3,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V3,
                moduleRemoveable: _MODULE_INTERNAL_REMOVEABLE_V3
            })
        );
    }

    // =====
    // Tests
    // =====

    function testModuleSettings() external {
        _testModuleConfiguration(
            singleModuleV1,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V1,
            _MODULE_SINGLE_UPGRADEABLE_V1,
            _MODULE_SINGLE_REMOVEABLE_V1
        );

        _testModuleConfiguration(
            singleModuleV2,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V2,
            _MODULE_SINGLE_UPGRADEABLE_V2,
            _MODULE_SINGLE_REMOVEABLE_V2
        );

        _testModuleConfiguration(
            singleModuleV3,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V3,
            _MODULE_SINGLE_UPGRADEABLE_V3,
            _MODULE_SINGLE_REMOVEABLE_V3
        );

        _testModuleConfiguration(
            multiModuleV1,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1,
            _MODULE_MULTI_REMOVEABLE_V1
        );

        _testModuleConfiguration(
            multiModuleV2,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2,
            _MODULE_MULTI_REMOVEABLE_V2
        );

        _testModuleConfiguration(
            multiModuleV3,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3,
            _MODULE_MULTI_REMOVEABLE_V3
        );

        _testModuleConfiguration(
            internalModuleV1,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V1,
            _MODULE_INTERNAL_UPGRADEABLE_V1,
            _MODULE_INTERNAL_REMOVEABLE_V1
        );

        _testModuleConfiguration(
            internalModuleV2,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V2,
            _MODULE_INTERNAL_UPGRADEABLE_V2,
            _MODULE_INTERNAL_REMOVEABLE_V2
        );

        _testModuleConfiguration(
            internalModuleV3,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V3,
            _MODULE_INTERNAL_UPGRADEABLE_V3,
            _MODULE_INTERNAL_REMOVEABLE_V3
        );
    }

    // ===============
    // Ownership tests
    // ===============

    function testTransferOwnership() external {
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
                    moduleType: _MODULE_SINGLE_TYPE,
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
                    moduleType: _MODULE_SINGLE_TYPE,
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
            _MODULE_SINGLE_ID,
            address(singleModuleV1),
            _MODULE_SINGLE_VERSION_V1
        );
        installerProxy.addModules(moduleAddresses);

        address singleModuleV1Implementation = dispatcher
            .moduleIdToImplementation(_MODULE_SINGLE_ID);
        address moduleProxy = dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID);

        assertEq(singleModuleV1Implementation, address(singleModuleV1));
        assertTrue(moduleProxy != address(0));
        assertTrue(
            dispatcher.proxyAddressToTrustRelation(moduleProxy).moduleId ==
                _MODULE_SINGLE_ID
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
            .moduleIdToImplementation(_MODULE_SINGLE_ID);
        address moduleProxy = dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID);

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV2);

        vm.expectEmit(true, true, false, false);
        emit ModuleUpgraded(
            _MODULE_SINGLE_ID,
            address(singleModuleV2),
            _MODULE_SINGLE_VERSION_V1
        );
        installerProxy.upgradeModules(moduleAddresses);

        address singleModuleV2Implementation = dispatcher
            .moduleIdToImplementation(_MODULE_SINGLE_ID);

        assertEq(moduleProxy, dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID));
        assertTrue(
            singleModuleV1Implementation != singleModuleV2Implementation
        );
        assertEq(singleModuleV2Implementation, address(singleModuleV2));
        assertTrue(
            dispatcher.proxyAddressToTrustRelation(moduleProxy).moduleId ==
                _MODULE_SINGLE_ID
        );
        assertTrue(
            dispatcher
                .proxyAddressToTrustRelation(moduleProxy)
                .moduleImplementation == singleModuleV2Implementation
        );
    }

    function testRemoveModulesSingleProxy() external {
        testAddModulesSingleProxy();

        address moduleProxy = dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID);

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV1);

        vm.expectEmit(true, true, false, false);
        emit ModuleRemoved(
            _MODULE_SINGLE_ID,
            address(singleModuleV1),
            _MODULE_SINGLE_VERSION_V1
        );
        installerProxy.removeModules(moduleAddresses);

        assertEq(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID), address(0));
        assertEq(
            dispatcher.moduleIdToImplementation(_MODULE_SINGLE_ID),
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

    function testRevertUpgradeModulesNonUpgradeableSingleProxy() external {
        singleModuleV1 = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V1,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );

        // TODO: add tests
    }

    function testRevertUpgradeModulesNonRemoveableSingleProxy() external {
        testAddModulesSingleProxy();

        // TODO: add tests
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
                    moduleType: _MODULE_MULTI_TYPE,
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
                    moduleType: _MODULE_MULTI_TYPE,
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

    function testUpgradeModulesMultiProxy() external {
        // TODO: add tests
    }

    function testRemoveModulesMultiProxy() external {
        // TODO: add tests
    }

    // =====================
    // Internal module tests
    // =====================

    function testAddModulesInternal() external {
        // TODO: add tests
    }

    function testUpgradeModulesInternal() external {
        // TODO: add tests
    }

    function testRemoveModulesInternal() external {
        // TODO: add tests
    }
}
