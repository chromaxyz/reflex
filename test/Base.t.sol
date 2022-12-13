// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBase} from "../src/interfaces/IBase.sol";

// Fixtures
import {Fixture} from "./fixtures/Fixture.sol";

// Mocks
import {MockBase} from "./mocks/MockBase.sol";

/**
 * @title Base Test
 */
contract BaseTest is TBase, Fixture {
    // =======
    // Storage
    // =======

    MockBase public base;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        base = new MockBase();
    }

    // =====
    // Tests
    // =====

    function testRevertCreateProxyInvalidModuleId() external {
        vm.expectRevert(InvalidModuleId.selector);
        base.createProxy(uint32(0), uint16(0));
    }

    function testRevertCreateProxyInternalModule() external {
        vm.expectRevert(InternalModule.selector);
        base.createProxy(5, _PROXY_TYPE_INTERNAL_PROXY);
    }

    // function testUnpackMessageSender() external {
    //     base.unpackMessageSender();
    // }

    // function testUnpackMessageParameters() external {
    //     base.unpackParameters();
    // }
}
