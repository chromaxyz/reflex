// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {TReflexDispatcher} from "../src/interfaces/IReflexDispatcher.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";
import {IReflexProxy} from "../src/interfaces/IReflexProxy.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationDeprecatedModule} from "./mocks/MockImplementationDeprecatedModule.sol";
import {MockImplementationERC20} from "./mocks/MockImplementationERC20.sol";
import {MockImplementationERC20Hub} from "./mocks/MockImplementationERC20Hub.sol";

/**
 * @title Implementation Module Multi Proxy Test
 */
contract ImplementationModuleMultiProxyTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION_V1 = 1;
    uint16 internal constant _MODULE_SINGLE_VERSION_V2 = 2;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V2 = false;

    uint32 internal constant _MODULE_MULTI_ID = 101;
    uint16 internal constant _MODULE_MULTI_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _MODULE_MULTI_VERSION_V1 = 1;
    uint16 internal constant _MODULE_MULTI_VERSION_V2 = 2;
    uint16 internal constant _MODULE_MULTI_VERSION_V3 = 3;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V2 = true;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V3 = false;

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
    MockImplementationERC20Hub public singleModuleProxy;

    MockImplementationERC20 public multiModuleV1;
    MockImplementationERC20 public multiModuleV2;
    MockImplementationDeprecatedModule public multiModuleV3;

    MockImplementationERC20 public multiModuleProxyA;
    MockImplementationERC20 public multiModuleProxyB;
    MockImplementationERC20 public multiModuleProxyC;

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

        multiModuleV3 = new MockImplementationDeprecatedModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V3,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V3
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModuleV1);
        moduleAddresses[1] = address(multiModuleV1);
        installerProxy.addModules(moduleAddresses);

        singleModuleProxy = MockImplementationERC20Hub(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID));

        multiModuleProxyA = MockImplementationERC20(
            singleModuleProxy.addERC20(
                _MODULE_MULTI_ID,
                _MODULE_MULTI_TYPE,
                _MODULE_MULTI_NAME_A,
                _MODULE_MULTI_SYMBOL_A,
                _MODULE_MULTI_DECIMALS_A
            )
        );

        multiModuleProxyB = MockImplementationERC20(
            singleModuleProxy.addERC20(
                _MODULE_MULTI_ID,
                _MODULE_MULTI_TYPE,
                _MODULE_MULTI_NAME_B,
                _MODULE_MULTI_SYMBOL_B,
                _MODULE_MULTI_DECIMALS_B
            )
        );

        multiModuleProxyC = MockImplementationERC20(
            singleModuleProxy.addERC20(
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
        assertEq(IReflexProxy(address(multiModuleProxyA)).implementation(), address(multiModuleV1));
        assertEq(IReflexProxy(address(multiModuleProxyB)).implementation(), address(multiModuleV1));
        assertEq(IReflexProxy(address(multiModuleProxyC)).implementation(), address(multiModuleV1));
    }

    function testUnitModuleIdToProxy() external {
        assertEq(dispatcher.moduleIdToProxy(_MODULE_MULTI_ID), address(0));
    }

    function testUnitModuleSettings() external {
        // Proxies

        _verifyModuleConfiguration(
            singleModuleProxy,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V1,
            _MODULE_SINGLE_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            multiModuleProxyA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            multiModuleProxyB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            multiModuleProxyC,
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
            multiModuleV3,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );
    }

    function testFuzzUpgradeMultiProxyAndDeprecate(bytes32 message_) external BrutalizeMemory {
        // Verify storage sets in `Dispatcher` context.

        _verifySetStateSlot(message_);

        // Verify multi-proxy module.

        _verifyModuleConfiguration(
            multiModuleProxyA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            multiModuleProxyB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1
        );

        _verifyModuleConfiguration(
            multiModuleProxyC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1
        );

        // Upgrade multi-proxy module.

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleV2);
        installerProxy.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            multiModuleProxyA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2
        );

        _verifyModuleConfiguration(
            multiModuleProxyB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2
        );

        _verifyModuleConfiguration(
            multiModuleProxyC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyGetStateSlot(message_);

        // Upgrade single-proxy module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV2);
        installerProxy.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            singleModuleProxy,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V2,
            _MODULE_SINGLE_UPGRADEABLE_V2
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyGetStateSlot(message_);

        // Upgrade to deprecate multi-proxy module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleV3);
        installerProxy.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            multiModuleProxyA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            multiModuleProxyB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        _verifyModuleConfiguration(
            multiModuleProxyC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V3,
            _MODULE_MULTI_UPGRADEABLE_V3
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyGetStateSlot(message_);
    }

    function testUnitProxySentinelFallback() external {
        _testProxySentinelFallback(multiModuleProxyA);
        _testProxySentinelFallback(multiModuleProxyB);
        _testProxySentinelFallback(multiModuleProxyC);
    }

    function testFuzzRevertBytesCustomError(uint256 code_, string memory message_) external {
        _testRevertBytesCustomError(multiModuleProxyA, code_, message_);
        _testRevertBytesCustomError(multiModuleProxyB, code_, message_);
        _testRevertBytesCustomError(multiModuleProxyC, code_, message_);
    }

    function testUnitRevertBytesPanicAssert() external {
        _testRevertBytesPanicAssert(multiModuleProxyA);
        _testRevertBytesPanicAssert(multiModuleProxyB);
        _testRevertBytesPanicAssert(multiModuleProxyC);
    }

    function testUnitRevertBytesPanicDivideByZero() external {
        _testRevertBytesPanicDivideByZero(multiModuleProxyA);
        _testRevertBytesPanicDivideByZero(multiModuleProxyB);
        _testRevertBytesPanicDivideByZero(multiModuleProxyC);
    }

    function testUnitRevertBytesPanicArithmaticOverflow() external {
        _testRevertBytesPanicArithmaticOverflow(multiModuleProxyA);
        _testRevertBytesPanicArithmaticOverflow(multiModuleProxyB);
        _testRevertBytesPanicArithmaticOverflow(multiModuleProxyC);
    }

    function testUnitRevertBytesPanicArithmaticUnderflow() external {
        _testRevertBytesPanicArithmaticUnderflow(multiModuleProxyA);
        _testRevertBytesPanicArithmaticUnderflow(multiModuleProxyB);
        _testRevertBytesPanicArithmaticUnderflow(multiModuleProxyC);
    }

    function testFuzzProxyLog0Topic(bytes memory message_) external {
        _testProxyLog0Topic(multiModuleProxyA, message_);
        _testProxyLog0Topic(multiModuleProxyB, message_);
        _testProxyLog0Topic(multiModuleProxyC, message_);
    }

    function testFuzzProxyLog1Topic(bytes memory message_) external {
        _testProxyLog1Topic(multiModuleProxyA, message_);
        _testProxyLog1Topic(multiModuleProxyB, message_);
        _testProxyLog1Topic(multiModuleProxyC, message_);
    }

    function testFuzzProxyLog2Topic(bytes memory message_) external {
        _testProxyLog2Topic(multiModuleProxyA, message_);
        _testProxyLog2Topic(multiModuleProxyB, message_);
        _testProxyLog2Topic(multiModuleProxyC, message_);
    }

    function testFuzzProxyLog3Topic(bytes memory message_) external {
        _testProxyLog3Topic(multiModuleProxyA, message_);
        _testProxyLog3Topic(multiModuleProxyB, message_);
        _testProxyLog3Topic(multiModuleProxyC, message_);
    }

    function testFuzzProxyLog4Topic(bytes memory message_) external {
        _testProxyLog4Topic(multiModuleProxyA, message_);
        _testProxyLog4Topic(multiModuleProxyB, message_);
        _testProxyLog4Topic(multiModuleProxyC, message_);
    }

    function testFuzzRevertProxyLogOutOfBounds(bytes memory message_) external {
        _testRevertProxyLogOutOfBounds(multiModuleProxyA, message_);
        _testRevertProxyLogOutOfBounds(multiModuleProxyB, message_);
        _testRevertProxyLogOutOfBounds(multiModuleProxyC, message_);
    }

    function testUnitUnpackMessageSender() external {
        vm.startPrank(_users.Alice);
        _testUnpackMessageSender(multiModuleProxyA, _users.Alice);
        _testUnpackMessageSender(multiModuleProxyB, _users.Alice);
        _testUnpackMessageSender(multiModuleProxyC, _users.Alice);
        vm.stopPrank();
    }

    function testUnitUnpackProxyAddress() external {
        _testUnpackProxyAddress(multiModuleProxyA);
        _testUnpackProxyAddress(multiModuleProxyB);
        _testUnpackProxyAddress(multiModuleProxyC);
    }

    function testUnitUnpackTrailingParameters() external {
        vm.startPrank(_users.Alice);
        _testUnpackTrailingParameters(multiModuleProxyA, _users.Alice);
        _testUnpackTrailingParameters(multiModuleProxyB, _users.Alice);
        _testUnpackTrailingParameters(multiModuleProxyC, _users.Alice);
        vm.stopPrank();
    }

    // =========
    // Utilities
    // =========

    function _verifyGetStateSlot(bytes32 message_) internal {
        assertEq(singleModuleV1.getImplementationState0(), 0);
        assertEq(singleModuleV2.getImplementationState0(), 0);
        assertEq(singleModuleProxy.getImplementationState0(), message_);

        assertEq(multiModuleV1.getImplementationState0(), 0);
        assertEq(multiModuleV2.getImplementationState0(), 0);
        assertEq(multiModuleV3.getImplementationState0(), 0);

        assertEq(multiModuleProxyA.getImplementationState0(), message_);
        assertEq(multiModuleProxyB.getImplementationState0(), message_);
        assertEq(multiModuleProxyC.getImplementationState0(), message_);

        assertEq(dispatcher.getImplementationState0(), message_);
    }

    function _verifySetStateSlot(bytes32 message_) internal {
        dispatcher.setImplementationState0(0);

        _verifyGetStateSlot(0);

        dispatcher.setImplementationState0(message_);

        _verifyGetStateSlot(message_);
    }
}
