// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseModule} from "../src/interfaces/IBaseModule.sol";

// Fixtures
import {BaseFixture} from "./fixtures/BaseFixture.sol";

// Mocks
import {MockBaseModule} from "./mocks/MockBaseModule.sol";

/**
 * @title Base Module  Test
 */
contract BaseModuleTest is TBaseModule, BaseFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MOCK_MODULE_VALID_ID = 5;
    uint16 internal constant _MOCK_MODULE_VALID_TYPE_SINGLE =
        _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MOCK_MODULE_VALID_TYPE_MULTI =
        _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _MOCK_MODULE_VALID_TYPE_INTERNAL =
        _MODULE_TYPE_INTERNAL;
    uint16 internal constant _MOCK_MODULE_VALID_VERSION = 1;

    uint32 internal constant _MOCK_MODULE_INVALID_ID = 0;
    uint16 internal constant _MOCK_MODULE_INVALID_TYPE = 777;
    uint16 internal constant _MOCK_MODULE_INVALID_TYPE_ZERO = 0;
    uint16 internal constant _MOCK_MODULE_INVALID_VERSION = 0;

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
    }

    // =====
    // Tests
    // =====

    function testValidModuleId() external {
        module = new MockBaseModule(
            _MOCK_MODULE_VALID_ID,
            _MOCK_MODULE_VALID_TYPE_SINGLE,
            _MOCK_MODULE_VALID_VERSION
        );

        assertEq(module.moduleId(), _MOCK_MODULE_VALID_ID);
    }

    function testValidModuleType() external {
        module = new MockBaseModule(
            _MOCK_MODULE_VALID_ID,
            _MOCK_MODULE_VALID_TYPE_SINGLE,
            _MOCK_MODULE_VALID_VERSION
        );

        assertEq(module.moduleType(), _MOCK_MODULE_VALID_TYPE_SINGLE);
    }

    function testValidModuleVersion() external {
        module = new MockBaseModule(
            _MOCK_MODULE_VALID_ID,
            _MOCK_MODULE_VALID_TYPE_SINGLE,
            _MOCK_MODULE_VALID_VERSION
        );

        assertEq(module.moduleVersion(), _MOCK_MODULE_VALID_VERSION);
    }

    function testRevertInvalidModuleIdZeroValue() external {
        vm.expectRevert(InvalidModuleId.selector);
        module = new MockBaseModule(
            _MOCK_MODULE_INVALID_ID,
            _MOCK_MODULE_VALID_TYPE_SINGLE,
            _MOCK_MODULE_VALID_VERSION
        );
    }

    function testRevertInvalidModuleTypeZeroValue() external {
        vm.expectRevert(InvalidModuleType.selector);
        module = new MockBaseModule(
            _MOCK_MODULE_VALID_ID,
            _MOCK_MODULE_INVALID_TYPE_ZERO,
            _MOCK_MODULE_VALID_VERSION
        );
    }

    function testRevertInvalidModuleTypeOverflowValue() external {
        vm.expectRevert(InvalidModuleType.selector);
        module = new MockBaseModule(
            _MOCK_MODULE_VALID_ID,
            _MOCK_MODULE_INVALID_TYPE,
            _MOCK_MODULE_VALID_VERSION
        );
    }

    function testRevertInvalidModuleVersionZeroValue() external {
        vm.expectRevert(InvalidModuleVersion.selector);
        module = new MockBaseModule(
            _MOCK_MODULE_VALID_ID,
            _MOCK_MODULE_VALID_TYPE_SINGLE,
            _MOCK_MODULE_INVALID_VERSION
        );
    }

    // TODO: add tests

    function testCreateProxy() external {
        module = new MockBaseModule(
            _MOCK_MODULE_VALID_ID,
            _MOCK_MODULE_VALID_TYPE_MULTI,
            _MOCK_MODULE_VALID_VERSION
        );

        module.createProxy(
            _MOCK_MODULE_VALID_ID,
            _MOCK_MODULE_VALID_TYPE_MULTI
        );
    }

    // function testCallInternalModule() external {
    //     module.callInternalModule(moduleId_, input_);
    // }

    //     function testUnpackMessageSender() external {
    //         module.unpackMessageSender();
    //     }

    //     function testUnpackProxyAddress() external {
    //         module.unpackProxyAddress();
    //     }
}
