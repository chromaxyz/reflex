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

    // =====
    // Tests
    // =====

    function testModuleId() external {
        assertEq(moduleSingle.moduleId(), _MOCK_MODULE_SINGLE_ID);
    }

    function testModuleType() external {
        assertEq(moduleSingle.moduleType(), _MOCK_MODULE_SINGLE_TYPE);
    }

    function testModuleVersion() external {
        assertEq(moduleSingle.moduleVersion(), _MOCK_MODULE_SINGLE_VERSION);
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

    function testProxyLog0Topic() external {
        bytes32 message = bytes32(abi.encodePacked("hello"));

        assembly {
            mstore(0x00, message)
            log0(0x00, 0x05)
        }

        moduleSingleProxy.testProxyLog0Topic();
    }

    function testProxyLog1Topic() external {
        vm.expectEmit(false, false, false, false);

        bytes32 message = bytes32(abi.encodePacked("hello"));
        bytes32 message1 = bytes32(uint256(1));

        assembly {
            mstore(0x00, message)
            log1(0x00, 0x05, message1)
        }

        moduleSingleProxy.testProxyLog1Topic();
    }

    function testProxyLog2Topic() external {
        vm.expectEmit(true, false, false, false);

        bytes32 message = bytes32(abi.encodePacked("hello"));
        bytes32 message1 = bytes32(uint256(1));
        bytes32 message2 = bytes32(uint256(2));

        assembly {
            mstore(0x00, message)
            log2(0x00, 0x05, message1, message2)
        }

        moduleSingleProxy.testProxyLog2Topic();
    }

    function testProxyLog3Topic() external {
        vm.expectEmit(true, true, false, false);

        bytes32 message = bytes32(abi.encodePacked("hello"));
        bytes32 message1 = bytes32(uint256(1));
        bytes32 message2 = bytes32(uint256(2));
        bytes32 message3 = bytes32(uint256(3));

        assembly {
            mstore(0x00, message)
            log3(0x00, 0x05, message1, message2, message3)
        }

        moduleSingleProxy.testProxyLog3Topic();
    }

    function testProxyLog4Topic() external {
        vm.expectEmit(true, true, true, false);

        bytes32 message = bytes32(abi.encodePacked("hello"));
        bytes32 message1 = bytes32(uint256(1));
        bytes32 message2 = bytes32(uint256(2));
        bytes32 message3 = bytes32(uint256(3));
        bytes32 message4 = bytes32(uint256(4));

        assembly {
            mstore(0x00, message)
            log4(0x00, 0x05, message1, message2, message3, message4)
        }

        moduleSingleProxy.testProxyLog4Topic();
    }

    function testRevertProxyLogOutOfBounds() external {
        vm.expectRevert(FailedToLog.selector);
        moduleSingleProxy.testRevertProxyLogOutOfBounds();
    }
}
