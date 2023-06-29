// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexEndpoint} from "../src/interfaces/IReflexEndpoint.sol";
import {IReflexInstaller} from "../src/interfaces/IReflexInstaller.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";
import {IReflexState} from "../src/interfaces/IReflexState.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationMaliciousStorageModule} from "./mocks/MockImplementationMaliciousStorageModule.sol";
import {MockImplementationModule} from "./mocks/MockImplementationModule.sol";

/**
 * @title Implementation Module Single Endpoint Test
 */
contract ImplementationModuleSingleEndpointTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_ENDPOINT;
    uint16 internal constant _MODULE_SINGLE_VERSION_V1 = 1;
    uint16 internal constant _MODULE_SINGLE_VERSION_V2 = 2;
    uint16 internal constant _MODULE_SINGLE_VERSION_V3 = 3;
    uint16 internal constant _MODULE_SINGLE_VERSION_V4 = 4;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V2 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V3 = false;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V4 = true;

    // =======
    // Storage
    // =======

    MockImplementationModule public singleModuleV1;
    MockImplementationModule public singleModuleV2;
    MockImplementationModule public singleModuleV3;
    MockImplementationMaliciousStorageModule public singleModuleMaliciousStorageV3;
    MockImplementationModule public singleModuleV4;

    MockImplementationModule public singleModuleEndpoint;

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

        singleModuleV3 = new MockImplementationModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V3,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V3
            })
        );

        singleModuleMaliciousStorageV3 = new MockImplementationMaliciousStorageModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V3,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V3
            })
        );

        singleModuleV4 = new MockImplementationModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V4,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V4
            })
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV1);
        installerEndpoint.addModules(moduleAddresses);

        singleModuleEndpoint = MockImplementationModule(dispatcher.getEndpoint(_MODULE_SINGLE_ID));
    }

    // =====
    // Tests
    // =====

    function testUnitGetModuleImplementation() external {
        assertEq(dispatcher.getModuleImplementation(_MODULE_SINGLE_ID), address(singleModuleV1));
    }

    function testUnitGetEndpoint() external {
        assertEq(dispatcher.getEndpoint(_MODULE_SINGLE_ID), address(singleModuleEndpoint));
    }

    function testUnitGetTrustRelation() external {
        IReflexState.TrustRelation memory relation = dispatcher.getTrustRelation(address(singleModuleEndpoint));

        assertEq(relation.moduleId, _MODULE_SINGLE_ID);
        assertEq(relation.moduleImplementation, address(singleModuleV1));
        assertEq(relation.moduleType, _MODULE_SINGLE_TYPE);
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
            singleModuleV3,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V3,
            _MODULE_SINGLE_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            singleModuleMaliciousStorageV3,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V3,
            _MODULE_SINGLE_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            singleModuleV4,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V4,
            _MODULE_SINGLE_UPGRADEABLE_V4
        );
    }

    function testFuzzUpgradeSingleEndpointAndDeprecate(bytes32 message_) external brutalizeMemory {
        // Initialize the storage in the `Dispatcher` context.

        dispatcher.setImplementationState0(message_);

        // Verify single-endpoint module.

        _verifyModuleConfiguration(
            singleModuleEndpoint,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V1,
            _MODULE_SINGLE_UPGRADEABLE_V1
        );

        // Upgrade single-endpoint module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV2);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            singleModuleEndpoint,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V2,
            _MODULE_SINGLE_UPGRADEABLE_V2
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyUnmodifiedStateSlots(message_);

        // Upgrade to deprecate single-endpoint module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV3);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            singleModuleEndpoint,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V3,
            _MODULE_SINGLE_UPGRADEABLE_V3
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyUnmodifiedStateSlots(message_);

        // Attempt to upgrade single-endpoint module that was marked as deprecated, this should fail.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV4);

        vm.expectRevert(
            abi.encodeWithSelector(IReflexInstaller.ModuleNotUpgradeable.selector, singleModuleV4.moduleId())
        );
        installerEndpoint.upgradeModules(moduleAddresses);

        // Verify single-endpoint module was not upgraded.

        _verifyModuleConfiguration(
            singleModuleEndpoint,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V3,
            _MODULE_SINGLE_UPGRADEABLE_V3
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyUnmodifiedStateSlots(message_);
    }

    function testFuzzUpgradeSingleModuleToMaliciousStorageModule(
        bytes32 messageA_,
        bytes32 messageB_
    ) external brutalizeMemory {
        // TODO: verify this is broken if implementation storage is not implemented correctly.

        vm.assume(messageA_ != messageB_);

        // Initialize and verify the storage in the `Dispatcher` context.

        dispatcher.setImplementationState0(messageA_);

        assertEq(dispatcher.getImplementationState0(), messageA_);

        _verifyModuleConfiguration(
            singleModuleEndpoint,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V1,
            _MODULE_SINGLE_UPGRADEABLE_V1
        );

        // Upgrade single-endpoint module to malicious storage module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleMaliciousStorageV3);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            singleModuleEndpoint,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V3,
            _MODULE_SINGLE_UPGRADEABLE_V3
        );

        // Verify that the malicious module indeed causes a conflict with the one used in the `Dispatcher` context.

        assertEq(
            dispatcher.IMPLEMENTATION_STORAGE_SLOT(),
            MockImplementationMaliciousStorageModule(address(singleModuleEndpoint))
                .MALICIOUS_IMPLEMENTATION_STORAGE_SLOT()
        );

        // Overwrite storage in the `Dispatcher` context from the malicious module.

        MockImplementationMaliciousStorageModule(address(singleModuleEndpoint)).setMaliciousImplementationState0(
            messageB_
        );

        // Verify storage has been modified by malicious upgrade in `Dispatcher` context.

        assertEq(
            MockImplementationMaliciousStorageModule(address(singleModuleEndpoint)).getMaliciousImplementationState0(),
            messageB_
        );

        // Verify that the storage in the `Dispatcher` context has been overwritten, this is disastrous.

        assertEq(dispatcher.getImplementationState0(), messageB_);

        // Overwrite storage in the `Dispatcher` context.

        dispatcher.setImplementationState0(messageA_);

        // Verify that the storage in the `Dispatcher` context has been overwritten.

        assertEq(dispatcher.getImplementationState0(), messageA_);

        assertEq(
            MockImplementationMaliciousStorageModule(address(singleModuleEndpoint)).getMaliciousImplementationState0(),
            messageA_
        );
    }

    function testFuzzRevertBytesCustomError(uint256 code_, string memory message_) external {
        _testRevertBytesCustomError(singleModuleEndpoint, code_, message_);
    }

    function testUnitRevertBytesPanicAssert() external {
        _testRevertBytesPanicAssert(singleModuleEndpoint);
    }

    function testUnitRevertBytesPanicDivideByZero() external {
        _testRevertBytesPanicDivideByZero(singleModuleEndpoint);
    }

    function testUnitRevertBytesPanicArithmaticOverflow() external {
        _testRevertBytesPanicArithmaticOverflow(singleModuleEndpoint);
    }

    function testUnitRevertBytesPanicArithmaticUnderflow() external {
        _testRevertBytesPanicArithmaticUnderflow(singleModuleEndpoint);
    }

    function testFuzzEndpointLog0Topic(bytes memory message_) external {
        _testEndpointLog0Topic(singleModuleEndpoint, message_);
    }

    function testFuzzEndpointLog1Topic(bytes memory message_) external {
        _testEndpointLog1Topic(singleModuleEndpoint, message_);
    }

    function testFuzzEndpointLog2Topic(bytes memory message_) external {
        _testEndpointLog2Topic(singleModuleEndpoint, message_);
    }

    function testFuzzEndpointLog3Topic(bytes memory message_) external {
        _testEndpointLog3Topic(singleModuleEndpoint, message_);
    }

    function testFuzzEndpointLog4Topic(bytes memory message_) external {
        _testEndpointLog4Topic(singleModuleEndpoint, message_);
    }

    function testFuzzRevertEndpointLogOutOfBounds(bytes memory message_) external {
        _testRevertEndpointLogOutOfBounds(singleModuleEndpoint, message_);
    }

    function testUnitUnpackMessageSender() external {
        vm.startPrank(_users.Alice);
        _testUnpackMessageSender(singleModuleEndpoint, _users.Alice);
        vm.stopPrank();
    }

    function testUnitUnpackEndpointAddress() external {
        _testUnpackEndpointAddress(singleModuleEndpoint);
    }

    function testUnitUnpackTrailingParameters() external {
        vm.startPrank(_users.Alice);
        _testUnpackTrailingParameters(singleModuleEndpoint, _users.Alice);
        vm.stopPrank();
    }

    // =========
    // Utilities
    // =========

    function _verifyUnmodifiedStateSlots(bytes32 message_) internal {
        assertEq((singleModuleV1).getImplementationState0(), 0);
        assertEq((singleModuleV2).getImplementationState0(), 0);
        assertEq(singleModuleEndpoint.getImplementationState0(), message_);
        assertEq(dispatcher.getImplementationState0(), message_);
    }
}
