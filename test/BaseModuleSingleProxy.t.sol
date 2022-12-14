// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {Vm} from "forge-std/Vm.sol";

// Interfaces
import {TBaseModule} from "../src/interfaces/IBaseModule.sol";

// Fixtures
import {Fixture} from "./fixtures/Fixture.sol";

// Mocks
import {MockBaseModule, ICustomError} from "./mocks/MockBaseModule.sol";

/**
 * @title Base Module Single Proxy Test
 */
contract BaseModuleSingleProxyTest is TBaseModule, Fixture {
    // ======
    // Errors
    // ======

    error FailedToLog();

    // =========
    // Constants
    // =========

    uint32 internal constant _MOCK_MODULE_SINGLE_ID = 100;
    uint16 internal constant _MOCK_MODULE_SINGLE_TYPE =
        _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MOCK_MODULE_SINGLE_VERSION = 1;

    // =======
    // Storage
    // =======

    MockBaseModule public moduleSingle;
    MockBaseModule public moduleSingleProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        moduleSingle = new MockBaseModule(
            _MOCK_MODULE_SINGLE_ID,
            _MOCK_MODULE_SINGLE_TYPE,
            _MOCK_MODULE_SINGLE_VERSION
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(moduleSingle);
        installerProxy.addModules(moduleAddresses);

        moduleSingleProxy = MockBaseModule(
            dispatcher.moduleIdToProxy(_MOCK_MODULE_SINGLE_ID)
        );
    }

    // =====
    // Tests
    // =====

    function testModuleId() external {
        assertEq(moduleSingle.moduleId(), _MOCK_MODULE_SINGLE_ID);
        assertEq(moduleSingleProxy.moduleId(), _MOCK_MODULE_SINGLE_ID);
    }

    function testModuleType() external {
        assertEq(moduleSingle.moduleType(), _MOCK_MODULE_SINGLE_TYPE);
        assertEq(moduleSingleProxy.moduleType(), _MOCK_MODULE_SINGLE_TYPE);
    }

    function testModuleVersion() external {
        assertEq(moduleSingle.moduleVersion(), _MOCK_MODULE_SINGLE_VERSION);
        assertEq(
            moduleSingleProxy.moduleVersion(),
            _MOCK_MODULE_SINGLE_VERSION
        );
    }

    function testModuleSingleProxyNonZeroAddress() external {
        assertTrue(
            dispatcher.moduleIdToProxy(_MOCK_MODULE_SINGLE_ID) != address(0)
        );
    }

    function testModuleSingleProxyImplementation() external {
        assertTrue(
            dispatcher.moduleIdToImplementation(_MOCK_MODULE_SINGLE_ID) ==
                address(moduleSingle)
        );
    }

    function testRevertBytesCustomError(
        uint256 code,
        string memory message
    ) external {
        vm.expectRevert(
            abi.encodeWithSelector(
                ICustomError.CustomError.selector,
                ICustomError.CustomErrorPayload({code: code, message: message})
            )
        );
        moduleSingleProxy.testRevertBytesCustomError(code, message);
    }

    function testProxyLog0Topic(bytes memory message_) external {
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

        moduleSingleProxy.testProxyLog0Topic(message_);

        Vm.Log[] memory entries = vm.getRecordedLogs();

        assertEq(entries.length, 1);
        assertEq(entries[0].topics.length, 0);
        assertEq(entries[0].data, message_);
        assertEq(entries[0].emitter, address(moduleSingleProxy));
    }

    function testProxyLog1Topic(bytes memory message_) external {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));

        vm.expectEmit(false, false, false, true, address(moduleSingleProxy));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log1(ptr, messageLength, topic1)
        }
        moduleSingleProxy.testProxyLog1Topic(message_);
    }

    function testProxyLog2Topic(bytes memory message_) external {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));
        bytes32 topic2 = bytes32(uint256(2));

        vm.expectEmit(true, false, false, true, address(moduleSingleProxy));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log2(ptr, messageLength, topic1, topic2)
        }
        moduleSingleProxy.testProxyLog2Topic(message_);
    }

    function testProxyLog3Topic(bytes memory message_) external {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));
        bytes32 topic2 = bytes32(uint256(2));
        bytes32 topic3 = bytes32(uint256(3));

        vm.expectEmit(true, true, false, true, address(moduleSingleProxy));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log3(ptr, messageLength, topic1, topic2, topic3)
        }
        moduleSingleProxy.testProxyLog3Topic(message_);
    }

    function testProxyLog4Topic(bytes memory message_) external {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));
        bytes32 topic2 = bytes32(uint256(2));
        bytes32 topic3 = bytes32(uint256(3));
        bytes32 topic4 = bytes32(uint256(4));

        vm.expectEmit(true, true, true, true, address(moduleSingleProxy));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log4(ptr, messageLength, topic1, topic2, topic3, topic4)
        }
        moduleSingleProxy.testProxyLog4Topic(message_);
    }

    function testRevertProxyLogOutOfBounds(bytes memory message_) external {
        vm.assume(message_.length > 0);

        vm.expectRevert(FailedToLog.selector);
        moduleSingleProxy.testRevertProxyLogOutOfBounds(message_);
    }
}
