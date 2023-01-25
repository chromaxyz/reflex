// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationModule} from "./mocks/MockImplementationModule.sol";
import {MockImplementationInternalModule} from "./mocks/MockImplementationInternalModule.sol";

/**
 * @title Implementation Module Internal Test
 */
contract ImplementationModuleInternalTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION = 1;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE = true;
    bool internal constant _MODULE_SINGLE_REMOVEABLE = true;

    uint32 internal constant _MODULE_INTERNAL_ID = 101;
    uint16 internal constant _MODULE_INTERNAL_TYPE = _MODULE_TYPE_INTERNAL;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V1 = 1;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V2 = 2;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V2 = false;
    bool internal constant _MODULE_INTERNAL_REMOVEABLE_V1 = true;
    bool internal constant _MODULE_INTERNAL_REMOVEABLE_V2 = false;

    // =======
    // Storage
    // =======

    MockImplementationModule public singleModule;
    MockImplementationModule public singleModuleProxy;

    MockImplementationInternalModule public internalModuleV1;
    MockImplementationInternalModule public internalModuleV2;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModule = new MockImplementationModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE,
                moduleRemoveable: _MODULE_SINGLE_REMOVEABLE
            })
        );

        internalModuleV1 = new MockImplementationInternalModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V1,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V1,
                moduleRemoveable: _MODULE_INTERNAL_REMOVEABLE_V1
            })
        );

        internalModuleV2 = new MockImplementationInternalModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V2,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V2,
                moduleRemoveable: _MODULE_INTERNAL_REMOVEABLE_V2
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModule);
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
            singleModule,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION,
            _MODULE_SINGLE_UPGRADEABLE,
            _MODULE_SINGLE_REMOVEABLE
        );

        _testModuleConfiguration(
            internalModuleV1,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V1,
            _MODULE_INTERNAL_UPGRADEABLE_V1,
            _MODULE_INTERNAL_REMOVEABLE_V1
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

    function testFuzzUpgradeInternalModule(
        bytes32 message_,
        uint256 number_,
        address location_,
        address tokenA_,
        address tokenB_,
        bool flag_
    ) external BrutalizeMemory {
        singleModuleProxy.setStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);

        singleModuleProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
        installerProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);

        _testModuleConfiguration(
            internalModuleV1,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V1,
            _MODULE_INTERNAL_UPGRADEABLE_V1,
            _MODULE_INTERNAL_REMOVEABLE_V1
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(internalModuleV2);
        installerProxy.upgradeModules(moduleAddresses);

        _testModuleConfiguration(
            internalModuleV2,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V2,
            _MODULE_INTERNAL_UPGRADEABLE_V2,
            _MODULE_INTERNAL_REMOVEABLE_V2
        );

        singleModuleProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
        installerProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
    }

    function testFuzzRemoveInternalModule(
        bytes32 message_,
        uint256 number_,
        address location_,
        address tokenA_,
        address tokenB_,
        bool flag_
    ) external BrutalizeMemory {
        singleModuleProxy.setStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);

        singleModuleProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
        installerProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(internalModuleV1);
        installerProxy.removeModules(moduleAddresses);

        internalModuleV1 = MockImplementationInternalModule(
            dispatcher.moduleIdToModuleImplementation(_MODULE_INTERNAL_ID)
        );

        assertEq(address(internalModuleV1), address(0));

        singleModuleProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
        installerProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
    }
}
