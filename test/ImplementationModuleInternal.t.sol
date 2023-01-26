// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TReflexBase} from "../src/interfaces/IReflexBase.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationDeprecatedModule} from "./mocks/MockImplementationDeprecatedModule.sol";
import {MockImplementationModule} from "./mocks/MockImplementationModule.sol";

/**
 * @title Implementation Module Internal Test
 */
contract ImplementationModuleInternalTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION_V1 = 1;
    uint16 internal constant _MODULE_SINGLE_VERSION_V2 = 2;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V2 = false;

    uint32 internal constant _MODULE_INTERNAL_ID = 101;
    uint16 internal constant _MODULE_INTERNAL_TYPE = _MODULE_TYPE_INTERNAL;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V1 = 1;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V2 = 2;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V3 = 3;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V2 = true;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V3 = false;

    // =======
    // Storage
    // =======

    // TODO: add test where singleModule is upgraded

    MockImplementationModule public singleModuleV1;
    MockImplementationModule public singleModuleV2;
    MockImplementationModule public singleModuleProxy;

    MockImplementationModule public internalModuleV1;
    MockImplementationModule public internalModuleV2;
    MockImplementationDeprecatedModule public internalModuleV3;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModuleV1 = new MockImplementationModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V1,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V1
            })
        );

        singleModuleV2 = new MockImplementationModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V2,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V2
            })
        );

        internalModuleV1 = new MockImplementationModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V1,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V1
            })
        );

        internalModuleV2 = new MockImplementationModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V2,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V2
            })
        );

        internalModuleV3 = new MockImplementationDeprecatedModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V3,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V3
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModuleV1);
        moduleAddresses[1] = address(internalModuleV1);
        installerProxy.addModules(moduleAddresses);

        singleModuleProxy = MockImplementationModule(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID));
    }

    // =====
    // Tests
    // =====

    function testUnitModuleIdToImplementation() external {
        assertEq(dispatcher.moduleIdToModuleImplementation(_MODULE_INTERNAL_ID), address(internalModuleV1));
    }

    function testUnitModuleIdToProxy() external {
        assertEq(dispatcher.moduleIdToProxy(_MODULE_INTERNAL_ID), address(0));
    }

    function testUnitModuleSettings() external {
        _testModuleConfiguration(
            singleModuleV1,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V1,
            _MODULE_SINGLE_UPGRADEABLE_V1
        );

        _testModuleConfiguration(
            singleModuleV2,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V2,
            _MODULE_SINGLE_UPGRADEABLE_V2
        );

        _testModuleConfiguration(
            internalModuleV1,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V1,
            _MODULE_INTERNAL_UPGRADEABLE_V1
        );

        _testModuleConfiguration(
            internalModuleV2,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V2,
            _MODULE_INTERNAL_UPGRADEABLE_V2
        );

        _testModuleConfiguration(
            internalModuleV3,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V3,
            _MODULE_INTERNAL_UPGRADEABLE_V3
        );
    }

    function testFuzzCallInternalModule(uint256 number_) external {
        uint256 value = abi.decode(
            singleModuleProxy.callInternalModule(
                _MODULE_INTERNAL_ID,
                abi.encodeWithSignature("getImplementationState1()")
            ),
            (uint256)
        );

        assertEq(value, 0);

        singleModuleProxy.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("setImplementationState1(uint256)", number_)
        );

        value = abi.decode(
            singleModuleProxy.callInternalModule(
                _MODULE_INTERNAL_ID,
                abi.encodeWithSignature("getImplementationState1()")
            ),
            (uint256)
        );

        assertEq(value, number_);
    }

    function testUnitRevertInvalidCallInternalModule() external {
        vm.expectRevert();
        singleModuleProxy.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("getImplementationState777()")
        );
    }

    function testFuzzUpgradeInternalModuleAndDeprecate(
        bytes32 message_,
        uint256 number_,
        address location_,
        address tokenA_,
        address tokenB_,
        bool flag_
    ) public BrutalizeMemory {
        // Verify internal module.

        singleModuleProxy.setStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);

        _testModuleConfiguration(
            singleModuleProxy,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V1,
            _MODULE_SINGLE_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V1,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V1
            })
        );

        singleModuleProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
        installerProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);

        _verifySetStateSlot(number_);

        // Upgrade internal module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(internalModuleV2);
        installerProxy.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V2,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V2
            })
        );

        singleModuleProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
        installerProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);

        _verifySetStateSlot(number_);

        // Upgrade single-proxy module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV2);
        installerProxy.upgradeModules(moduleAddresses);

        _testModuleConfiguration(
            singleModuleProxy,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V2,
            _MODULE_SINGLE_UPGRADEABLE_V2
        );

        // Upgrade to deprecate internal module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(internalModuleV3);
        installerProxy.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V3,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V3
            })
        );

        singleModuleProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
        installerProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);

        // Logic has been deprecated and removed, expect calls to fail.

        _verifySetStateSlotFailure(number_);
    }

    // ================
    // Internal methods
    // ================

    function _verifyModuleConfiguration(IReflexModule.ModuleSettings memory moduleSettings_) internal {
        IReflexModule.ModuleSettings memory moduleSettings = abi.decode(
            singleModuleProxy.callInternalModule(_MODULE_INTERNAL_ID, abi.encodeWithSignature("moduleSettings()")),
            (IReflexModule.ModuleSettings)
        );

        assertEq(moduleSettings.moduleId, moduleSettings_.moduleId);
        assertEq(moduleSettings.moduleType, moduleSettings_.moduleType);
        assertEq(moduleSettings.moduleVersion, moduleSettings_.moduleVersion);
        assertEq(moduleSettings.moduleUpgradeable, moduleSettings_.moduleUpgradeable);
    }

    function _verifyGetStateSlot(uint256 number_) internal {
        uint256 value = abi.decode(
            singleModuleProxy.callInternalModule(
                _MODULE_INTERNAL_ID,
                abi.encodeWithSignature("getImplementationState1()")
            ),
            (uint256)
        );

        assertEq(value, number_);
    }

    function _verifySetStateSlot(uint256 number_) internal {
        singleModuleProxy.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("setImplementationState1(uint256)", 0)
        );

        _verifyGetStateSlot(0);

        singleModuleProxy.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("setImplementationState1(uint256)", number_)
        );

        _verifyGetStateSlot(number_);
    }

    function _verifySetStateSlotFailure(uint256 number_) internal {
        vm.expectRevert(TReflexBase.EmptyError.selector);
        singleModuleProxy.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("setImplementationState1(uint256)", number_)
        );

        vm.expectRevert(TReflexBase.EmptyError.selector);
        singleModuleProxy.callInternalModule(_MODULE_INTERNAL_ID, abi.encodeWithSignature("getImplementationState1()"));
    }
}
