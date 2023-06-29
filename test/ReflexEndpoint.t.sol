// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexEndpoint} from "../src/interfaces/IReflexEndpoint.sol";

// Fixtures
import {TestHarness} from "./fixtures/TestHarness.sol";

// Mocks
import {MockReflexEndpoint} from "./mocks/MockReflexEndpoint.sol";

/**
 * @title Reflex Endpoint Test
 */
contract ReflexEndpointTest is TestHarness {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_VALID_ID = 100;

    // =======
    // Storage
    // =======

    MockReflexEndpoint public endpoint;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        endpoint = new MockReflexEndpoint(_MODULE_VALID_ID);
    }

    // =====
    // Tests
    // =====

    function testUnitRevertInvalidModuleId() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexEndpoint.ModuleIdInvalid.selector, 0));
        new MockReflexEndpoint(0);
    }
}
