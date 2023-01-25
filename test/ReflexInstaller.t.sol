// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TReflexInstaller} from "../src/interfaces/IReflexInstaller.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {MockReflexModule} from "./mocks/MockReflexModule.sol";

/**
 * @title Reflex Installer Test
 */
contract ReflexInstallerTest is TReflexInstaller, ReflexFixture {
    // =========
    // Constants
    // =========

    bytes4 internal constant _VALID = 0;

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

    MockReflexModule public singleModuleV1;
    MockReflexModule public singleModuleV2;
    MockReflexModule public singleModuleV3;

    MockReflexModule public multiModuleV1;
    MockReflexModule public multiModuleV2;
    MockReflexModule public multiModuleV3;

    MockReflexModule public internalModuleV1;
    MockReflexModule public internalModuleV2;
    MockReflexModule public internalModuleV3;

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

        singleModuleV1 = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V1,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V1,
                moduleRemoveable: _MODULE_SINGLE_REMOVEABLE_V1
            })
        );

        singleModuleV2 = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V2,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V2,
                moduleRemoveable: _MODULE_SINGLE_REMOVEABLE_V2
            })
        );

        singleModuleV3 = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V3,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V3,
                moduleRemoveable: _MODULE_SINGLE_REMOVEABLE_V3
            })
        );

        multiModuleV1 = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V1,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V1,
                moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V1
            })
        );

        multiModuleV2 = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V2,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V2,
                moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V2
            })
        );

        multiModuleV3 = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V3,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V3,
                moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V3
            })
        );

        internalModuleV1 = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V1,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V1,
                moduleRemoveable: _MODULE_INTERNAL_REMOVEABLE_V1
            })
        );

        internalModuleV2 = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V2,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V2,
                moduleRemoveable: _MODULE_INTERNAL_REMOVEABLE_V2
            })
        );

        internalModuleV3 = new MockReflexModule(
            IReflexModule.ModuleSettings({
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

    function testUnitModuleSettings() external {
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

    function testUnitTransferOwnership() external {
        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferStarted(address(this), _users.Alice);
        installerProxy.transferOwnership(_users.Alice);

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _users.Alice);
    }

    function testUnitAcceptOwnership() external {
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

    function testUnitRevertTransferOwnershipNotPendingOwner() external {
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

    function testUnitRevertTransferOwnershipZeroAddress() external {
        vm.expectRevert(ZeroAddress.selector);
        installerProxy.transferOwnership(address(0));
    }

    // ====================
    // General module tests
    // ====================

    function testUnitRevertAddNonContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(1);

        vm.expectRevert();
        installerProxy.addModules(moduleAddresses);
    }

    function testUnitRevertNonModuleIdContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(dispatcher);

        vm.expectRevert();
        installerProxy.addModules(moduleAddresses);
    }

    function testUnitRevertUpgradeModulesModuleNonexistent() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(
            new MockReflexModule(
                IReflexModule.ModuleSettings({
                    moduleId: 777,
                    moduleType: _MODULE_SINGLE_TYPE,
                    moduleVersion: 777,
                    moduleUpgradeable: true,
                    moduleRemoveable: true
                })
            )
        );

        vm.expectRevert(abi.encodeWithSelector(ModuleNonexistent.selector, 777));
        installerProxy.upgradeModules(moduleAddresses);
    }

    function testUnitRevertUpgradeModulesNonContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(1);

        vm.expectRevert();
        installerProxy.upgradeModules(moduleAddresses);
    }

    function testUnitRevertUpgradeModulesNonModuleIdContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(dispatcher);

        vm.expectRevert();
        installerProxy.upgradeModules(moduleAddresses);
    }

    function testUnitRevertRemoveModulesModuleNonexistent() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(
            new MockReflexModule(
                IReflexModule.ModuleSettings({
                    moduleId: 777,
                    moduleType: _MODULE_SINGLE_TYPE,
                    moduleVersion: 777,
                    moduleUpgradeable: true,
                    moduleRemoveable: true
                })
            )
        );

        vm.expectRevert(abi.encodeWithSelector(ModuleNonexistent.selector, 777));
        installerProxy.removeModules(moduleAddresses);
    }

    function testUnitRevertRemoveModulesNonContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(1);

        vm.expectRevert();
        installerProxy.removeModules(moduleAddresses);
    }

    function testUnitRevertRemoveModulesNonModuleIdContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(dispatcher);

        vm.expectRevert();
        installerProxy.removeModules(moduleAddresses);
    }

    // =========================
    // Single-proxy module tests
    // =========================

    function testUnitAddModulesSingleProxy() public {
        _addModule(singleModuleV1, _VALID);

        address singleModuleImplementationV1 = dispatcher.moduleIdToModuleImplementation(_MODULE_SINGLE_ID);
        address singleModuleProxyV1 = dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID);

        assertEq(singleModuleImplementationV1, address(singleModuleV1));
        assertTrue(singleModuleProxyV1 != address(0));
    }

    function testUnitRevertAddModulesExistentSingleProxy() external {
        _addModule(singleModuleV1, _VALID);

        _addModule(singleModuleV1, TReflexInstaller.ModuleExistent.selector);
    }

    function testUnitUpgradeModulesSingleProxy() external {
        testUnitAddModulesSingleProxy();

        address singleModuleImplementationV1 = dispatcher.moduleIdToModuleImplementation(_MODULE_SINGLE_ID);
        address singleModuleProxyV1 = dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID);

        _upgradeModule(singleModuleV2, _VALID);

        address singleModuleImplementationV2 = dispatcher.moduleIdToModuleImplementation(_MODULE_SINGLE_ID);
        address singleModuleProxyV2 = dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID);

        assertEq(singleModuleProxyV1, singleModuleProxyV2);
        assertTrue(singleModuleImplementationV1 != singleModuleImplementationV2);
        assertEq(singleModuleImplementationV2, address(singleModuleV2));
    }

    function testUnitRemoveModulesSingleProxy() external {
        testUnitAddModulesSingleProxy();

        _removeModule(singleModuleV1, _VALID);

        assertEq(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID), address(0));
        assertEq(dispatcher.moduleIdToModuleImplementation(_MODULE_SINGLE_ID), address(0));

        testUnitAddModulesSingleProxy();
    }

    function testUnitRevertUpgradeInvalidVersionSingleProxy() external {
        _addModule(singleModuleV1, _VALID);
        _upgradeModule(singleModuleV2, _VALID);

        _upgradeModule(singleModuleV1, TReflexInstaller.ModuleInvalidVersion.selector);
    }

    function testUnitRevertUpgradeModulesNonUpgradeableSingleProxy() external {
        _addModule(singleModuleV1, _VALID);
        _upgradeModule(singleModuleV2, _VALID);
        _upgradeModule(singleModuleV3, _VALID);

        _upgradeModule(
            new MockReflexModule(
                IReflexModule.ModuleSettings({
                    moduleId: _MODULE_SINGLE_ID,
                    moduleType: _MODULE_SINGLE_TYPE,
                    moduleVersion: _MODULE_SINGLE_VERSION_V4,
                    moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V4,
                    moduleRemoveable: _MODULE_SINGLE_REMOVEABLE_V4
                })
            ),
            TReflexInstaller.ModuleNotUpgradeable.selector
        );
    }

    function testUnitRevertUpgradeModulesNonRemoveableSingleProxy() external {
        _addModule(singleModuleV1, _VALID);
        _upgradeModule(singleModuleV2, _VALID);
        _upgradeModule(singleModuleV3, _VALID);

        _removeModule(
            new MockReflexModule(
                IReflexModule.ModuleSettings({
                    moduleId: _MODULE_SINGLE_ID,
                    moduleType: _MODULE_SINGLE_TYPE,
                    moduleVersion: _MODULE_SINGLE_VERSION_V4,
                    moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V4,
                    moduleRemoveable: _MODULE_SINGLE_REMOVEABLE_V4
                })
            ),
            TReflexInstaller.ModuleNotRemoveable.selector
        );
    }

    // ========================
    // Multi-proxy module tests
    // ========================

    function testUnitAddModulesMultiProxy() public {
        _addModule(multiModuleV1, _VALID);

        address multiModuleImplementationV1 = dispatcher.moduleIdToModuleImplementation(_MODULE_MULTI_ID);
        address multiModuleProxyV1 = dispatcher.moduleIdToProxy(_MODULE_MULTI_ID);

        assertEq(multiModuleImplementationV1, address(multiModuleV1));
        assertEq(multiModuleProxyV1, address(0));
    }

    function testUnitRevertAddModulesExistentMultiProxy() external {
        _addModule(multiModuleV1, _VALID);

        _addModule(multiModuleV1, TReflexInstaller.ModuleExistent.selector);
    }

    function testUnitUpgradeModulesMultiProxy() external {
        testUnitAddModulesMultiProxy();

        address multiModuleImplementationV1 = dispatcher.moduleIdToModuleImplementation(_MODULE_MULTI_ID);

        _upgradeModule(multiModuleV2, _VALID);

        address multiModuleImplementationV2 = dispatcher.moduleIdToModuleImplementation(_MODULE_MULTI_ID);
        address multiModuleProxyV2 = dispatcher.moduleIdToProxy(_MODULE_MULTI_ID);

        assertTrue(multiModuleImplementationV1 != multiModuleImplementationV2);
        assertEq(multiModuleProxyV2, address(0));
        assertEq(multiModuleImplementationV2, address(multiModuleV2));
    }

    function testUnitRemoveModulesMultiProxy() external {
        testUnitAddModulesMultiProxy();

        _removeModule(multiModuleV1, _VALID);

        assertEq(dispatcher.moduleIdToProxy(_MODULE_MULTI_ID), address(0));
        assertEq(dispatcher.moduleIdToModuleImplementation(_MODULE_MULTI_ID), address(0));

        testUnitAddModulesMultiProxy();
    }

    function testUnitRevertUpgradeInvalidVersionMultiProxy() external {
        _addModule(multiModuleV1, _VALID);
        _upgradeModule(multiModuleV2, _VALID);

        _upgradeModule(multiModuleV1, TReflexInstaller.ModuleInvalidVersion.selector);
    }

    function testUnitRevertUpgradeModulesNonUpgradeableMultiProxy() external {
        _addModule(multiModuleV1, _VALID);
        _upgradeModule(multiModuleV2, _VALID);
        _upgradeModule(multiModuleV3, _VALID);

        _upgradeModule(
            new MockReflexModule(
                IReflexModule.ModuleSettings({
                    moduleId: _MODULE_MULTI_ID,
                    moduleType: _MODULE_MULTI_TYPE,
                    moduleVersion: _MODULE_MULTI_VERSION_V4,
                    moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V4,
                    moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V4
                })
            ),
            TReflexInstaller.ModuleNotUpgradeable.selector
        );
    }

    function testUnitRevertUpgradeModulesNonRemoveableMultiProxy() external {
        _addModule(multiModuleV1, _VALID);
        _upgradeModule(multiModuleV2, _VALID);
        _upgradeModule(multiModuleV3, _VALID);

        _removeModule(
            new MockReflexModule(
                IReflexModule.ModuleSettings({
                    moduleId: _MODULE_MULTI_ID,
                    moduleType: _MODULE_MULTI_TYPE,
                    moduleVersion: _MODULE_MULTI_VERSION_V4,
                    moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V4,
                    moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V4
                })
            ),
            TReflexInstaller.ModuleNotRemoveable.selector
        );
    }

    function testUnitAddModulesInternal() public {
        _addModule(internalModuleV1, _VALID);

        address internalModuleImplementationV1 = dispatcher.moduleIdToModuleImplementation(_MODULE_INTERNAL_ID);
        address internalModuleProxyV1 = dispatcher.moduleIdToProxy(_MODULE_INTERNAL_ID);

        assertEq(internalModuleImplementationV1, address(internalModuleV1));
        assertEq(internalModuleProxyV1, address(0));
    }

    function testUnitRevertAddModulesExistentInternal() external {
        _addModule(internalModuleV1, _VALID);

        _addModule(internalModuleV1, TReflexInstaller.ModuleExistent.selector);
    }

    function testUnitUpgradeModulesInternal() external {
        testUnitAddModulesInternal();

        address internalModuleImplementationV1 = dispatcher.moduleIdToModuleImplementation(_MODULE_INTERNAL_ID);

        _upgradeModule(internalModuleV2, _VALID);

        address internalModuleImplementationV2 = dispatcher.moduleIdToModuleImplementation(_MODULE_INTERNAL_ID);
        address internalModuleProxyV2 = dispatcher.moduleIdToProxy(_MODULE_INTERNAL_ID);

        assertTrue(internalModuleImplementationV1 != internalModuleImplementationV2);
        assertEq(internalModuleProxyV2, address(0));
        assertEq(internalModuleImplementationV2, address(internalModuleV2));
    }

    function testUnitRemoveModulesInternal() external {
        testUnitAddModulesInternal();

        _removeModule(internalModuleV1, _VALID);

        assertEq(dispatcher.moduleIdToProxy(_MODULE_INTERNAL_ID), address(0));
        assertEq(dispatcher.moduleIdToModuleImplementation(_MODULE_INTERNAL_ID), address(0));

        testUnitAddModulesInternal();
    }

    function testUnitRevertUpgradeInvalidVersionInternal() external {
        _addModule(internalModuleV1, _VALID);
        _upgradeModule(internalModuleV2, _VALID);

        _upgradeModule(internalModuleV1, TReflexInstaller.ModuleInvalidVersion.selector);
    }

    function testUnitRevertUpgradeModulesNonUpgradeableInternal() external {
        _addModule(internalModuleV1, _VALID);
        _upgradeModule(internalModuleV2, _VALID);
        _upgradeModule(internalModuleV3, _VALID);

        _upgradeModule(
            new MockReflexModule(
                IReflexModule.ModuleSettings({
                    moduleId: _MODULE_INTERNAL_ID,
                    moduleType: _MODULE_INTERNAL_TYPE,
                    moduleVersion: _MODULE_INTERNAL_VERSION_V4,
                    moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V4,
                    moduleRemoveable: _MODULE_INTERNAL_REMOVEABLE_V4
                })
            ),
            TReflexInstaller.ModuleNotUpgradeable.selector
        );
    }

    function testUnitRevertUpgradeModulesNonRemoveableInternal() external {
        _addModule(internalModuleV1, _VALID);
        _upgradeModule(internalModuleV2, _VALID);
        _upgradeModule(internalModuleV3, _VALID);

        _removeModule(
            new MockReflexModule(
                IReflexModule.ModuleSettings({
                    moduleId: _MODULE_INTERNAL_ID,
                    moduleType: _MODULE_INTERNAL_TYPE,
                    moduleVersion: _MODULE_INTERNAL_VERSION_V4,
                    moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V4,
                    moduleRemoveable: _MODULE_INTERNAL_REMOVEABLE_V4
                })
            ),
            TReflexInstaller.ModuleNotRemoveable.selector
        );
    }

    // ================
    // Internal methods
    // ================

    function _addModule(IReflexModule module_, bytes4 selector_) internal {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(module_);

        if (selector_ == _VALID) {
            vm.expectEmit(true, true, false, false);
            emit ModuleAdded(module_.moduleId(), address(module_), module_.moduleVersion());
        } else {
            vm.expectRevert(abi.encodeWithSelector(selector_, module_.moduleId()));
        }

        installerProxy.addModules(moduleAddresses);
    }

    function _upgradeModule(IReflexModule module_, bytes4 selector_) internal {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(module_);

        if (selector_ == _VALID) {
            vm.expectEmit(true, true, false, false);
            emit ModuleUpgraded(module_.moduleId(), address(module_), module_.moduleVersion());
        } else {
            vm.expectRevert(abi.encodeWithSelector(selector_, module_.moduleId()));
        }

        installerProxy.upgradeModules(moduleAddresses);
    }

    function _removeModule(IReflexModule module_, bytes4 selector_) internal {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(module_);

        if (selector_ == _VALID) {
            vm.expectEmit(true, true, false, false);
            emit ModuleRemoved(module_.moduleId(), address(module_), module_.moduleVersion());
        } else {
            vm.expectRevert(abi.encodeWithSelector(TReflexInstaller.ModuleNotRemoveable.selector, module_.moduleId()));
        }

        installerProxy.removeModules(moduleAddresses);
    }
}
