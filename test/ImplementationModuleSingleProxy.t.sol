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
import {MockImplementationMaliciousModule} from "./mocks/MockImplementationMaliciousModule.sol";
import {MockImplementationModule} from "./mocks/MockImplementationModule.sol";

/**
 * @title Implementation Module Single Proxy Test
 */
contract ImplementationModuleSingleProxyTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION_V1 = 1;
    uint16 internal constant _MODULE_SINGLE_VERSION_V2 = 2;
    uint16 internal constant _MODULE_SINGLE_VERSION_V3 = 3;
    uint16 internal constant _MODULE_SINGLE_VERSION_V4 = 3;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V2 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V3 = false;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V4 = false;

    // =======
    // Storage
    // =======

    MockImplementationModule public singleModuleV1;
    MockImplementationModule public singleModuleV2;
    MockImplementationDeprecatedModule public singleModuleV3;
    MockImplementationMaliciousModule public singleModuleV4;
    MockImplementationModule public singleModuleProxy;

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

        singleModuleV3 = new MockImplementationDeprecatedModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V3,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V3
            })
        );

        singleModuleV4 = new MockImplementationMaliciousModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V4,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V4
            })
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV1);
        installerProxy.addModules(moduleAddresses);

        singleModuleProxy = MockImplementationModule(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID));
    }

    // =====
    // Tests
    // =====

    function testUnitModuleIdToImplementation() external {
        assertEq(dispatcher.moduleIdToModuleImplementation(_MODULE_SINGLE_ID), address(singleModuleV1));
        assertEq(IReflexProxy(address(singleModuleProxy)).implementation(), address(singleModuleV1));
    }

    function testUnitModuleIdToProxy() external {
        assertTrue(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID) != address(0));
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
            singleModuleV4,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V4,
            _MODULE_SINGLE_UPGRADEABLE_V4
        );
    }

    function testFuzzUpgradeSingleProxyAndDeprecate(bytes32 message_) external {
        // Verify storage sets in `Dispatcher` context.

        _verifySetStateSlot(message_);

        // Verify single-proxy module.

        _verifyModuleConfiguration(
            singleModuleProxy,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V1,
            _MODULE_SINGLE_UPGRADEABLE_V1
        );

        // Upgrade single-proxy module.

        address[] memory moduleAddresses = new address[](1);
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

        // Upgrade to deprecate single-proxy module.

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV3);
        installerProxy.upgradeModules(moduleAddresses);

        _verifyModuleConfiguration(
            singleModuleProxy,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V3,
            _MODULE_SINGLE_UPGRADEABLE_V3
        );

        // Verify storage is not modified by upgrades in `Dispatcher` context.

        _verifyGetStateSlot(message_);
    }

    function testUnitProxySentinelFallback() external {
        _testProxySentinelFallback(singleModuleProxy);
    }

    function testFuzzRevertBytesCustomError(uint256 code_, string memory message_) external {
        _testRevertBytesCustomError(singleModuleProxy, code_, message_);
    }

    function testUnitRevertBytesPanicAssert() external {
        _testRevertBytesPanicAssert(singleModuleProxy);
    }

    function testUnitRevertBytesPanicDivideByZero() external {
        _testRevertBytesPanicDivideByZero(singleModuleProxy);
    }

    function testUnitRevertBytesPanicArithmaticOverflow() external {
        _testRevertBytesPanicArithmaticOverflow(singleModuleProxy);
    }

    function testUnitRevertBytesPanicArithmaticUnderflow() external {
        _testRevertBytesPanicArithmaticUnderflow(singleModuleProxy);
    }

    function testFuzzProxyLog0Topic(bytes memory message_) external {
        _testProxyLog0Topic(singleModuleProxy, message_);
    }

    function testFuzzProxyLog1Topic(bytes memory message_) external {
        _testProxyLog1Topic(singleModuleProxy, message_);
    }

    function testFuzzProxyLog2Topic(bytes memory message_) external {
        _testProxyLog2Topic(singleModuleProxy, message_);
    }

    function testFuzzProxyLog3Topic(bytes memory message_) external {
        _testProxyLog3Topic(singleModuleProxy, message_);
    }

    function testFuzzProxyLog4Topic(bytes memory message_) external {
        _testProxyLog4Topic(singleModuleProxy, message_);
    }

    function testFuzzRevertProxyLogOutOfBounds(bytes memory message_) external {
        _testRevertProxyLogOutOfBounds(singleModuleProxy, message_);
    }

    function testUnitUnpackMessageSender() external {
        vm.startPrank(_users.Alice);
        _testUnpackMessageSender(singleModuleProxy, _users.Alice);
        vm.stopPrank();
    }

    function testUnitUnpackProxyAddress() external {
        _testUnpackProxyAddress(singleModuleProxy);
    }

    function testUnitUnpackTrailingParameters() external {
        vm.startPrank(_users.Alice);
        _testUnpackTrailingParameters(singleModuleProxy, _users.Alice);
        vm.stopPrank();
    }

    // =========
    // Utilities
    // =========

    function _verifyGetStateSlot(bytes32 message_) internal {
        assertEq((singleModuleV1).getImplementationState0(), 0);
        assertEq((singleModuleV2).getImplementationState0(), 0);
        assertEq(singleModuleProxy.getImplementationState0(), message_);

        assertEq(dispatcher.getImplementationState0(), message_);
    }

    function _verifySetStateSlot(bytes32 message_) internal {
        dispatcher.setImplementationState0(0);

        _verifyGetStateSlot(0);

        dispatcher.setImplementationState0(message_);

        _verifyGetStateSlot(message_);
    }
}
