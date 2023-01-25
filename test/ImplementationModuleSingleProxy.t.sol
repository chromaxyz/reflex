// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TReflexDispatcher} from "../src/interfaces/IReflexDispatcher.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";
import {IReflexProxy} from "../src/interfaces/IReflexProxy.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
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
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V2 = false;
    bool internal constant _MODULE_SINGLE_REMOVEABLE_V1 = true;
    bool internal constant _MODULE_SINGLE_REMOVEABLE_V2 = false;

    // =======
    // Storage
    // =======

    MockImplementationModule public singleModuleV1;
    MockImplementationModule public singleModuleV2;
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
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V1,
                moduleRemoveable: _MODULE_SINGLE_REMOVEABLE_V1
            })
        );

        singleModuleV2 = new MockImplementationModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V2,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V2,
                moduleRemoveable: _MODULE_SINGLE_REMOVEABLE_V2
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
        _testModuleConfiguration(
            singleModuleV1,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V1,
            _MODULE_SINGLE_UPGRADEABLE_V1,
            _MODULE_SINGLE_REMOVEABLE_V1
        );

        _testModuleConfiguration(
            singleModuleProxy,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V1,
            _MODULE_SINGLE_UPGRADEABLE_V1,
            _MODULE_SINGLE_REMOVEABLE_V1
        );
    }

    function testFuzzUpgradeSingleProxy(
        bytes32 message_,
        uint256 number_,
        address location_,
        address tokenA_,
        address tokenB_,
        bool flag_
    ) external BrutalizeMemory {
        singleModuleProxy.setStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
        singleModuleProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);

        _testModuleConfiguration(
            singleModuleProxy,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V1,
            _MODULE_SINGLE_UPGRADEABLE_V1,
            _MODULE_SINGLE_REMOVEABLE_V1
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleV2);
        installerProxy.upgradeModules(moduleAddresses);

        _testModuleConfiguration(
            singleModuleProxy,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION_V2,
            _MODULE_SINGLE_UPGRADEABLE_V2,
            _MODULE_SINGLE_REMOVEABLE_V2
        );

        singleModuleProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
    }

    function testFuzzRemoveSingleProxy(
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
        moduleAddresses[0] = address(singleModuleV1);
        installerProxy.removeModules(moduleAddresses);

        singleModuleV1 = MockImplementationModule(dispatcher.moduleIdToModuleImplementation(_MODULE_SINGLE_ID));

        assertEq(address(singleModuleV1), address(0));

        vm.expectRevert(TReflexDispatcher.CallerNotTrusted.selector);
        singleModuleProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);

        installerProxy.verifyStorageSlots(message_, number_, location_, tokenA_, tokenB_, flag_);
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
}
