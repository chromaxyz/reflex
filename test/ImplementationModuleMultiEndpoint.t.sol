// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexEndpoint} from "../src/interfaces/IReflexEndpoint.sol";
import {IReflexInstaller} from "../src/interfaces/IReflexInstaller.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationDeprecatedModule} from "./mocks/MockImplementationDeprecatedModule.sol";
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

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_ENDPOINT;
    uint16 internal constant _MODULE_SINGLE_VERSION_V1 = 1;
    uint16 internal constant _MODULE_SINGLE_VERSION_V2 = 2;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V2 = false;

    uint32 internal constant _MODULE_MULTI_ID = 101;
    uint16 internal constant _MODULE_MULTI_TYPE = _MODULE_TYPE_MULTI_ENDPOINT;
    uint16 internal constant _MODULE_MULTI_VERSION_V1 = 1;
    uint16 internal constant _MODULE_MULTI_VERSION_V2 = 2;
    uint16 internal constant _MODULE_MULTI_VERSION_V3 = 3;
    uint16 internal constant _MODULE_MULTI_VERSION_V4 = 4;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V2 = true;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V3 = false;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V4 = true;

    string internal constant _MODULE_MULTI_NAME_A = "TOKEN A";
    string internal constant _MODULE_MULTI_SYMBOL_A = "TKNA";
    uint8 internal constant _MODULE_MULTI_DECIMALS_A = 18;

    string internal constant _MODULE_MULTI_NAME_B = "TOKEN B";
    string internal constant _MODULE_MULTI_SYMBOL_B = "TKNB";
    uint8 internal constant _MODULE_MULTI_DECIMALS_B = 6;

    string internal constant _MODULE_MULTI_NAME_C = "TOKEN C";
    string internal constant _MODULE_MULTI_SYMBOL_C = "TKNC";
    uint8 internal constant _MODULE_MULTI_DECIMALS_C = 8;

    uint256 internal constant _TOKEN_MINT_AMOUNT = 100e18;

    // =======
    // Storage
    // =======

    MockImplementationERC20Hub public singleModuleV1;
    MockImplementationERC20Hub public singleModuleV2;
    MockImplementationERC20Hub public singleModuleEndpoint;

    MockImplementationERC20 public multiModuleV1;
    MockImplementationERC20 public multiModuleV2;
    MockImplementationDeprecatedModule public multiModuleDeprecatedV3;
    MockImplementationMaliciousStorageModule public multiModuleMaliciousStorageV3;
    MockImplementationERC20 public multiModuleV4;

    MockImplementationERC20 public multiModuleEndpointA;
    MockImplementationERC20 public multiModuleEndpointB;
    MockImplementationERC20 public multiModuleEndpointC;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModuleV1 = new MockImplementationERC20Hub(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V1,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V1
            })
        );

        singleModuleV2 = new MockImplementationERC20Hub(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V2,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V2
            })
        );

        multiModuleV1 = new MockImplementationERC20(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V1,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V1
            })
        );

        multiModuleV2 = new MockImplementationERC20(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V2,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V2
            })
        );

        multiModuleDeprecatedV3 = new MockImplementationDeprecatedModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V3,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V3
            })
        );

        multiModuleMaliciousStorageV3 = new MockImplementationMaliciousStorageModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V3,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V3
            })
        );

        multiModuleV4 = new MockImplementationERC20(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V4,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V4
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModuleV1);
        moduleAddresses[1] = address(multiModuleV1);
        installerEndpoint.addModules(moduleAddresses);

        singleModuleEndpoint = MockImplementationERC20Hub(dispatcher.moduleIdToEndpoint(_MODULE_SINGLE_ID));

        multiModuleEndpointA = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_MULTI_ID,
                _MODULE_MULTI_TYPE,
                _MODULE_MULTI_NAME_A,
                _MODULE_MULTI_SYMBOL_A,
                _MODULE_MULTI_DECIMALS_A
            )
        );

        multiModuleEndpointB = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_MULTI_ID,
                _MODULE_MULTI_TYPE,
                _MODULE_MULTI_NAME_B,
                _MODULE_MULTI_SYMBOL_B,
                _MODULE_MULTI_DECIMALS_B
            )
        );

        multiModuleEndpointC = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_MULTI_ID,
                _MODULE_MULTI_TYPE,
                _MODULE_MULTI_NAME_C,
                _MODULE_MULTI_SYMBOL_C,
                _MODULE_MULTI_DECIMALS_C
            )
        );
    }

    // =====
    // Tests
    // =====

    function testUnitModuleIdToImplementation() external {
        assertEq(dispatcher.moduleIdToModuleImplementation(_MODULE_MULTI_ID), address(multiModuleV1));
        assertEq(IReflexEndpoint(address(multiModuleEndpointA)).implementation(), address(multiModuleV1));
        assertEq(IReflexEndpoint(address(multiModuleEndpointB)).implementation(), address(multiModuleV1));
        assertEq(IReflexEndpoint(address(multiModuleEndpointC)).implementation(), address(multiModuleV1));
    }

    function testUnitModuleIdToEndpoint() external {
        assertEq(dispatcher.moduleIdToEndpoint(_MODULE_MULTI_ID), address(0));
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

        _verifyModuleConfiguration(
            multiModuleEndpointA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            multiModuleEndpointB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            multiModuleEndpointC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1
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
            multiModuleV1,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            multiModuleV2,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2
        );

        _verifyModuleConfiguration(
            multiModuleDeprecatedV3,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            multiModuleMaliciousStorageV3,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            multiModuleV4,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V4,
            _MODULE_MULTI_UPGRADEABLE_V4
        );
    }

    function testFuzzUpgradeMultiEndpointAndDeprecate(bytes32 message_) external brutalizeMemory {
        // Verify storage sets in `Dispatcher` context.

        _verifySetStateSlot(message_);

        // Verify multi-endpoint module.

        _verifyModuleConfiguration(
            multiModuleEndpointA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            multiModuleEndpointB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            multiModuleEndpointC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1
        );

        // Upgrade multi-endpoint module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleV2);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            multiModuleEndpointA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2
        );

        _verifyModuleConfiguration(
            multiModuleEndpointB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2
        );

        _verifyModuleConfiguration(
            multiModuleEndpointC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2
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

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyGetStateSlot(message_);

        // Upgrade to deprecate multi-endpoint module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleDeprecatedV3);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            multiModuleEndpointA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            multiModuleEndpointB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            multiModuleEndpointC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyGetStateSlot(message_);

        // Attempt to upgrade multi-endpoint module that was marked as deprecated, this should fail.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleV4);

        vm.expectRevert(
            abi.encodeWithSelector(IReflexInstaller.ModuleNotUpgradeable.selector, multiModuleV4.moduleId())
        );
        installerEndpoint.upgradeModules(moduleAddresses);

        // Verify multi-endpoint module was not upgraded.

        _verifyModuleConfiguration(
            multiModuleEndpointA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            multiModuleEndpointB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            multiModuleEndpointC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyGetStateSlot(message_);
    }

    function testFuzzUpgradeMultiEndpointToMaliciousStorageModule(
        bytes32 message_,
        uint8 number_
    ) external brutalizeMemory {
        vm.assume(uint8(uint256(message_)) != number_);

        // Verify storage sets in `Dispatcher` context.

        _verifySetStateSlot(message_);

        // Upgrade multi-endpoint module to malicious storage module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleMaliciousStorageV3);
        installerEndpoint.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            multiModuleEndpointA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            multiModuleEndpointB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            multiModuleEndpointC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        // Overwrite storage in the `Dispatcher` context from the malicious module.

        MockImplementationMaliciousStorageModule(address(multiModuleEndpointA)).setNumber(number_);

        // Verify storage has been modified by malicious upgrade in `Dispatcher` context.

        assertEq(MockImplementationMaliciousStorageModule(address(multiModuleEndpointA)).getNumber(), number_);
        assertEq(MockImplementationMaliciousStorageModule(address(multiModuleEndpointB)).getNumber(), number_);
        assertEq(MockImplementationMaliciousStorageModule(address(multiModuleEndpointC)).getNumber(), number_);

        // Verify that the storage in the `Dispatcher` context has been overwritten, this is disastrous.

        assertEq(uint8(uint256(dispatcher.getImplementationState0())), number_);
        assertFalse(dispatcher.getImplementationState0() == message_);

        // Overwrite storage in the `Dispatcher` context.

        dispatcher.setImplementationState0(message_);

        // Verify that the storage in the `Dispatcher` context has been overwritten.

        assertEq(dispatcher.getImplementationState0(), message_);
        assertFalse(uint8(uint256(dispatcher.getImplementationState0())) == number_);
    }

    function testUnitEndpointSentinelFallback() external {
        _testEndpointSentinelFallback(multiModuleEndpointA);
        _testEndpointSentinelFallback(multiModuleEndpointB);
        _testEndpointSentinelFallback(multiModuleEndpointC);
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

    function _verifyGetStateSlot(bytes32 message_) internal {
        assertEq(singleModuleV1.getImplementationState0(), 0);
        assertEq(singleModuleV2.getImplementationState0(), 0);
        assertEq(singleModuleEndpoint.getImplementationState0(), message_);

        assertEq(multiModuleV1.getImplementationState0(), 0);
        assertEq(multiModuleV2.getImplementationState0(), 0);
        assertEq(multiModuleDeprecatedV3.getImplementationState0(), 0);
        assertEq(multiModuleV4.getImplementationState0(), 0);

        assertEq(multiModuleEndpointA.getImplementationState0(), message_);
        assertEq(multiModuleEndpointB.getImplementationState0(), message_);
        assertEq(multiModuleEndpointC.getImplementationState0(), message_);

        assertEq(dispatcher.getImplementationState0(), message_);
    }

    function _verifySetStateSlot(bytes32 message_) internal {
        dispatcher.setImplementationState0(0);

        _verifyGetStateSlot(0);

        dispatcher.setImplementationState0(message_);

        _verifyGetStateSlot(message_);
    }
}
