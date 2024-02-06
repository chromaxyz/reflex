// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexInstaller} from "../src/interfaces/IReflexInstaller.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";
import {IReflexStorage} from "../src/interfaces/IReflexStorage.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationMaliciousStorageModule} from "./mocks/MockImplementationMaliciousStorageModule.sol";
import {MockImplementationModule} from "./mocks/MockImplementationModule.sol";

/**
 * @title Implementation Module Internal Test
 */
contract ImplementationModuleInternalTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_SINGLE = 100;
    uint32 internal constant _MODULE_INTERNAL_ID = 101;

    // =======
    // Storage
    // =======

    MockImplementationModule public singleModuleV1;
    MockImplementationModule public singleModuleV2;
    MockImplementationModule public singleModuleEndpoint;

    MockImplementationModule public internalModuleV1;
    MockImplementationModule public internalModuleV2;
    MockImplementationModule public internalModuleV3;
    MockImplementationMaliciousStorageModule public internalModuleMaliciousStorageV4;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModuleV1 = new MockImplementationModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_SINGLE, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        singleModuleV2 = new MockImplementationModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_SINGLE, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        internalModuleV1 = new MockImplementationModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_TYPE_INTERNAL})
        );

        internalModuleV2 = new MockImplementationModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_TYPE_INTERNAL})
        );

        internalModuleV3 = new MockImplementationModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_TYPE_INTERNAL})
        );

        internalModuleMaliciousStorageV4 = new MockImplementationMaliciousStorageModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_TYPE_INTERNAL})
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModuleV1);
        moduleAddresses[1] = address(internalModuleV1);
        installerEndpoint.addModules(moduleAddresses);

        singleModuleEndpoint = MockImplementationModule(dispatcher.getEndpoint(_MODULE_ID_SINGLE));
    }

    // =====
    // Tests
    // =====

    function testUnitGetModuleImplementation() external {
        assertEq(dispatcher.getModuleImplementation(_MODULE_INTERNAL_ID), address(internalModuleV1));
    }

    function testUnitGetEndpoint() external {
        assertEq(dispatcher.getEndpoint(_MODULE_INTERNAL_ID), address(0));
    }

    function testUnitGetTrustRelation() external {
        IReflexStorage.TrustRelation memory relation = dispatcher.getTrustRelation(address(internalModuleV1));

        assertEq(relation.moduleId, 0);
        assertEq(relation.moduleImplementation, address(0));
    }

    function testUnitModuleSettings() external {
        // Endpoints

        _verifyModuleConfiguration(singleModuleEndpoint, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        // Modules

        _verifyModuleConfiguration(singleModuleV1, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);
        _verifyModuleConfiguration(singleModuleV2, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        _verifyModuleConfiguration(internalModuleV1, _MODULE_INTERNAL_ID, _MODULE_TYPE_INTERNAL);
        _verifyModuleConfiguration(internalModuleV2, _MODULE_INTERNAL_ID, _MODULE_TYPE_INTERNAL);
        _verifyModuleConfiguration(internalModuleV3, _MODULE_INTERNAL_ID, _MODULE_TYPE_INTERNAL);

        _verifyModuleConfiguration(internalModuleMaliciousStorageV4, _MODULE_INTERNAL_ID, _MODULE_TYPE_INTERNAL);
    }

    function testFuzzCallInternalModule(bytes32 message_) external {
        bytes32 value = abi.decode(
            singleModuleEndpoint.callInternalModule(
                _MODULE_INTERNAL_ID,
                abi.encodeWithSignature("getImplementationStorage0()")
            ),
            (bytes32)
        );

        assertEq(value, 0);

        singleModuleEndpoint.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("setImplementationStorage0(bytes32)", message_)
        );

        value = abi.decode(
            singleModuleEndpoint.callInternalModule(
                _MODULE_INTERNAL_ID,
                abi.encodeWithSignature("getImplementationStorage0()")
            ),
            (bytes32)
        );

        assertEq(value, message_);
    }

    function testUnitRevertInvalidCallInternalModule() external {
        vm.expectRevert();
        singleModuleEndpoint.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("getImplementationStorage777()")
        );
    }

    function testFuzzUpgradeInternalModule(bytes32 message_) external brutalizeMemory {
        // Initialize the storage in the `Dispatcher` context.

        singleModuleEndpoint.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("setImplementationStorage0(bytes32)", message_)
        );

        // Verify internal module.

        _verifyModuleConfiguration(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_TYPE_INTERNAL})
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyUnmodifiedStorageSlots(message_);

        // Upgrade internal module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(internalModuleV2);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_TYPE_INTERNAL})
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyUnmodifiedStorageSlots(message_);

        // Upgrade single-endpoint module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV2);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(singleModuleEndpoint, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        // Upgrade the upgraded internal module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(internalModuleV3);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_TYPE_INTERNAL})
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyUnmodifiedStorageSlots(message_);
    }

    function testFuzzUpgradeInternalModuleToMaliciousStorageModule(
        bytes32 messageA_,
        bytes32 messageB_
    ) external brutalizeMemory {
        vm.assume(messageA_ != messageB_);

        // Initialize and verify the storage in the `Dispatcher` context.

        dispatcher.setImplementationStorage0(messageA_);

        assertEq(dispatcher.getImplementationStorage0(), messageA_);

        _verifyModuleConfiguration(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_TYPE_INTERNAL})
        );

        // Upgrade internal module to malicious storage module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(internalModuleMaliciousStorageV4);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_TYPE_INTERNAL})
        );

        // Verify that the malicious module indeed causes a conflict with the one used in the `Dispatcher` context.

        assertEq(
            dispatcher.IMPLEMENTATION_STORAGE_SLOT(),
            abi.decode(
                singleModuleEndpoint.callInternalModule(
                    _MODULE_INTERNAL_ID,
                    abi.encodeWithSignature("MALICIOUS_IMPLEMENTATION_STORAGE_SLOT()")
                ),
                (bytes32)
            )
        );

        // Overwrite storage in the `Dispatcher` context from the malicious module.

        singleModuleEndpoint.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("setMaliciousImplementationStorage0(bytes32)", messageB_)
        );

        // Verify storage has been modified by malicious upgrade in `Dispatcher` context.

        assertEq(
            abi.decode(
                singleModuleEndpoint.callInternalModule(
                    _MODULE_INTERNAL_ID,
                    abi.encodeWithSignature("getMaliciousImplementationStorage0()")
                ),
                (bytes32)
            ),
            messageB_
        );

        // Verify that the storage in the `Dispatcher` context has been overwritten, this is disastrous.

        assertEq(dispatcher.getImplementationStorage0(), messageB_);

        // Overwrite storage in the `Dispatcher` context.

        dispatcher.setImplementationStorage0(messageA_);

        // Verify that the storage in the `Dispatcher` context has been overwritten.

        assertEq(dispatcher.getImplementationStorage0(), messageA_);

        assertEq(
            abi.decode(
                singleModuleEndpoint.callInternalModule(
                    _MODULE_INTERNAL_ID,
                    abi.encodeWithSignature("getMaliciousImplementationStorage0()")
                ),
                (bytes32)
            ),
            messageA_
        );
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
    }

    function _verifyUnmodifiedStorageSlots(bytes32 message_) internal {
        assertEq(singleModuleV1.getImplementationStorage0(), 0);
        assertEq(singleModuleV2.getImplementationStorage0(), 0);
        assertEq(singleModuleEndpoint.getImplementationStorage0(), message_);

        assertEq(internalModuleV1.getImplementationStorage0(), 0);
        assertEq(internalModuleV2.getImplementationStorage0(), 0);
        assertEq(internalModuleV3.getImplementationStorage0(), 0);

        assertEq(
            abi.decode(
                singleModuleEndpoint.callInternalModule(
                    _MODULE_INTERNAL_ID,
                    abi.encodeWithSignature("getImplementationStorage0()")
                ),
                (bytes32)
            ),
            message_
        );
        assertEq(dispatcher.getImplementationStorage0(), message_);
    }
}
