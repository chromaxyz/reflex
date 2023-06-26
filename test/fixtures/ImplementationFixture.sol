// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
import {stdError} from "forge-std/StdError.sol";
import {VmSafe} from "forge-std/Vm.sol";

// Sources
import {ReflexConstants} from "../../src/ReflexConstants.sol";

// Interfaces
import {IReflexModule} from "../../src/interfaces/IReflexModule.sol";

// Fixtures
import {TestHarness} from "./TestHarness.sol";
import {MockHarness} from "./MockHarness.sol";

// Mocks
import {MockImplementationDispatcher} from "../mocks/MockImplementationDispatcher.sol";
import {MockImplementationInstaller} from "../mocks/MockImplementationInstaller.sol";
import {MockReflexModule, ICustomError} from "../mocks/MockReflexModule.sol";

/**
 * @title Implementation Fixture
 */
abstract contract ImplementationFixture is ReflexConstants, TestHarness, MockHarness {
    // =======
    // Storage
    // =======

    MockImplementationDispatcher public dispatcher;

    MockImplementationInstaller public installer;
    MockImplementationInstaller public installerEndpoint;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        installer = new MockImplementationInstaller(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_ENDPOINT,
                moduleVersion: 1,
                moduleUpgradeable: true
            })
        );
        dispatcher = new MockImplementationDispatcher(address(this), address(installer));
        installerEndpoint = MockImplementationInstaller(dispatcher.getEndpoint(_MODULE_ID_INSTALLER));
    }

    // ==========
    // Test stubs
    // ==========

    function _verifyModuleConfiguration(
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

    function _testRevertBytesCustomError(MockReflexModule endpoint_, uint256 code_, string memory message_) internal {
        vm.expectRevert(
            abi.encodeWithSelector(
                ICustomError.CustomError.selector,
                ICustomError.CustomErrorPayload({code: code_, message: message_})
            )
        );
        endpoint_.revertBytesCustomError(code_, message_);
    }

    function _testRevertBytesPanicAssert(MockReflexModule endpoint_) internal {
        vm.expectRevert(stdError.assertionError);
        endpoint_.revertPanicAssert();
    }

    function _testRevertBytesPanicDivideByZero(MockReflexModule endpoint_) internal {
        vm.expectRevert(stdError.divisionError);
        endpoint_.revertPanicDivisionByZero();
    }

    function _testRevertBytesPanicArithmaticOverflow(MockReflexModule endpoint_) internal {
        vm.expectRevert(stdError.arithmeticError);
        endpoint_.revertPanicArithmeticOverflow();
    }

    function _testRevertBytesPanicArithmaticUnderflow(MockReflexModule endpoint_) internal {
        vm.expectRevert(stdError.arithmeticError);
        endpoint_.revertPanicArithmeticUnderflow();
    }

    function _testEndpointLog0Topic(MockReflexModule endpoint_, bytes memory message_) internal brutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        uint256 messageLength = message_.length;
        bytes32 message = bytes32(abi.encodePacked(message_));

        // NOTE: vm.expectEmit does not work as topic1 is checked implicitly.
        // Therefore a workaround using record logs is being used to check manually.
        assembly ("memory-safe") {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log0(ptr, messageLength)
        }

        vm.recordLogs();

        endpoint_.endpointLog0Topic(message_);

        VmSafe.Log[] memory entries = vm.getRecordedLogs();

        assertEq(entries.length, 1);
        assertEq(entries[0].topics.length, 0);
        assertEq(entries[0].data, message_);
        assertEq(entries[0].emitter, address(endpoint_));
    }

    function _testEndpointLog1Topic(MockReflexModule endpoint_, bytes memory message_) internal brutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));

        vm.expectEmit(false, false, false, true, address(endpoint_));
        assembly ("memory-safe") {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log1(ptr, messageLength, topic1)
        }
        endpoint_.endpointLog1Topic(message_);
    }

    function _testEndpointLog2Topic(MockReflexModule endpoint_, bytes memory message_) internal brutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));
        bytes32 topic2 = bytes32(uint256(2));

        vm.expectEmit(true, false, false, true, address(endpoint_));
        assembly ("memory-safe") {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log2(ptr, messageLength, topic1, topic2)
        }
        endpoint_.endpointLog2Topic(message_);
    }

    function _testEndpointLog3Topic(MockReflexModule endpoint_, bytes memory message_) internal brutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));
        bytes32 topic2 = bytes32(uint256(2));
        bytes32 topic3 = bytes32(uint256(3));

        vm.expectEmit(true, true, false, true, address(endpoint_));
        assembly ("memory-safe") {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log3(ptr, messageLength, topic1, topic2, topic3)
        }
        endpoint_.endpointLog3Topic(message_);
    }

    function _testEndpointLog4Topic(MockReflexModule endpoint_, bytes memory message_) internal brutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));
        bytes32 topic2 = bytes32(uint256(2));
        bytes32 topic3 = bytes32(uint256(3));
        bytes32 topic4 = bytes32(uint256(4));

        vm.expectEmit(true, true, true, true, address(endpoint_));
        assembly ("memory-safe") {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log4(ptr, messageLength, topic1, topic2, topic3, topic4)
        }
        endpoint_.endpointLog4Topic(message_);
    }

    function _testRevertEndpointLogOutOfBounds(
        MockReflexModule endpoint_,
        bytes memory message_
    ) internal brutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        vm.expectRevert(MockReflexModule.FailedToLog.selector);
        endpoint_.revertEndpointLogOutOfBounds(message_);
    }

    function _testUnpackMessageSender(MockReflexModule endpoint_, address sender_) internal brutalizeMemory {
        assertEq(endpoint_.unpackMessageSender(), sender_);
    }

    function _testUnpackEndpointAddress(MockReflexModule endpoint_) internal brutalizeMemory {
        address endpointAddress = endpoint_.unpackEndpointAddress();

        assertEq(endpointAddress, address(endpoint_));
    }

    function _testUnpackTrailingParameters(MockReflexModule endpoint_, address sender_) internal brutalizeMemory {
        (address messageSender, address endpointAddress) = endpoint_.unpackTrailingParameters();

        assertEq(messageSender, sender_);
        assertEq(endpointAddress, address(endpoint_));
    }
}
