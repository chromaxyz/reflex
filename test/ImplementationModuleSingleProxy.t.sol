// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";
import {IReflexProxy} from "../src/interfaces/IReflexProxy.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockReflexModule} from "./mocks/MockReflexModule.sol";

/**
 * @title Implementation Module Single Proxy Test
 */
contract ImplementationModuleSingleProxyTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION = 1;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE = true;
    bool internal constant _MODULE_SINGLE_REMOVEABLE = true;

    // =======
    // Storage
    // =======

    MockReflexModule public singleModule;
    MockReflexModule public singleModuleProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModule = new MockReflexModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModule);
        installerProxy.addModules(moduleAddresses);

        singleModuleProxy = MockReflexModule(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID));
    }

    // =====
    // Tests
    // =====

    function testUnitModuleIdToImplementation() external {
        assertEq(dispatcher.moduleIdToModuleImplementation(_MODULE_SINGLE_ID), address(singleModule));
        assertEq(IReflexProxy(address(singleModuleProxy)).implementation(), address(singleModule));
    }

    function testUnitModuleIdToProxy() external {
        assertTrue(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID) != address(0));
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
            singleModuleProxy,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION,
            _MODULE_SINGLE_UPGRADEABLE,
            _MODULE_SINGLE_REMOVEABLE
        );
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
