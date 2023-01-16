// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {stdError} from "forge-std/StdError.sol";
import {Vm} from "forge-std/Vm.sol";

// Sources
import {BaseConstants} from "../../src/BaseConstants.sol";

// Interfaces
import {IBaseModule, TBaseModule} from "../../src/interfaces/IBaseModule.sol";

// Implementations
import {ImplementationDispatcher} from "../implementations/ImplementationDispatcher.sol";
import {ImplementationInstaller} from "../implementations/ImplementationInstaller.sol";

// Fixtures
import {Harness} from "./Harness.sol";

// Mocks
import {MockBaseModule, ICustomError} from "../mocks/MockBaseModule.sol";

/**
 * @title Implementation Fixture
 */
abstract contract ImplementationFixture is BaseConstants, Harness {
    // =======
    // Storage
    // =======

    ImplementationInstaller public installer;
    ImplementationDispatcher public dispatcher;
    ImplementationInstaller public installerProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        installer = new ImplementationInstaller(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: 1,
                moduleUpgradeable: true,
                moduleRemoveable: false
            })
        );
        dispatcher = new ImplementationDispatcher(address(this), address(installer));
        installerProxy = ImplementationInstaller(dispatcher.moduleIdToProxy(_MODULE_ID_INSTALLER));
    }

    // ==========
    // Test stubs
    // ==========

    function _testModuleConfiguration(
        MockBaseModule module_,
        uint32 moduleId_,
        uint16 moduleType_,
        uint32 moduleVersion_,
        bool moduleUpgradeable_,
        bool moduleRemoveable_
    ) internal {
        IBaseModule.ModuleSettings memory moduleSettings = module_.moduleSettings();

        assertEq(moduleSettings.moduleId, moduleId_);
        assertEq(module_.moduleId(), moduleId_);
        assertEq(moduleSettings.moduleType, moduleType_);
        assertEq(module_.moduleType(), moduleType_);
        assertEq(moduleSettings.moduleVersion, moduleVersion_);
        assertEq(module_.moduleVersion(), moduleVersion_);
        assertEq(moduleSettings.moduleUpgradeable, moduleUpgradeable_);
        assertEq(module_.moduleUpgradeable(), moduleUpgradeable_);
        assertEq(moduleSettings.moduleRemoveable, moduleRemoveable_);
        assertEq(module_.moduleRemoveable(), moduleRemoveable_);
    }

    function _testProxySentinelFallback(MockBaseModule proxy_) internal {
        (bool success, bytes memory data) = address(proxy_).call(abi.encodeWithSignature("sentinel()"));

        assertTrue(success);
        assertTrue(abi.decode(data, (bool)));
    }

    function _testRevertBytesCustomError(MockBaseModule proxy_, uint256 code_, string memory message_) internal {
        vm.expectRevert(
            abi.encodeWithSelector(
                ICustomError.CustomError.selector,
                ICustomError.CustomErrorPayload({code: code_, message: message_})
            )
        );
        proxy_.testRevertBytesCustomError(code_, message_);
    }

    function _testRevertBytesPanicAssert(MockBaseModule proxy_) internal {
        vm.expectRevert(stdError.assertionError);
        proxy_.testRevertPanicAssert();
    }

    function _testRevertBytesPanicDivideByZero(MockBaseModule proxy_) internal {
        vm.expectRevert(stdError.divisionError);
        proxy_.testRevertPanicDivisionByZero();
    }

    function _testRevertBytesPanicArithmaticOverflow(MockBaseModule proxy_) internal {
        vm.expectRevert(stdError.arithmeticError);
        proxy_.testRevertPanicArithmeticOverflow();
    }

    function _testRevertBytesPanicArithmaticUnderflow(MockBaseModule proxy_) internal {
        vm.expectRevert(stdError.arithmeticError);
        proxy_.testRevertPanicArithmeticUnderflow();
    }

    function _testProxyLog0Topic(MockBaseModule proxy_, bytes memory message_) internal BrutalizeMemory {
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

        proxy_.testProxyLog0Topic(message_);

        Vm.Log[] memory entries = vm.getRecordedLogs();

        assertEq(entries.length, 1);
        assertEq(entries[0].topics.length, 0);
        assertEq(entries[0].data, message_);
        assertEq(entries[0].emitter, address(proxy_));
    }

    function _testProxyLog1Topic(MockBaseModule proxy_, bytes memory message_) internal BrutalizeMemory {
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
        proxy_.testProxyLog1Topic(message_);
    }

    function _testProxyLog2Topic(MockBaseModule proxy_, bytes memory message_) internal BrutalizeMemory {
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
        proxy_.testProxyLog2Topic(message_);
    }

    function _testProxyLog3Topic(MockBaseModule proxy_, bytes memory message_) internal BrutalizeMemory {
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
        proxy_.testProxyLog3Topic(message_);
    }

    function _testProxyLog4Topic(MockBaseModule proxy_, bytes memory message_) internal BrutalizeMemory {
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
        proxy_.testProxyLog4Topic(message_);
    }

    function _testRevertProxyLogOutOfBounds(MockBaseModule proxy_, bytes memory message_) internal BrutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        vm.expectRevert(MockBaseModule.FailedToLog.selector);
        proxy_.testRevertProxyLogOutOfBounds(message_);
    }
}
