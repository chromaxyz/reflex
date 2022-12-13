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
    }

    // =====
    // Tests
    // =====

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
}
