// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexEndpoint} from "../src/interfaces/IReflexEndpoint.sol";
import {IReflexInstaller} from "../src/interfaces/IReflexInstaller.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";
import {IReflexStorage} from "../src/interfaces/IReflexStorage.sol";

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

    uint32 internal constant _MODULE_ID_SINGLE = 100;

    // =======
    // Storage
    // =======

    MockImplementationModule public singleModuleV1;
    MockImplementationModule public singleModuleV2;
    MockImplementationModule public singleModuleV3;
    MockImplementationMaliciousStorageModule public singleModuleMaliciousStorageV4;

    MockImplementationModule public singleModuleEndpoint;

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

        singleModuleV3 = new MockImplementationModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_SINGLE, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        singleModuleMaliciousStorageV4 = new MockImplementationMaliciousStorageModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_SINGLE, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV1);
        installerEndpoint.addModules(moduleAddresses);

        singleModuleEndpoint = MockImplementationModule(dispatcher.getEndpoint(_MODULE_ID_SINGLE));
    }

    // =====
    // Tests
    // =====

    function testUnitGetModuleImplementation() external {
        assertEq(dispatcher.getModuleImplementation(_MODULE_ID_SINGLE), address(singleModuleV1));
    }

    function testUnitGetEndpoint() external {
        assertEq(dispatcher.getEndpoint(_MODULE_ID_SINGLE), address(singleModuleEndpoint));
    }

    function testUnitGetTrustRelation() external {
        IReflexStorage.TrustRelation memory relation = dispatcher.getTrustRelation(address(singleModuleEndpoint));

        assertEq(relation.moduleId, _MODULE_ID_SINGLE);
        assertEq(relation.moduleImplementation, address(singleModuleV1));
    }

    function testUnitModuleSettings() external {
        // Endpoints

        _verifyModuleConfiguration(singleModuleEndpoint, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        // Modules

        _verifyModuleConfiguration(singleModuleV1, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);
        _verifyModuleConfiguration(singleModuleV2, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);
        _verifyModuleConfiguration(singleModuleV3, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        _verifyModuleConfiguration(singleModuleMaliciousStorageV4, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);
    }

    function testFuzzUpgradeSingleEndpoint(bytes32 message_) external brutalizeMemory {
        // Initialize the storage in the `Dispatcher` context.

        dispatcher.setImplementationStorage0(message_);

        // Verify single-endpoint module.

        _verifyModuleConfiguration(singleModuleEndpoint, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        // Upgrade single-endpoint module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV2);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(singleModuleEndpoint, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyUnmodifiedStorageSlots(message_);

        // Upgrade the upgraded single-endpoint module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV3);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(singleModuleEndpoint, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyUnmodifiedStorageSlots(message_);
    }

    function testFuzzUpgradeSingleModuleToMaliciousStorageModule(
        bytes32 messageA_,
        bytes32 messageB_
    ) external brutalizeMemory {
        // TODO: verify this is broken if implementation storage is not implemented correctly.

        vm.assume(messageA_ != messageB_);

        // Initialize and verify the storage in the `Dispatcher` context.

        dispatcher.setImplementationStorage0(messageA_);

        assertEq(dispatcher.getImplementationStorage0(), messageA_);

        _verifyModuleConfiguration(singleModuleEndpoint, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        // Upgrade single-endpoint module to malicious storage module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleMaliciousStorageV4);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(singleModuleEndpoint, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        // Verify that the malicious module indeed causes a conflict with the one used in the `Dispatcher` context.

        assertEq(
            dispatcher.IMPLEMENTATION_STORAGE_SLOT(),
            MockImplementationMaliciousStorageModule(address(singleModuleEndpoint))
                .MALICIOUS_IMPLEMENTATION_STORAGE_SLOT()
        );

        // Overwrite storage in the `Dispatcher` context from the malicious module.

        MockImplementationMaliciousStorageModule(address(singleModuleEndpoint)).setMaliciousImplementationStorage0(
            messageB_
        );

        // Verify storage has been modified by malicious upgrade in `Dispatcher` context.

        assertEq(
            MockImplementationMaliciousStorageModule(address(singleModuleEndpoint))
                .getMaliciousImplementationStorage0(),
            messageB_
        );

        // Verify that the storage in the `Dispatcher` context has been overwritten, this is disastrous.

        assertEq(dispatcher.getImplementationStorage0(), messageB_);

        // Overwrite storage in the `Dispatcher` context.

        dispatcher.setImplementationStorage0(messageA_);

        // Verify that the storage in the `Dispatcher` context has been overwritten.

        assertEq(dispatcher.getImplementationStorage0(), messageA_);

        assertEq(
            MockImplementationMaliciousStorageModule(address(singleModuleEndpoint))
                .getMaliciousImplementationStorage0(),
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

    function _verifyUnmodifiedStorageSlots(bytes32 message_) internal {
        assertEq((singleModuleV1).getImplementationStorage0(), 0);
        assertEq((singleModuleV2).getImplementationStorage0(), 0);
        assertEq(singleModuleEndpoint.getImplementationStorage0(), message_);
        assertEq(dispatcher.getImplementationStorage0(), message_);
    }
}
