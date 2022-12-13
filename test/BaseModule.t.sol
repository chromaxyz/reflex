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

    uint32 internal constant _MOCK_MODULE_ID = 100;
    uint16 internal constant _MOCK_MODULE_TYPE = _PROXY_TYPE_SINGLE_PROXY;
    uint16 internal constant _MOCK_MODULE_VERSION = 1;

    // =======
    // Storage
    // =======

    MockBaseModule public module;

    MockBaseModule public moduleProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        module = new MockBaseModule(
            _MOCK_MODULE_ID,
            _MOCK_MODULE_TYPE,
            _MOCK_MODULE_VERSION
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(module);

        installerProxy.addModules(moduleAddresses);

        moduleProxy = MockBaseModule(
            dispatcher.moduleIdToProxy(_MOCK_MODULE_ID)
        );
    }

    // =====
    // Tests
    // =====

    function testModuleId() external {
        assertEq(module.moduleId(), _MOCK_MODULE_ID);
    }

    function testModuleType() external {
        assertEq(module.moduleType(), _MOCK_MODULE_TYPE);
    }

    function testModuleVersion() external {
        assertEq(module.moduleVersion(), _MOCK_MODULE_VERSION);
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
        module.testRevertBytesCustomError(code, message);
    }

    function testProxyLog0Topic() external {
        bytes32 message = bytes32(abi.encodePacked("hello"));

        assembly {
            mstore(0x00, message)
            log0(0x00, 0x05)
        }

        moduleProxy.testProxyLog0Topic();
    }

    function testProxyLog1Topic() external {
        vm.expectEmit(false, false, false, false);

        bytes32 message = bytes32(abi.encodePacked("hello"));
        bytes32 message1 = bytes32(uint256(1));

        assembly {
            mstore(0x00, message)
            log1(0x00, 0x05, message1)
        }

        moduleProxy.testProxyLog1Topic();
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

        moduleProxy.testProxyLog2Topic();
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

        moduleProxy.testProxyLog3Topic();
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

        moduleProxy.testProxyLog4Topic();
    }

    function testRevertProxyLogOutOfBounds() external {
        vm.expectRevert(FailedToLog.selector);
        moduleProxy.testRevertProxyLogOutOfBounds();
    }
}
