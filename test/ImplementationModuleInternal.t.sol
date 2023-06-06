// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationDeprecatedModule} from "./mocks/MockImplementationDeprecatedModule.sol";
import {MockImplementationMaliciousModule} from "./mocks/MockImplementationMaliciousModule.sol";
import {MockImplementationModule} from "./mocks/MockImplementationModule.sol";

/**
 * @title Implementation Module Internal Test
 */
contract ImplementationModuleInternalTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_ENDPOINT;
    uint16 internal constant _MODULE_SINGLE_VERSION_V1 = 1;
    uint16 internal constant _MODULE_SINGLE_VERSION_V2 = 2;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V2 = false;

    uint32 internal constant _MODULE_INTERNAL_ID = 101;
    uint16 internal constant _MODULE_INTERNAL_TYPE = _MODULE_TYPE_INTERNAL;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V1 = 1;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V2 = 2;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V3 = 3;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V4 = 4;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V2 = true;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V3 = false;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE_V4 = false;

    // =======
    // Storage
    // =======

    MockImplementationModule public singleModuleV1;
    MockImplementationModule public singleModuleV2;
    MockImplementationModule public singleModuleEndpoint;

    MockImplementationModule public internalModuleV1;
    MockImplementationModule public internalModuleV2;
    MockImplementationDeprecatedModule public internalModuleV3;
    MockImplementationMaliciousModule public internalModuleV4;

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

        internalModuleV4 = new MockImplementationMaliciousModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V4,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V4
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModuleV1);
        moduleAddresses[1] = address(internalModuleV1);
        installerEndpoint.addModules(moduleAddresses);

        singleModuleEndpoint = MockImplementationModule(dispatcher.moduleIdToEndpoint(_MODULE_SINGLE_ID));
    }

    // =====
    // Tests
    // =====

    function testUnitModuleIdToImplementation() external {
        assertEq(dispatcher.moduleIdToModuleImplementation(_MODULE_INTERNAL_ID), address(internalModuleV1));
    }

    function testUnitModuleIdToEndpoint() external {
        assertEq(dispatcher.moduleIdToEndpoint(_MODULE_INTERNAL_ID), address(0));
    }

    function testUnitModuleSettings() external {
        // Endpoints

        _verifyModuleConfiguration(
            singleModuleEndpoint,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V1,
            _MODULE_SINGLE_UPGRADEABLE_V1
        );

        // Modules

        _verifyModuleConfiguration(
            singleModuleV1,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V1,
            _MODULE_SINGLE_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            singleModuleV2,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V2,
            _MODULE_SINGLE_UPGRADEABLE_V2
        );

        _verifyModuleConfiguration(
            internalModuleV1,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V1,
            _MODULE_INTERNAL_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            internalModuleV2,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V2,
            _MODULE_INTERNAL_UPGRADEABLE_V2
        );

        _verifyModuleConfiguration(
            internalModuleV3,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V3,
            _MODULE_INTERNAL_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            internalModuleV4,
            _MODULE_INTERNAL_ID,
            _MODULE_INTERNAL_TYPE,
            _MODULE_INTERNAL_VERSION_V4,
            _MODULE_INTERNAL_UPGRADEABLE_V4
        );
    }

    function testFuzzCallInternalModule(bytes32 message_) external {
        bytes32 value = abi.decode(
            singleModuleEndpoint.callInternalModule(
                _MODULE_INTERNAL_ID,
                abi.encodeWithSignature("getImplementationState0()")
            ),
            (bytes32)
        );

        assertEq(value, 0);

        singleModuleEndpoint.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("setImplementationState0(bytes32)", message_)
        );

        value = abi.decode(
            singleModuleEndpoint.callInternalModule(
                _MODULE_INTERNAL_ID,
                abi.encodeWithSignature("getImplementationState0()")
            ),
            (bytes32)
        );

        assertEq(value, message_);
    }

    function testUnitRevertInvalidCallInternalModule() external {
        vm.expectRevert();
        singleModuleEndpoint.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("getImplementationState777()")
        );
    }

    function testFuzzUpgradeInternalModuleAndDeprecate(bytes32 message_) external brutalizeMemory {
        // Verify storage sets in `Dispatcher` context.

        _verifySetStateSlot(message_);

        // Verify internal module.

        _verifyModuleConfiguration(
            singleModuleEndpoint,
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

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyGetStateSlot(message_);

        // Upgrade internal module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(internalModuleV2);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V2,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V2
            })
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyGetStateSlot(message_);

        // Upgrade single-endpoint module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV2);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            singleModuleEndpoint,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V2,
            _MODULE_SINGLE_UPGRADEABLE_V2
        );

        // Upgrade to deprecate internal module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(internalModuleV3);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V3,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V3
            })
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyGetStateSlot(message_);
    }

    function testFuzzUpgradeInternalModuleToMaliciousModule(bytes32 message_, uint8 number_) external brutalizeMemory {
        vm.assume(uint8(uint256(message_)) != number_);

        // Verify storage sets in `Dispatcher` context.

        _verifySetStateSlot(message_);

        assertEq(dispatcher.getImplementationState0(), message_);

        _verifyModuleConfiguration(
            singleModuleEndpoint,
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

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(internalModuleV4);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V4,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE_V4
            })
        );

        // Overwrite storage in the `Dispatcher` context from the malicious module.

        singleModuleEndpoint.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("setNumber(uint8)", number_)
        );

        // Verify storage has been modified by malicious upgrade in `Dispatcher` context.

        assertEq(
            abi.decode(
                singleModuleEndpoint.callInternalModule(_MODULE_INTERNAL_ID, abi.encodeWithSignature("getNumber()")),
                (uint8)
            ),
            number_
        );

        // Verify that the storage in the `Dispatcher` context has been overwritten.

        assertEq(uint8(uint256(dispatcher.getImplementationState0())), number_);
        assertFalse(dispatcher.getImplementationState0() == message_);

        // Overwrite storage in the `Dispatcher` context.

        dispatcher.setImplementationState0(message_);

        // Verify that the storage in the `Dispatcher` context has been overwritten.

        assertEq(dispatcher.getImplementationState0(), message_);
        assertFalse(uint8(uint256(dispatcher.getImplementationState0())) == number_);
    }

    // =========
    // Utilities
    // =========

    function _verifyModuleConfiguration(IReflexModule.ModuleSettings memory moduleSettings_) internal {
        IReflexModule.ModuleSettings memory moduleSettings = abi.decode(
            singleModuleEndpoint.callInternalModule(_MODULE_INTERNAL_ID, abi.encodeWithSignature("moduleSettings()")),
            (IReflexModule.ModuleSettings)
        );

        assertEq(moduleSettings.moduleId, moduleSettings_.moduleId);
        assertEq(moduleSettings.moduleType, moduleSettings_.moduleType);
        assertEq(moduleSettings.moduleVersion, moduleSettings_.moduleVersion);
        assertEq(moduleSettings.moduleUpgradeable, moduleSettings_.moduleUpgradeable);
    }

    function _verifyGetStateSlot(bytes32 message_) internal {
        assertEq(singleModuleV1.getImplementationState0(), 0);
        assertEq(singleModuleV2.getImplementationState0(), 0);
        assertEq(singleModuleEndpoint.getImplementationState0(), message_);

        assertEq(internalModuleV1.getImplementationState0(), 0);
        assertEq(internalModuleV2.getImplementationState0(), 0);
        assertEq(internalModuleV3.getImplementationState0(), 0);

        assertEq(
            abi.decode(
                singleModuleEndpoint.callInternalModule(
                    _MODULE_INTERNAL_ID,
                    abi.encodeWithSignature("getImplementationState0()")
                ),
                (bytes32)
            ),
            message_
        );
        assertEq(dispatcher.getImplementationState0(), message_);
    }

    function _verifySetStateSlot(bytes32 message_) internal {
        singleModuleEndpoint.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("setImplementationState0(bytes32)", 0)
        );

        _verifyGetStateSlot(0);

        singleModuleEndpoint.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("setImplementationState0(bytes32)", message_)
        );

        _verifyGetStateSlot(message_);
    }
}
