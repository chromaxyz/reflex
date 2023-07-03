// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexInstaller} from "../src/interfaces/IReflexInstaller.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {MockReflexModule} from "./mocks/MockReflexModule.sol";

/**
 * @title Reflex Installer Test
 */
contract ReflexInstallerTest is ReflexFixture {
    // ======
    // Events
    // ======

    event ModuleAdded(uint32 indexed moduleId, address indexed moduleImplementation);

    event ModuleUpgraded(uint32 indexed moduleId, address indexed moduleImplementation);

    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // =========
    // Constants
    // =========

    bytes4 internal constant _VALID = 0;

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_ENDPOINT;

    uint32 internal constant _MODULE_MULTI_ID = 101;
    uint16 internal constant _MODULE_MULTI_TYPE = _MODULE_TYPE_MULTI_ENDPOINT;

    uint32 internal constant _MODULE_INTERNAL_ID = 102;
    uint16 internal constant _MODULE_INTERNAL_TYPE = _MODULE_TYPE_INTERNAL;

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

        singleModuleV1 = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_SINGLE_ID, moduleType: _MODULE_SINGLE_TYPE})
        );

        singleModuleV2 = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_SINGLE_ID, moduleType: _MODULE_SINGLE_TYPE})
        );

        singleModuleV3 = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_SINGLE_ID, moduleType: _MODULE_SINGLE_TYPE})
        );

        multiModuleV1 = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_MULTI_ID, moduleType: _MODULE_MULTI_TYPE})
        );

        multiModuleV2 = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_MULTI_ID, moduleType: _MODULE_MULTI_TYPE})
        );

        multiModuleV3 = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_MULTI_ID, moduleType: _MODULE_MULTI_TYPE})
        );

        internalModuleV1 = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_INTERNAL_TYPE})
        );

        internalModuleV2 = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_INTERNAL_TYPE})
        );

        internalModuleV3 = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_INTERNAL_TYPE})
        );
    }

    // =====
    // Tests
    // =====

    function testUnitModuleSettings() external {
        _verifyModuleConfiguration(singleModuleV1, _MODULE_SINGLE_ID, _MODULE_SINGLE_TYPE);
        _verifyModuleConfiguration(singleModuleV2, _MODULE_SINGLE_ID, _MODULE_SINGLE_TYPE);
        _verifyModuleConfiguration(singleModuleV3, _MODULE_SINGLE_ID, _MODULE_SINGLE_TYPE);

        _verifyModuleConfiguration(multiModuleV1, _MODULE_MULTI_ID, _MODULE_MULTI_TYPE);
        _verifyModuleConfiguration(multiModuleV2, _MODULE_MULTI_ID, _MODULE_MULTI_TYPE);
        _verifyModuleConfiguration(multiModuleV3, _MODULE_MULTI_ID, _MODULE_MULTI_TYPE);

        _verifyModuleConfiguration(internalModuleV1, _MODULE_INTERNAL_ID, _MODULE_INTERNAL_TYPE);
        _verifyModuleConfiguration(internalModuleV2, _MODULE_INTERNAL_ID, _MODULE_INTERNAL_TYPE);
        _verifyModuleConfiguration(internalModuleV3, _MODULE_INTERNAL_ID, _MODULE_INTERNAL_TYPE);
    }

    // ===============
    // Ownership tests
    // ===============

    function testFuzzTransferOwnership(address user_) external {
        vm.assume(user_ != address(0));

        assertEq(installerEndpoint.owner(), address(this));
        assertEq(installerEndpoint.pendingOwner(), address(0));

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferStarted(address(this), _brutalize(user_));
        installerEndpoint.transferOwnership(_brutalize(user_));

        assertEq(installerEndpoint.owner(), address(this));
        assertEq(installerEndpoint.pendingOwner(), _brutalize(user_));
    }

    function testFuzzRevertTransferOwnershipNotOwner(address user_) external {
        vm.assume(user_ != address(0) && user_ != installerEndpoint.owner() && user_ != address(dispatcher));
        assumeNoPrecompiles(user_);

        vm.startPrank(user_);

        vm.expectRevert(IReflexModule.Unauthorized.selector);
        installerEndpoint.transferOwnership(_users.Alice);

        vm.stopPrank();
    }

    function testFuzzAcceptOwnership(address user_) external {
        vm.assume(user_ != address(0) && user_ != address(dispatcher));
        assumeNoPrecompiles(user_);

        assertEq(installerEndpoint.owner(), address(this));
        assertEq(installerEndpoint.pendingOwner(), address(0));

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferStarted(address(this), _brutalize(user_));
        installerEndpoint.transferOwnership(user_);

        assertEq(installerEndpoint.owner(), address(this));
        assertEq(installerEndpoint.pendingOwner(), _brutalize(user_));

        vm.startPrank(user_);

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferred(address(this), _brutalize(user_));
        installerEndpoint.acceptOwnership();

        vm.stopPrank();

        assertEq(installerEndpoint.owner(), user_);
        assertEq(installerEndpoint.pendingOwner(), address(0));
    }

    function testFuzzRevertTransferOwnershipNotPendingOwner(address user_, address target_) external {
        vm.assume(user_ != address(0) && target_ != address(0) && user_ != target_ && user_ != address(dispatcher));
        assumeNoPrecompiles(user_);
        assumeNoPrecompiles(target_);

        assertEq(installerEndpoint.owner(), address(this));
        assertEq(installerEndpoint.pendingOwner(), address(0));

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferStarted(address(this), _brutalize(target_));
        installerEndpoint.transferOwnership(_brutalize(target_));

        assertEq(installerEndpoint.owner(), address(this));
        assertEq(installerEndpoint.pendingOwner(), _brutalize(target_));

        vm.startPrank(user_);

        vm.expectRevert(IReflexModule.Unauthorized.selector);
        installerEndpoint.acceptOwnership();

        vm.stopPrank();

        assertEq(installerEndpoint.owner(), address(this));
        assertEq(installerEndpoint.pendingOwner(), _brutalize(target_));
    }

    function testUnitRenounceOwnership() external {
        assertEq(installerEndpoint.owner(), address(this));
        assertEq(installerEndpoint.pendingOwner(), address(0));

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferred(address(this), address(0));
        installerEndpoint.renounceOwnership();

        assertEq(installerEndpoint.owner(), address(0));
        assertEq(installerEndpoint.pendingOwner(), address(0));
    }

    function testFuzzRenounceOwnershipWithPendingOwner(address user_) external {
        vm.assume(user_ != address(0));
        assumeNoPrecompiles(user_);

        assertEq(installerEndpoint.owner(), address(this));
        assertEq(installerEndpoint.pendingOwner(), address(0));

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferStarted(address(this), _brutalize(user_));
        installerEndpoint.transferOwnership(_brutalize(user_));

        assertEq(installerEndpoint.owner(), address(this));
        assertEq(installerEndpoint.pendingOwner(), _brutalize(user_));

        vm.expectEmit(true, false, false, false);
        emit OwnershipTransferred(address(this), address(0));
        installerEndpoint.renounceOwnership();

        assertEq(installerEndpoint.owner(), address(0));
        assertEq(installerEndpoint.pendingOwner(), address(0));
    }

    function testFuzzRevertRenounceOwnershipNotOwner(address user_) external {
        vm.assume(user_ != address(0) && user_ != installerEndpoint.owner() && user_ != address(dispatcher));
        assumeNoPrecompiles(user_);

        vm.startPrank(user_);

        vm.expectRevert(IReflexModule.Unauthorized.selector);
        installerEndpoint.renounceOwnership();

        vm.stopPrank();
    }

    function testUnitRevertTransferOwnershipZeroAddress() external {
        vm.expectRevert(IReflexModule.ZeroAddress.selector);
        installerEndpoint.transferOwnership(address(0));
    }

    // ============
    // Module tests
    // ============

    function testUnitRevertAddNonContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(1);

        vm.expectRevert();
        installerEndpoint.addModules(moduleAddresses);
    }

    function testUnitRevertNonModuleIdContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(dispatcher);

        vm.expectRevert();
        installerEndpoint.addModules(moduleAddresses);
    }

    function testUnitRevertUpgradeModulesModuleNonexistent() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(
            new MockReflexModule(IReflexModule.ModuleSettings({moduleId: 777, moduleType: _MODULE_SINGLE_TYPE}))
        );

        vm.expectRevert(abi.encodeWithSelector(IReflexInstaller.ModuleNonexistent.selector, 777));
        installerEndpoint.upgradeModules(moduleAddresses);
    }

    function testUnitRevertUpgradeModulesNonContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(1);

        vm.expectRevert();
        installerEndpoint.upgradeModules(moduleAddresses);
    }

    function testUnitRevertUpgradeModulesNonModuleIdContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(dispatcher);

        vm.expectRevert();
        installerEndpoint.upgradeModules(moduleAddresses);
    }

    // ============================
    // Single-endpoint module tests
    // ============================

    function testUnitAddModulesSingleEndpoint() public withHooksExpected(1, 1) {
        _addModule(singleModuleV1, _VALID);

        address singleModuleImplementationV1 = dispatcher.getModuleImplementation(_MODULE_SINGLE_ID);
        address singleModuleEndpointV1 = dispatcher.getEndpoint(_MODULE_SINGLE_ID);

        assertEq(singleModuleImplementationV1, address(singleModuleV1));
        assertTrue(singleModuleEndpointV1 != address(0));
    }

    function testUnitRevertAddModulesExistentSingleEndpoint() external withHooksExpected(1, 1) {
        _addModule(singleModuleV1, _VALID);

        _addModule(singleModuleV1, IReflexInstaller.ModuleExistent.selector);
    }

    function testUnitUpgradeModulesSingleEndpoint() external withHooksExpected(2, 1) {
        _addModule(singleModuleV1, _VALID);

        address singleModuleImplementationV1 = dispatcher.getModuleImplementation(_MODULE_SINGLE_ID);
        address singleModuleEndpointV1 = dispatcher.getEndpoint(_MODULE_SINGLE_ID);

        _upgradeModule(singleModuleV2, _VALID);

        address singleModuleImplementationV2 = dispatcher.getModuleImplementation(_MODULE_SINGLE_ID);
        address singleModuleEndpointV2 = dispatcher.getEndpoint(_MODULE_SINGLE_ID);

        assertEq(singleModuleEndpointV1, singleModuleEndpointV2);
        assertTrue(singleModuleImplementationV1 != singleModuleImplementationV2);
        assertEq(singleModuleImplementationV2, address(singleModuleV2));
    }

    function testUnitRevertUpgradeInvalidTypeSingleEndpoint() external withHooksExpected(2, 1) {
        _addModule(singleModuleV1, _VALID);
        _upgradeModule(singleModuleV2, _VALID);

        MockReflexModule singleModuleTypeInvalid = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_SINGLE_ID, moduleType: _MODULE_MULTI_TYPE})
        );

        _upgradeModule(singleModuleTypeInvalid, IReflexModule.ModuleTypeInvalid.selector);
    }

    // ===========================
    // Multi-endpoint module tests
    // ===========================

    function testUnitAddModulesMultiEndpoint() external withHooksExpected(1, 0) {
        _addModule(multiModuleV1, _VALID);

        address multiModuleImplementationV1 = dispatcher.getModuleImplementation(_MODULE_MULTI_ID);
        address multiModuleEndpointV1 = dispatcher.getEndpoint(_MODULE_MULTI_ID);

        assertEq(multiModuleImplementationV1, address(multiModuleV1));
        assertEq(multiModuleEndpointV1, address(0));
    }

    function testUnitRevertAddModulesExistentMultiEndpoint() external withHooksExpected(1, 0) {
        _addModule(multiModuleV1, _VALID);

        _addModule(multiModuleV1, IReflexInstaller.ModuleExistent.selector);
    }

    function testUnitUpgradeModulesMultiEndpoint() external withHooksExpected(2, 0) {
        _addModule(multiModuleV1, _VALID);

        address multiModuleImplementationV1 = dispatcher.getModuleImplementation(_MODULE_MULTI_ID);

        _upgradeModule(multiModuleV2, _VALID);

        address multiModuleImplementationV2 = dispatcher.getModuleImplementation(_MODULE_MULTI_ID);
        address multiModuleEndpointV2 = dispatcher.getEndpoint(_MODULE_MULTI_ID);

        assertTrue(multiModuleImplementationV1 != multiModuleImplementationV2);
        assertEq(multiModuleEndpointV2, address(0));
        assertEq(multiModuleImplementationV2, address(multiModuleV2));
    }

    function testUnitRevertUpgradeInvalidTypeMultiEndpoint() external withHooksExpected(2, 0) {
        _addModule(multiModuleV1, _VALID);
        _upgradeModule(multiModuleV2, _VALID);

        MockReflexModule multiModuleTypeInvalid = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_MULTI_ID, moduleType: _MODULE_INTERNAL_TYPE})
        );

        _upgradeModule(multiModuleTypeInvalid, IReflexModule.ModuleTypeInvalid.selector);
    }

    // =====================
    // Internal module tests
    // =====================

    function testUnitAddModulesInternal() external withHooksExpected(1, 0) {
        _addModule(internalModuleV1, _VALID);

        address internalModuleImplementationV1 = dispatcher.getModuleImplementation(_MODULE_INTERNAL_ID);
        address internalModuleEndpointV1 = dispatcher.getEndpoint(_MODULE_INTERNAL_ID);

        assertEq(internalModuleImplementationV1, address(internalModuleV1));
        assertEq(internalModuleEndpointV1, address(0));
    }

    function testUnitRevertAddModulesExistentInternal() external withHooksExpected(1, 0) {
        _addModule(internalModuleV1, _VALID);

        _addModule(internalModuleV1, IReflexInstaller.ModuleExistent.selector);
    }

    function testUnitUpgradeModulesInternal() external withHooksExpected(2, 0) {
        _addModule(internalModuleV1, _VALID);

        address internalModuleImplementationV1 = dispatcher.getModuleImplementation(_MODULE_INTERNAL_ID);

        _upgradeModule(internalModuleV2, _VALID);

        address internalModuleImplementationV2 = dispatcher.getModuleImplementation(_MODULE_INTERNAL_ID);
        address internalModuleEndpointV2 = dispatcher.getEndpoint(_MODULE_INTERNAL_ID);

        assertTrue(internalModuleImplementationV1 != internalModuleImplementationV2);
        assertEq(internalModuleEndpointV2, address(0));
        assertEq(internalModuleImplementationV2, address(internalModuleV2));
    }

    function testUnitRevertUpgradeInvalidTypeInternal() external withHooksExpected(2, 0) {
        _addModule(internalModuleV1, _VALID);
        _upgradeModule(internalModuleV2, _VALID);

        MockReflexModule internalModuleTypeInvalid = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_SINGLE_TYPE})
        );

        _upgradeModule(internalModuleTypeInvalid, IReflexModule.ModuleTypeInvalid.selector);
    }

    // ===============
    // Installer tests
    // ===============

    function testUnitUpgradeInstaller() external withHooksExpected(7, 1) {
        // Installer upgrade

        assertEq(dispatcher.getModuleImplementation(_MODULE_ID_INSTALLER), address(installerModuleV1));
        assertTrue(dispatcher.getEndpoint(_MODULE_ID_INSTALLER) == address(installerEndpoint));

        _upgradeModule(installerModuleV2, _VALID);

        assertEq(dispatcher.getModuleImplementation(_MODULE_ID_INSTALLER), address(installerModuleV2));
        assertTrue(dispatcher.getEndpoint(_MODULE_ID_INSTALLER) == address(installerEndpoint));

        // Single endpoint upgrade

        _addModule(singleModuleV1, _VALID);

        address singleModuleImplementationV1 = dispatcher.getModuleImplementation(_MODULE_SINGLE_ID);
        address singleModuleEndpointV1 = dispatcher.getEndpoint(_MODULE_SINGLE_ID);

        _upgradeModule(singleModuleV2, _VALID);

        address singleModuleImplementationV2 = dispatcher.getModuleImplementation(_MODULE_SINGLE_ID);
        address singleModuleEndpointV2 = dispatcher.getEndpoint(_MODULE_SINGLE_ID);

        assertEq(singleModuleEndpointV1, singleModuleEndpointV2);
        assertTrue(singleModuleImplementationV1 != singleModuleImplementationV2);
        assertEq(singleModuleImplementationV2, address(singleModuleV2));

        // Multi endpoint upgrade

        _addModule(multiModuleV1, _VALID);

        address multiModuleImplementationV1 = dispatcher.getModuleImplementation(_MODULE_MULTI_ID);

        _upgradeModule(multiModuleV2, _VALID);

        address multiModuleImplementationV2 = dispatcher.getModuleImplementation(_MODULE_MULTI_ID);
        address multiModuleEndpointV2 = dispatcher.getEndpoint(_MODULE_MULTI_ID);

        assertTrue(multiModuleImplementationV1 != multiModuleImplementationV2);
        assertEq(multiModuleEndpointV2, address(0));
        assertEq(multiModuleImplementationV2, address(multiModuleV2));

        // Internal module upgrade

        _addModule(internalModuleV1, _VALID);

        address internalModuleImplementationV1 = dispatcher.getModuleImplementation(_MODULE_INTERNAL_ID);

        _upgradeModule(internalModuleV2, _VALID);

        address internalModuleImplementationV2 = dispatcher.getModuleImplementation(_MODULE_INTERNAL_ID);
        address internalModuleEndpointV2 = dispatcher.getEndpoint(_MODULE_INTERNAL_ID);

        assertTrue(internalModuleImplementationV1 != internalModuleImplementationV2);
        assertEq(internalModuleEndpointV2, address(0));
        assertEq(internalModuleImplementationV2, address(internalModuleV2));
    }

    // =========
    // Utilities
    // =========

    modifier withHooksExpected(uint256 beforeModuleRegistrationCount_, uint256 getEndpointCreationCodeCount_) {
        assertEq(installerEndpoint.beforeModuleRegistrationCounter(), 0);
        assertEq(installerEndpoint.getEndpointCreationCodeCounter(), 0);

        _;

        assertEq(installerEndpoint.beforeModuleRegistrationCounter(), beforeModuleRegistrationCount_);
        assertEq(installerEndpoint.getEndpointCreationCodeCounter(), getEndpointCreationCodeCount_);
    }

    function _addModule(IReflexModule module_, bytes4 selector_) internal {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(module_);

        if (selector_ == _VALID) {
            vm.expectEmit(true, true, false, false);
            emit ModuleAdded(module_.moduleId(), address(module_));
        } else if (selector_ == IReflexModule.ModuleTypeInvalid.selector) {
            vm.expectRevert(abi.encodeWithSelector(selector_, module_.moduleType()));
        } else {
            vm.expectRevert(abi.encodeWithSelector(selector_, module_.moduleId()));
        }

        installerEndpoint.addModules(moduleAddresses);
    }

    function _upgradeModule(IReflexModule module_, bytes4 selector_) internal {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(module_);

        if (selector_ == _VALID) {
            vm.expectEmit(true, true, false, false);
            emit ModuleUpgraded(module_.moduleId(), address(module_));
        } else if (selector_ == IReflexModule.ModuleTypeInvalid.selector) {
            vm.expectRevert(abi.encodeWithSelector(selector_, module_.moduleType()));
        } else {
            vm.expectRevert(abi.encodeWithSelector(selector_, module_.moduleId()));
        }

        installerEndpoint.upgradeModules(moduleAddresses);
    }
}
