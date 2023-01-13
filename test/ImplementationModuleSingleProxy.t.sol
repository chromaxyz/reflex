// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {stdError} from "forge-std/StdError.sol";
import {Vm} from "forge-std/Vm.sol";

// Interfaces
import {IBaseModule, TBaseModule} from "../src/interfaces/IBaseModule.sol";
import {IBaseProxy} from "../src/interfaces/IBaseProxy.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockBaseModule, ICustomError} from "./mocks/MockBaseModule.sol";

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

    MockBaseModule public singleModule;
    MockBaseModule public singleModuleProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModule = new MockBaseModule(
            IBaseModule.ModuleSettings({
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

        singleModuleProxy = MockBaseModule(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID));
    }

    // =====
    // Tests
    // =====

    function testModuleIdToImplementation() external {
        assertEq(dispatcher.moduleIdToModuleImplementation(_MODULE_SINGLE_ID), address(singleModule));
        assertEq(IBaseProxy(address(singleModuleProxy)).implementation(), address(singleModule));
    }

    function testModuleIdToProxy() external {
        assertTrue(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID) != address(0));
    }

    function testModuleSettings() external {
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

    function testGetModuleImplementationByProxy() external {
        assertEq(IBaseProxy(address(singleModuleProxy)).implementation(), address(singleModule));
    }

    function testProxyImplementation() external {
        assertEq(IBaseProxy(address(singleModuleProxy)).implementation(), address(singleModule));
    }

    function testProxySentinelFallback() external {
        (bool success, bytes memory data) = address(singleModuleProxy).call(abi.encodeWithSignature("sentinel()"));

        assertTrue(success);
        assertTrue(abi.decode(data, (bool)));
    }

    function testRevertBytesCustomError(uint256 code, string memory message) external {
        vm.expectRevert(
            abi.encodeWithSelector(
                ICustomError.CustomError.selector,
                ICustomError.CustomErrorPayload({code: code, message: message})
            )
        );
        singleModuleProxy.testRevertBytesCustomError(code, message);
    }

    function testRevertBytesPanicAssert() external {
        vm.expectRevert(stdError.assertionError);
        singleModuleProxy.testRevertPanicAssert();
    }

    function testRevertBytesPanicDivideByZero() external {
        vm.expectRevert(stdError.divisionError);
        singleModuleProxy.testRevertPanicDivisionByZero();
    }

    function testRevertBytesPanicArithmaticOverflow() external {
        vm.expectRevert(stdError.arithmeticError);
        singleModuleProxy.testRevertPanicArithmeticOverflow();
    }

    function testRevertBytesPanicArithmaticUnderflow() external {
        vm.expectRevert(stdError.arithmeticError);
        singleModuleProxy.testRevertPanicArithmeticUnderflow();
    }

    function testProxyLog0Topic(bytes memory message_) external BrutalizeMemory {
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

        singleModuleProxy.testProxyLog0Topic(message_);

        Vm.Log[] memory entries = vm.getRecordedLogs();

        assertEq(entries.length, 1);
        assertEq(entries[0].topics.length, 0);
        assertEq(entries[0].data, message_);
        assertEq(entries[0].emitter, address(singleModuleProxy));
    }

    function testProxyLog1Topic(bytes memory message_) external BrutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));

        vm.expectEmit(false, false, false, true, address(singleModuleProxy));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log1(ptr, messageLength, topic1)
        }
        singleModuleProxy.testProxyLog1Topic(message_);
    }

    function testProxyLog2Topic(bytes memory message_) external BrutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));
        bytes32 topic2 = bytes32(uint256(2));

        vm.expectEmit(true, false, false, true, address(singleModuleProxy));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log2(ptr, messageLength, topic1, topic2)
        }
        singleModuleProxy.testProxyLog2Topic(message_);
    }

    function testProxyLog3Topic(bytes memory message_) external BrutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));
        bytes32 topic2 = bytes32(uint256(2));
        bytes32 topic3 = bytes32(uint256(3));

        vm.expectEmit(true, true, false, true, address(singleModuleProxy));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log3(ptr, messageLength, topic1, topic2, topic3)
        }
        singleModuleProxy.testProxyLog3Topic(message_);
    }

    function testProxyLog4Topic(bytes memory message_) external BrutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        bytes32 message = bytes32(abi.encodePacked(message_));
        uint256 messageLength = message_.length;

        bytes32 topic1 = bytes32(uint256(1));
        bytes32 topic2 = bytes32(uint256(2));
        bytes32 topic3 = bytes32(uint256(3));
        bytes32 topic4 = bytes32(uint256(4));

        vm.expectEmit(true, true, true, true, address(singleModuleProxy));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, message)
            log4(ptr, messageLength, topic1, topic2, topic3, topic4)
        }
        singleModuleProxy.testProxyLog4Topic(message_);
    }

    function testRevertProxyLogOutOfBounds(bytes memory message_) external BrutalizeMemory {
        vm.assume(message_.length > 0 && message_.length <= 32);

        vm.expectRevert(TBaseModule.FailedToLog.selector);
        singleModuleProxy.testRevertProxyLogOutOfBounds(message_);
    }
}
