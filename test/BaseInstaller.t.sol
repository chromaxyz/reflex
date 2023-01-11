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
    uint16 internal constant _MODULE_SINGLE_VERSION_V4 = 4;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V2 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V3 = false;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V4 = false;
    bool internal constant _MODULE_SINGLE_REMOVEABLE_V1 = true;
    bool internal constant _MODULE_SINGLE_REMOVEABLE_V2 = true;
    bool internal constant _MODULE_SINGLE_REMOVEABLE_V3 = false;
    bool internal constant _MODULE_SINGLE_REMOVEABLE_V4 = false;

    uint32 internal constant _MODULE_MULTI_ID = 101;
    uint16 internal constant _MODULE_MULTI_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _MODULE_MULTI_VERSION_V1 = 1;
    uint16 internal constant _MODULE_MULTI_VERSION_V2 = 2;
    uint16 internal constant _MODULE_MULTI_VERSION_V3 = 3;
    uint16 internal constant _MODULE_MULTI_VERSION_V4 = 4;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V2 = true;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V3 = false;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V4 = false;
    bool internal constant _MODULE_MULTI_REMOVEABLE_V1 = true;
    bool internal constant _MODULE_MULTI_REMOVEABLE_V2 = true;
    bool internal constant _MODULE_MULTI_REMOVEABLE_V3 = false;
    bool internal constant _MODULE_MULTI_REMOVEABLE_V4 = false;

    uint32 internal constant _MODULE_INTERNAL_ID = 102;
    uint16 internal constant _MODULE_INTERNAL_TYPE = _MODULE_TYPE_INTERNAL;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V1 = 1;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V2 = 2;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V3 = 3;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V4 = 4;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V2 = true;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V3 = false;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V4 = false;
    bool internal constant _MODULE_INTERNAL_REMOVEABLE_V1 = true;
    bool internal constant _MODULE_INTERNAL_REMOVEABLE_V2 = true;
    bool internal constant _MODULE_INTERNAL_REMOVEABLE_V3 = false;
    bool internal constant _MODULE_INTERNAL_REMOVEABLE_V4 = false;

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

        // Scenario:
        // - V1 is the initial module.
        // - V2 is the next version, still upgradeable and removeable.
        // - V3 is the next version, not upgradeable or removeable.
        // - V4 is never used, expected to throw.

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

    function testAddModulesSingleProxy() external {
        _addModule(singleModuleV1);

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
        _addModule(singleModuleV1);

        address singleModuleV1Implementation = dispatcher
            .moduleIdToImplementation(_MODULE_SINGLE_ID);
        address moduleProxy = dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID);

        _upgradeModule(singleModuleV2, false);

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
        _addModule(singleModuleV1);

        address moduleProxy = dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID);

        _removeModule(singleModuleV1, false);

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
        _addModule(singleModuleV1);
        _upgradeModule(singleModuleV2, false);
        _upgradeModule(singleModuleV3, false);

        _upgradeModule(
            new MockBaseModule(
                IBaseModule.ModuleSettings({
                    moduleId: _MODULE_SINGLE_ID,
                    moduleType: _MODULE_SINGLE_TYPE,
                    moduleVersion: _MODULE_SINGLE_VERSION_V4,
                    moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V4,
                    moduleRemoveable: _MODULE_SINGLE_REMOVEABLE_V4
                })
            ),
            true
        );
    }

    function testRevertUpgradeModulesNonRemoveableSingleProxy() external {
        _addModule(singleModuleV1);
        _upgradeModule(singleModuleV2, false);
        _upgradeModule(singleModuleV3, false);

        _removeModule(
            new MockBaseModule(
                IBaseModule.ModuleSettings({
                    moduleId: _MODULE_SINGLE_ID,
                    moduleType: _MODULE_SINGLE_TYPE,
                    moduleVersion: _MODULE_SINGLE_VERSION_V4,
                    moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V4,
                    moduleRemoveable: _MODULE_SINGLE_REMOVEABLE_V4
                })
            ),
            true
        );
    }

    // ========================
    // Multi-proxy module tests
    // ========================

    function testAddModulesMultiProxy() external {
        _addModule(multiModuleV1);
        _upgradeModule(multiModuleV2, false);

        // TODO: add tests
    }

    function testUpgradeModulesMultiProxy() external {
        _addModule(multiModuleV1);
        _upgradeModule(multiModuleV2, false);

        // TODO: add tests
    }

    function testRemoveModulesMultiProxy() external {
        _addModule(multiModuleV1);
        _removeModule(multiModuleV1, false);

        // TODO: add tests
    }

    function testRevertUpgradeModulesNonUpgradeableMultiProxy() external {
        _addModule(multiModuleV1);
        _upgradeModule(multiModuleV2, false);
        _upgradeModule(multiModuleV3, false);

        _upgradeModule(
            new MockBaseModule(
                IBaseModule.ModuleSettings({
                    moduleId: _MODULE_MULTI_ID,
                    moduleType: _MODULE_MULTI_TYPE,
                    moduleVersion: _MODULE_MULTI_VERSION_V4,
                    moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V4,
                    moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V4
                })
            ),
            true
        );
    }

    function testRevertUpgradeModulesNonRemoveableMultiProxy() external {
        _addModule(multiModuleV1);
        _upgradeModule(multiModuleV2, false);
        _upgradeModule(multiModuleV3, false);

        _removeModule(
            new MockBaseModule(
                IBaseModule.ModuleSettings({
                    moduleId: _MODULE_MULTI_ID,
                    moduleType: _MODULE_MULTI_TYPE,
                    moduleVersion: _MODULE_MULTI_VERSION_V4,
                    moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V4,
                    moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V4
                })
            ),
            true
        );
    }

    // =====================
    // Internal module tests
    // =====================

    function testAddModulesInternal() external {
        _addModule(internalModuleV1);

        // TODO: add tests
    }

    function testUpgradeModulesInternal() external {
        _addModule(internalModuleV1);
        _upgradeModule(internalModuleV2, false);

        // TODO: add tests
    }

    function testRemoveModulesInternal() external {
        _addModule(internalModuleV1);
        _removeModule(internalModuleV1, false);

        // TODO: add tests
    }

    function testRevertUpgradeModulesNonUpgradeableInternal() external {
        _addModule(internalModuleV1);
        _upgradeModule(internalModuleV2, false);
        _upgradeModule(internalModuleV3, false);

        _upgradeModule(
            new MockBaseModule(
                IBaseModule.ModuleSettings({
                    moduleId: _MODULE_INTERNAL_ID,
                    moduleType: _MODULE_INTERNAL_TYPE,
                    moduleVersion: _MODULE_INTERNAL_VERSION_V4,
                    moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V4,
                    moduleRemoveable: _MODULE_INTERNAL_REMOVEABLE_V4
                })
            ),
            true
        );
    }

    function testRevertUpgradeModulesNonRemoveableInternal() external {
        _addModule(internalModuleV1);
        _upgradeModule(internalModuleV2, false);
        _upgradeModule(internalModuleV3, false);

        _removeModule(
            new MockBaseModule(
                IBaseModule.ModuleSettings({
                    moduleId: _MODULE_INTERNAL_ID,
                    moduleType: _MODULE_INTERNAL_TYPE,
                    moduleVersion: _MODULE_INTERNAL_VERSION_V4,
                    moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V4,
                    moduleRemoveable: _MODULE_INTERNAL_REMOVEABLE_V4
                })
            ),
            true
        );
    }

    // =========
    // Utilities
    // =========

    function _addModule(IBaseModule module_) internal {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(module_);

        vm.expectEmit(true, true, false, false);
        emit ModuleAdded(
            module_.moduleId(),
            address(module_),
            module_.moduleVersion()
        );
        installerProxy.addModules(moduleAddresses);
    }

    function _upgradeModule(IBaseModule module_, bool throws_) internal {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(module_);

        if (!throws_) {
            vm.expectEmit(true, true, false, false);
            emit ModuleUpgraded(
                module_.moduleId(),
                address(module_),
                module_.moduleVersion()
            );
        } else {
            vm.expectRevert(
                abi.encodeWithSelector(
                    TBaseInstaller.ModuleNotUpgradeable.selector,
                    module_.moduleId()
                )
            );
        }

        installerProxy.upgradeModules(moduleAddresses);
    }

    function _removeModule(IBaseModule module_, bool throws_) internal {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(module_);

        if (!throws_) {
            vm.expectEmit(true, true, false, false);
            emit ModuleRemoved(
                module_.moduleId(),
                address(module_),
                module_.moduleVersion()
            );
        } else {
            vm.expectRevert(
                abi.encodeWithSelector(
                    TBaseInstaller.ModuleNotRemoveable.selector,
                    module_.moduleId()
                )
            );
        }

        installerProxy.removeModules(moduleAddresses);
    }
}
