// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseModule} from "../src/interfaces/IBaseModule.sol";

// Fixtures
import {Fixture} from "./fixtures/Fixture.sol";

// Mocks
import {MockBaseModule, ICustomError} from "./mocks/MockBaseModule.sol";

/**
 * @title Base Module Test
 */
contract BaseModuleTest is TBaseModule, Fixture {
    // ======
    // Errors
    // ======

    error FailedToLog();

    // =========
    // Constants
    // =========

    uint32 internal constant _MOCK_MODULE_SINGLE_ID = 100;
    uint16 internal constant _MOCK_MODULE_SINGLE_TYPE =
        _PROXY_TYPE_SINGLE_PROXY;
    uint16 internal constant _MOCK_MODULE_SINGLE_VERSION = 1;

    uint32 internal constant _MOCK_MODULE_MULTI_ID = 101;
    uint16 internal constant _MOCK_MODULE_MULTI_TYPE = _PROXY_TYPE_MULTI_PROXY;
    uint16 internal constant _MOCK_MODULE_MULTI_VERSION = 1;

    uint32 internal constant _MOCK_MODULE_INTERNAL_ID = 102;
    uint16 internal constant _MOCK_MODULE_INTERNAL_TYPE =
        _PROXY_TYPE_INTERNAL_PROXY;
    uint16 internal constant _MOCK_MODULE_INTERNAL_VERSION = 1;

    // =======
    // Storage
    // =======

    MockBaseModule public moduleSingle;
    MockBaseModule public moduleSingleProxy;

    MockBaseModule public moduleMulti;
    MockBaseModule public moduleMultiProxy;

    MockBaseModule public moduleInternal;
    MockBaseModule public moduleInternalProxy;

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

        moduleMulti = new MockBaseModule(
            _MOCK_MODULE_MULTI_ID,
            _MOCK_MODULE_MULTI_TYPE,
            _MOCK_MODULE_MULTI_VERSION
        );

        moduleInternal = new MockBaseModule(
            _MOCK_MODULE_INTERNAL_ID,
            _MOCK_MODULE_INTERNAL_TYPE,
            _MOCK_MODULE_INTERNAL_VERSION
        );

        address[] memory moduleAddresses = new address[](3);
        moduleAddresses[0] = address(moduleSingle);
        moduleAddresses[1] = address(moduleMulti);
        moduleAddresses[2] = address(moduleInternal);

        installerProxy.addModules(moduleAddresses);

        moduleSingleProxy = MockBaseModule(
            dispatcher.moduleIdToProxy(_MOCK_MODULE_SINGLE_ID)
        );

        moduleMultiProxy = MockBaseModule(
            dispatcher.moduleIdToProxy(_MOCK_MODULE_MULTI_ID)
        );

        moduleInternalProxy = MockBaseModule(
            dispatcher.moduleIdToProxy(_MOCK_MODULE_INTERNAL_ID)
        );

        // TODO: add multi proxy tests
        // TODO: add internal proxy tests
    }

    // =============
    // General tests
    // =============

    function testModuleId() external {
        assertEq(moduleSingle.moduleId(), _MOCK_MODULE_SINGLE_ID);
        assertEq(moduleMulti.moduleId(), _MOCK_MODULE_MULTI_ID);
        assertEq(moduleInternal.moduleId(), _MOCK_MODULE_INTERNAL_ID);
    }

    function testModuleType() external {
        assertEq(moduleSingle.moduleType(), _MOCK_MODULE_SINGLE_TYPE);
        assertEq(moduleMulti.moduleType(), _MOCK_MODULE_MULTI_TYPE);
        assertEq(moduleInternal.moduleType(), _MOCK_MODULE_INTERNAL_TYPE);
    }

    function testModuleVersion() external {
        assertEq(moduleSingle.moduleVersion(), _MOCK_MODULE_SINGLE_VERSION);
        assertEq(moduleMulti.moduleVersion(), _MOCK_MODULE_MULTI_VERSION);
        assertEq(moduleInternal.moduleVersion(), _MOCK_MODULE_INTERNAL_VERSION);
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
        moduleSingle.testRevertBytesCustomError(code, message);
    }

    function testProxyLog0Topic(bytes memory message_) external {
        vm.assume(message_.length > 0 && message_.length <= 32);

        uint256 messageLength = message_.length;
        bytes32 message = bytes32(abi.encodePacked(message_));

        // TODO: investigate how log0 + vm.expectEmit could work
        // vm.expectEmit(false, false, false, false, address(moduleSingleProxy));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log0(ptr, messageLength)
        }

        moduleSingleProxy.testProxyLog0Topic(message_);
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

    // ==================
    // Single-proxy tests
    // ==================

    // =================
    // Multi-proxy tests
    // =================

    // ====================
    // Internal-proxy tests
    // ====================
}
