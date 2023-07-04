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
import {MockImplementationModule} from "./mocks/MockImplementationModule.sol";
import {MockImplementationERC20} from "./mocks/MockImplementationERC20.sol";
import {MockImplementationERC20Hub} from "./mocks/MockImplementationERC20Hub.sol";
import {MockImplementationMaliciousStorageModule} from "./mocks/MockImplementationMaliciousStorageModule.sol";

/**
 * @title Implementation Module Multi Endpoint Test
 */
contract ImplementationModuleMultiEndpointTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_SINGLE = 100;
    uint32 internal constant _MODULE_ID_MULTI = 101;

    string internal constant _MODULE_NAME_MULTI_A = "TOKEN A";
    string internal constant _MODULE_SYMBOL_MULTI_A = "TKNA";
    uint8 internal constant _MODULE_DECIMALS_MULTI_A = 18;

    string internal constant _MODULE_NAME_MULTI_B = "TOKEN B";
    string internal constant _MODULE_SYMBOL_MULTI_B = "TKNB";
    uint8 internal constant _MODULE_DECIMALS_MULTI_B = 6;

    string internal constant _MODULE_NAME_MULTI_C = "TOKEN C";
    string internal constant _MODULE_SYMBOL_MULTI_C = "TKNC";
    uint8 internal constant _MODULE_DECIMALS_MULTI_C = 8;

    // =======
    // Storage
    // =======

    MockImplementationERC20Hub public singleModuleV1;
    MockImplementationERC20Hub public singleModuleV2;
    MockImplementationERC20Hub public singleModuleEndpoint;

    MockImplementationERC20 public multiModuleV1;
    MockImplementationERC20 public multiModuleV2;
    MockImplementationModule public multiModuleV3;
    MockImplementationMaliciousStorageModule public multiModuleMaliciousStorageV4;

    MockImplementationERC20 public multiModuleEndpointA;
    MockImplementationERC20 public multiModuleEndpointB;
    MockImplementationERC20 public multiModuleEndpointC;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModuleV1 = new MockImplementationERC20Hub(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_SINGLE, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        singleModuleV2 = new MockImplementationERC20Hub(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_SINGLE, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        multiModuleV1 = new MockImplementationERC20(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_MULTI, moduleType: _MODULE_TYPE_MULTI_ENDPOINT})
        );

        multiModuleV2 = new MockImplementationERC20(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_MULTI, moduleType: _MODULE_TYPE_MULTI_ENDPOINT})
        );

        multiModuleV3 = new MockImplementationModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_MULTI, moduleType: _MODULE_TYPE_MULTI_ENDPOINT})
        );

        multiModuleMaliciousStorageV4 = new MockImplementationMaliciousStorageModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_MULTI, moduleType: _MODULE_TYPE_MULTI_ENDPOINT})
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModuleV1);
        moduleAddresses[1] = address(multiModuleV1);
        installerEndpoint.addModules(moduleAddresses);

        singleModuleEndpoint = MockImplementationERC20Hub(dispatcher.getEndpoint(_MODULE_ID_SINGLE));

        multiModuleEndpointA = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_ID_MULTI,
                _MODULE_TYPE_MULTI_ENDPOINT,
                _MODULE_NAME_MULTI_A,
                _MODULE_SYMBOL_MULTI_A,
                _MODULE_DECIMALS_MULTI_A
            )
        );

        multiModuleEndpointB = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_ID_MULTI,
                _MODULE_TYPE_MULTI_ENDPOINT,
                _MODULE_NAME_MULTI_B,
                _MODULE_SYMBOL_MULTI_B,
                _MODULE_DECIMALS_MULTI_B
            )
        );

        multiModuleEndpointC = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_ID_MULTI,
                _MODULE_TYPE_MULTI_ENDPOINT,
                _MODULE_NAME_MULTI_C,
                _MODULE_SYMBOL_MULTI_C,
                _MODULE_DECIMALS_MULTI_C
            )
        );
    }

    // =====
    // Tests
    // =====

    function testUnitGetModuleImplementation() external {
        assertEq(dispatcher.getModuleImplementation(_MODULE_ID_MULTI), address(multiModuleV1));
    }

    function testUnitGetEndpoint() external {
        assertEq(dispatcher.getEndpoint(_MODULE_ID_MULTI), address(0));
    }

    function testUnitGetTrustRelation() external {
        IReflexState.TrustRelation memory relationA = dispatcher.getTrustRelation(address(multiModuleEndpointA));
        IReflexState.TrustRelation memory relationB = dispatcher.getTrustRelation(address(multiModuleEndpointB));
        IReflexState.TrustRelation memory relationC = dispatcher.getTrustRelation(address(multiModuleEndpointC));

        assertEq(relationA.moduleId, _MODULE_ID_MULTI);
        assertEq(relationB.moduleId, _MODULE_ID_MULTI);
        assertEq(relationC.moduleId, _MODULE_ID_MULTI);

        assertEq(relationA.moduleImplementation, address(0));
        assertEq(relationB.moduleImplementation, address(0));
        assertEq(relationC.moduleImplementation, address(0));
    }

    function testUnitModuleSettings() external {
        // Endpoints

        _verifyModuleConfiguration(singleModuleEndpoint, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        _verifyModuleConfiguration(multiModuleEndpointA, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);

        _verifyModuleConfiguration(multiModuleEndpointB, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);

        _verifyModuleConfiguration(multiModuleEndpointC, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);

        // Modules

        _verifyModuleConfiguration(singleModuleV1, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        _verifyModuleConfiguration(singleModuleV2, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        _verifyModuleConfiguration(multiModuleV1, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);

        _verifyModuleConfiguration(multiModuleV2, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);

        _verifyModuleConfiguration(multiModuleV3, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);

        _verifyModuleConfiguration(multiModuleMaliciousStorageV4, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);
    }

    function testFuzzUpgradeMultiEndpoint(bytes32 message_) external brutalizeMemory {
        // Initialize the storage in the `Dispatcher` context.

        dispatcher.setImplementationState0(message_);

        // Verify multi-endpoint module.

        _verifyModuleConfiguration(multiModuleEndpointA, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);
        _verifyModuleConfiguration(multiModuleEndpointB, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);
        _verifyModuleConfiguration(multiModuleEndpointC, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);

        // Upgrade multi-endpoint module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleV2);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(multiModuleEndpointA, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);
        _verifyModuleConfiguration(multiModuleEndpointB, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);
        _verifyModuleConfiguration(multiModuleEndpointC, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyUnmodifiedStateSlots(message_);

        // Upgrade single-endpoint module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV2);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(singleModuleEndpoint, _MODULE_ID_SINGLE, _MODULE_TYPE_SINGLE_ENDPOINT);

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyUnmodifiedStateSlots(message_);

        // Upgrade the upgraded multi-endpoint module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleV3);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(multiModuleEndpointA, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);
        _verifyModuleConfiguration(multiModuleEndpointB, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);
        _verifyModuleConfiguration(multiModuleEndpointC, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyUnmodifiedStateSlots(message_);
    }

    function testFuzzUpgradeMultiModuleToMaliciousStorageModule(
        bytes32 messageA_,
        bytes32 messageB_
    ) external brutalizeMemory {
        vm.assume(messageA_ != messageB_);

        // Initialize and verify the storage in the `Dispatcher` context.

        dispatcher.setImplementationState0(messageA_);

        assertEq(dispatcher.getImplementationState0(), messageA_);

        // Upgrade multi-endpoint module to malicious storage module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleMaliciousStorageV4);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(multiModuleEndpointA, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);
        _verifyModuleConfiguration(multiModuleEndpointB, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);
        _verifyModuleConfiguration(multiModuleEndpointC, _MODULE_ID_MULTI, _MODULE_TYPE_MULTI_ENDPOINT);

        // Verify that the malicious module indeed causes a conflict with the one used in the `Dispatcher` context.

        assertEq(
            dispatcher.IMPLEMENTATION_STORAGE_SLOT(),
            MockImplementationMaliciousStorageModule(address(multiModuleEndpointA))
                .MALICIOUS_IMPLEMENTATION_STORAGE_SLOT()
        );

        assertEq(
            dispatcher.IMPLEMENTATION_STORAGE_SLOT(),
            MockImplementationMaliciousStorageModule(address(multiModuleEndpointB))
                .MALICIOUS_IMPLEMENTATION_STORAGE_SLOT()
        );

        assertEq(
            dispatcher.IMPLEMENTATION_STORAGE_SLOT(),
            MockImplementationMaliciousStorageModule(address(multiModuleEndpointC))
                .MALICIOUS_IMPLEMENTATION_STORAGE_SLOT()
        );

        // Overwrite storage in the `Dispatcher` context from the malicious module.

        MockImplementationMaliciousStorageModule(address(multiModuleEndpointA)).setMaliciousImplementationState0(
            messageB_
        );

        // Verify storage has been modified by malicious upgrade in `Dispatcher` context.

        assertEq(
            MockImplementationMaliciousStorageModule(address(multiModuleEndpointA)).getMaliciousImplementationState0(),
            messageB_
        );
        assertEq(
            MockImplementationMaliciousStorageModule(address(multiModuleEndpointB)).getMaliciousImplementationState0(),
            messageB_
        );
        assertEq(
            MockImplementationMaliciousStorageModule(address(multiModuleEndpointC)).getMaliciousImplementationState0(),
            messageB_
        );

        // Verify that the storage in the `Dispatcher` context has been overwritten, this is disastrous.

        assertEq(dispatcher.getImplementationState0(), messageB_);

        // Overwrite storage in the `Dispatcher` context.

        dispatcher.setImplementationState0(messageA_);

        // Verify that the storage in the `Dispatcher` context has been overwritten.

        assertEq(dispatcher.getImplementationState0(), messageA_);

        assertEq(
            MockImplementationMaliciousStorageModule(address(multiModuleEndpointA)).getMaliciousImplementationState0(),
            messageA_
        );
        assertEq(
            MockImplementationMaliciousStorageModule(address(multiModuleEndpointB)).getMaliciousImplementationState0(),
            messageA_
        );
        assertEq(
            MockImplementationMaliciousStorageModule(address(multiModuleEndpointC)).getMaliciousImplementationState0(),
            messageA_
        );
    }

    function testFuzzRevertBytesCustomError(uint256 code_, string memory message_) external {
        _testRevertBytesCustomError(multiModuleEndpointA, code_, message_);
        _testRevertBytesCustomError(multiModuleEndpointB, code_, message_);
        _testRevertBytesCustomError(multiModuleEndpointC, code_, message_);
    }

    function testUnitRevertBytesPanicAssert() external {
        _testRevertBytesPanicAssert(multiModuleEndpointA);
        _testRevertBytesPanicAssert(multiModuleEndpointB);
        _testRevertBytesPanicAssert(multiModuleEndpointC);
    }

    function testUnitRevertBytesPanicDivideByZero() external {
        _testRevertBytesPanicDivideByZero(multiModuleEndpointA);
        _testRevertBytesPanicDivideByZero(multiModuleEndpointB);
        _testRevertBytesPanicDivideByZero(multiModuleEndpointC);
    }

    function testUnitRevertBytesPanicArithmaticOverflow() external {
        _testRevertBytesPanicArithmaticOverflow(multiModuleEndpointA);
        _testRevertBytesPanicArithmaticOverflow(multiModuleEndpointB);
        _testRevertBytesPanicArithmaticOverflow(multiModuleEndpointC);
    }

    function testUnitRevertBytesPanicArithmaticUnderflow() external {
        _testRevertBytesPanicArithmaticUnderflow(multiModuleEndpointA);
        _testRevertBytesPanicArithmaticUnderflow(multiModuleEndpointB);
        _testRevertBytesPanicArithmaticUnderflow(multiModuleEndpointC);
    }

    function testFuzzEndpointLog0Topic(bytes memory message_) external {
        _testEndpointLog0Topic(multiModuleEndpointA, message_);
        _testEndpointLog0Topic(multiModuleEndpointB, message_);
        _testEndpointLog0Topic(multiModuleEndpointC, message_);
    }

    function testFuzzEndpointLog1Topic(bytes memory message_) external {
        _testEndpointLog1Topic(multiModuleEndpointA, message_);
        _testEndpointLog1Topic(multiModuleEndpointB, message_);
        _testEndpointLog1Topic(multiModuleEndpointC, message_);
    }

    function testFuzzEndpointLog2Topic(bytes memory message_) external {
        _testEndpointLog2Topic(multiModuleEndpointA, message_);
        _testEndpointLog2Topic(multiModuleEndpointB, message_);
        _testEndpointLog2Topic(multiModuleEndpointC, message_);
    }

    function testFuzzEndpointLog3Topic(bytes memory message_) external {
        _testEndpointLog3Topic(multiModuleEndpointA, message_);
        _testEndpointLog3Topic(multiModuleEndpointB, message_);
        _testEndpointLog3Topic(multiModuleEndpointC, message_);
    }

    function testFuzzEndpointLog4Topic(bytes memory message_) external {
        _testEndpointLog4Topic(multiModuleEndpointA, message_);
        _testEndpointLog4Topic(multiModuleEndpointB, message_);
        _testEndpointLog4Topic(multiModuleEndpointC, message_);
    }

    function testFuzzRevertEndpointLogOutOfBounds(bytes memory message_) external {
        _testRevertEndpointLogOutOfBounds(multiModuleEndpointA, message_);
        _testRevertEndpointLogOutOfBounds(multiModuleEndpointB, message_);
        _testRevertEndpointLogOutOfBounds(multiModuleEndpointC, message_);
    }

    function testUnitUnpackMessageSender() external {
        vm.startPrank(_users.Alice);
        _testUnpackMessageSender(multiModuleEndpointA, _users.Alice);
        _testUnpackMessageSender(multiModuleEndpointB, _users.Alice);
        _testUnpackMessageSender(multiModuleEndpointC, _users.Alice);
        vm.stopPrank();
    }

    function testUnitUnpackEndpointAddress() external {
        _testUnpackEndpointAddress(multiModuleEndpointA);
        _testUnpackEndpointAddress(multiModuleEndpointB);
        _testUnpackEndpointAddress(multiModuleEndpointC);
    }

    function testUnitUnpackTrailingParameters() external {
        vm.startPrank(_users.Alice);
        _testUnpackTrailingParameters(multiModuleEndpointA, _users.Alice);
        _testUnpackTrailingParameters(multiModuleEndpointB, _users.Alice);
        _testUnpackTrailingParameters(multiModuleEndpointC, _users.Alice);
        vm.stopPrank();
    }

    // =========
    // Utilities
    // =========

    function _verifyUnmodifiedStateSlots(bytes32 message_) internal {
        assertEq(singleModuleV1.getImplementationState0(), 0);
        assertEq(singleModuleV2.getImplementationState0(), 0);
        assertEq(singleModuleEndpoint.getImplementationState0(), message_);

        assertEq(multiModuleV1.getImplementationState0(), 0);
        assertEq(multiModuleV2.getImplementationState0(), 0);
        assertEq(multiModuleV3.getImplementationState0(), 0);

        assertEq(multiModuleEndpointA.getImplementationState0(), message_);
        assertEq(multiModuleEndpointB.getImplementationState0(), message_);
        assertEq(multiModuleEndpointC.getImplementationState0(), message_);

        assertEq(dispatcher.getImplementationState0(), message_);
    }
}
