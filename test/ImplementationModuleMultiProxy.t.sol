// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";
import {IReflexProxy} from "../src/interfaces/IReflexProxy.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {ImplementationERC20} from "./mocks/abstracts/ImplementationERC20.sol";
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
    uint16 internal constant _MODULE_SINGLE_VERSION = 1;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE = true;
    bool internal constant _MODULE_SINGLE_REMOVEABLE = true;

    uint32 internal constant _MODULE_MULTI_ID = 101;
    uint16 internal constant _MODULE_MULTI_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _MODULE_MULTI_VERSION_V1 = 1;
    uint16 internal constant _MODULE_MULTI_VERSION_V2 = 2;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V2 = false;
    bool internal constant _MODULE_MULTI_REMOVEABLE_V1 = true;
    bool internal constant _MODULE_MULTI_REMOVEABLE_V2 = false;

    string internal constant _MODULE_MULTI_NAME_A = "TOKEN A";
    string internal constant _MODULE_MULTI_SYMBOL_A = "TKNA";
    uint8 internal constant _MODULE_MULTI_DECIMALS_A = 18;

    string internal constant _MODULE_MULTI_NAME_B = "TOKEN B";
    string internal constant _MODULE_MULTI_SYMBOL_B = "TKNB";
    uint8 internal constant _MODULE_MULTI_DECIMALS_B = 6;

    string internal constant _MODULE_MULTI_NAME_C = "TOKEN C";
    string internal constant _MODULE_MULTI_SYMBOL_C = "TKNC";
    uint8 internal constant _MODULE_MULTI_DECIMALS_C = 8;

    // =======
    // Storage
    // =======

    MockImplementationERC20Hub public singleModule;
    MockImplementationERC20Hub public singleModuleProxy;

    MockImplementationERC20 public multiModuleV1;
    MockImplementationERC20 public multiModuleV2;

    MockImplementationERC20 public multiModuleProxyA;
    MockImplementationERC20 public multiModuleProxyB;
    MockImplementationERC20 public multiModuleProxyC;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModule = new MockImplementationERC20Hub(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE,
                moduleRemoveable: _MODULE_SINGLE_REMOVEABLE
            })
        );

        multiModuleV1 = new MockImplementationERC20(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V1,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V1,
                moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V1
            })
        );

        multiModuleV2 = new MockImplementationERC20(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V2,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V2,
                moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V2
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModule);
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

    // ==========
    // Invariants
    // ==========

    function invariantMetadata() external {
        assertEq(multiModuleProxyA.name(), _MODULE_MULTI_NAME_A);
        assertEq(multiModuleProxyA.symbol(), _MODULE_MULTI_SYMBOL_A);
        assertEq(multiModuleProxyA.decimals(), _MODULE_MULTI_DECIMALS_A);

        assertEq(multiModuleProxyB.name(), _MODULE_MULTI_NAME_B);
        assertEq(multiModuleProxyB.symbol(), _MODULE_MULTI_SYMBOL_B);
        assertEq(multiModuleProxyB.decimals(), _MODULE_MULTI_DECIMALS_B);

        assertEq(multiModuleProxyC.name(), _MODULE_MULTI_NAME_C);
        assertEq(multiModuleProxyC.symbol(), _MODULE_MULTI_SYMBOL_C);
        assertEq(multiModuleProxyC.decimals(), _MODULE_MULTI_DECIMALS_C);
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
        _testModuleConfiguration(
            multiModuleV1,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1,
            _MODULE_MULTI_REMOVEABLE_V1
        );

        _testModuleConfiguration(
            multiModuleV2,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2,
            _MODULE_MULTI_REMOVEABLE_V2
        );
    }

    function testUnitUpgradeMultiProxySingleImplementation() external {
        _testModuleConfiguration(
            multiModuleProxyA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1,
            _MODULE_MULTI_REMOVEABLE_V1
        );

        _testModuleConfiguration(
            multiModuleProxyB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1,
            _MODULE_MULTI_REMOVEABLE_V1
        );

        _testModuleConfiguration(
            multiModuleProxyC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1,
            _MODULE_MULTI_REMOVEABLE_V1
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleV2);
        installerProxy.upgradeModules(moduleAddresses);

        _testModuleConfiguration(
            multiModuleProxyA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2,
            _MODULE_MULTI_REMOVEABLE_V2
        );

        _testModuleConfiguration(
            multiModuleProxyB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2,
            _MODULE_MULTI_REMOVEABLE_V2
        );

        _testModuleConfiguration(
            multiModuleProxyC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2,
            _MODULE_MULTI_REMOVEABLE_V2
        );
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
}
