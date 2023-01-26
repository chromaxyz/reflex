// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {stdError} from "forge-std/StdError.sol";
import {VmSafe} from "forge-std/Vm.sol";

// Sources
import {ReflexConstants} from "../../src/ReflexConstants.sol";

// Interfaces
import {IReflexModule, TReflexModule} from "../../src/interfaces/IReflexModule.sol";

// Fixtures
import {TestHarness} from "./TestHarness.sol";

// Mocks
import {MockImplementationDispatcher} from "../mocks/MockImplementationDispatcher.sol";
import {MockImplementationInstaller} from "../mocks/MockImplementationInstaller.sol";
import {MockImplementationState} from "../mocks/MockImplementationState.sol";
import {MockReflexModule, ICustomError} from "../mocks/MockReflexModule.sol";

/**
 * @title Implementation Fixture
 */
abstract contract ImplementationFixture is ReflexConstants, TestHarness {
    // =======
    // Storage
    // =======

    MockImplementationDispatcher public dispatcher;

    MockImplementationInstaller public installer;
    MockImplementationInstaller public installerProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        installer = new MockImplementationInstaller(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: 1,
                moduleUpgradeable: true
            })
        );
        dispatcher = new MockImplementationDispatcher(address(this), address(installer));
        installerProxy = MockImplementationInstaller(dispatcher.moduleIdToProxy(_MODULE_ID_INSTALLER));
    }

    // ==========
    // Test stubs
    // ==========

    function _testModuleConfiguration(
        MockReflexModule module_,
        uint32 moduleId_,
        uint16 moduleType_,
        uint32 moduleVersion_,
        bool moduleUpgradeable_
    ) internal {
        IReflexModule.ModuleSettings memory moduleSettings = module_.moduleSettings();

        assertEq(moduleSettings.moduleId, moduleId_);
        assertEq(module_.moduleId(), moduleId_);
        assertEq(moduleSettings.moduleType, moduleType_);
        assertEq(module_.moduleType(), moduleType_);
        assertEq(moduleSettings.moduleVersion, moduleVersion_);
        assertEq(module_.moduleVersion(), moduleVersion_);
        assertEq(moduleSettings.moduleUpgradeable, moduleUpgradeable_);
        assertEq(module_.moduleUpgradeable(), moduleUpgradeable_);
    }

    function _testProxySentinelFallback(MockReflexModule proxy_) internal {
        (bool success, bytes memory data) = address(proxy_).call(abi.encodeWithSignature("sentinel()"));

        assertTrue(success);
        assertTrue(abi.decode(data, (bool)));
    }

    function _testRevertBytesCustomError(MockReflexModule proxy_, uint256 code_, string memory message_) internal {
        vm.expectRevert(
            abi.encodeWithSelector(
                ICustomError.CustomError.selector,
                ICustomError.CustomErrorPayload({code: code_, message: message_})
            )
        );
        proxy_.testUnitRevertBytesCustomError(code_, message_);
    }

    function _testRevertBytesPanicAssert(MockReflexModule proxy_) internal {
        vm.expectRevert(stdError.assertionError);
        proxy_.testUnitRevertPanicAssert();
    }

    function _testRevertBytesPanicDivideByZero(MockReflexModule proxy_) internal {
        vm.expectRevert(stdError.divisionError);
        proxy_.testUnitRevertPanicDivisionByZero();
    }

    function _testRevertBytesPanicArithmaticOverflow(MockReflexModule proxy_) internal {
        vm.expectRevert(stdError.arithmeticError);
        proxy_.testUnitRevertPanicArithmeticOverflow();
    }

    function _testRevertBytesPanicArithmaticUnderflow(MockReflexModule proxy_) internal {
        vm.expectRevert(stdError.arithmeticError);
        proxy_.testUnitRevertPanicArithmeticUnderflow();
    }

    function _testProxyLog0Topic(MockReflexModule proxy_, bytes memory message_) internal BrutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        uint256 messageLength = message_.length;
        bytes32 message = bytes32(abi.encodePacked(message_));

        // NOTE: vm.expectEmit does not work as topic1 is checked implicitly.
        // Therefore a workaround using record logs is being used to check manually.
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log0(ptr, messageLength)
        }

        vm.recordLogs();

        proxy_.testFuzzProxyLog0Topic(message_);

        VmSafe.Log[] memory entries = vm.getRecordedLogs();

        assertEq(entries.length, 1);
        assertEq(entries[0].topics.length, 0);
        assertEq(entries[0].data, message_);
        assertEq(entries[0].emitter, address(proxy_));
    }

    function _testProxyLog1Topic(MockReflexModule proxy_, bytes memory message_) internal BrutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));

        vm.expectEmit(false, false, false, true, address(proxy_));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log1(ptr, messageLength, topic1)
        }
        proxy_.testFuzzProxyLog1Topic(message_);
    }

    function _testProxyLog2Topic(MockReflexModule proxy_, bytes memory message_) internal BrutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));
        bytes32 topic2 = bytes32(uint256(2));

        vm.expectEmit(true, false, false, true, address(proxy_));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log2(ptr, messageLength, topic1, topic2)
        }
        proxy_.testFuzzProxyLog2Topic(message_);
    }

    function _testProxyLog3Topic(MockReflexModule proxy_, bytes memory message_) internal BrutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));
        bytes32 topic2 = bytes32(uint256(2));
        bytes32 topic3 = bytes32(uint256(3));

        vm.expectEmit(true, true, false, true, address(proxy_));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log3(ptr, messageLength, topic1, topic2, topic3)
        }
        proxy_.testFuzzProxyLog3Topic(message_);
    }

    function _testProxyLog4Topic(MockReflexModule proxy_, bytes memory message_) internal BrutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));
        bytes32 topic2 = bytes32(uint256(2));
        bytes32 topic3 = bytes32(uint256(3));
        bytes32 topic4 = bytes32(uint256(4));

        vm.expectEmit(true, true, true, true, address(proxy_));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log4(ptr, messageLength, topic1, topic2, topic3, topic4)
        }
        proxy_.testFuzzProxyLog4Topic(message_);
    }

    function _testRevertProxyLogOutOfBounds(MockReflexModule proxy_, bytes memory message_) internal BrutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        vm.expectRevert(MockReflexModule.FailedToLog.selector);
        proxy_.testUnitRevertProxyLogOutOfBounds(message_);
    }

    function _testUnpackMessageSender(MockReflexModule proxy_, address sender_) internal BrutalizeMemory {
        address messageSender = proxy_.testUnitUnpackMessageSender();

        assertEq(messageSender, sender_);
    }

    function _testUnpackProxyAddress(MockReflexModule proxy_) internal BrutalizeMemory {
        address proxyAddress = proxy_.testUnitUnpackProxyAddress();

        assertEq(proxyAddress, address(proxy_));
    }

    function _testUnpackTrailingParameters(MockReflexModule proxy_, address sender_) internal BrutalizeMemory {
        (address messageSender, address proxyAddress) = proxy_.testUnitUnpackTrailingParameters();

        assertEq(messageSender, sender_);
        assertEq(proxyAddress, address(proxy_));
    }
}
