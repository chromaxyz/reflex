// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexEndpoint} from "../src/interfaces/IReflexEndpoint.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {MockReflexEndpoint} from "./mocks/MockReflexEndpoint.sol";

/**
 * @title Reflex Endpoint Test
 */
contract ReflexEndpointTest is ReflexFixture {
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

    function setUp() public virtual override {
        super.setUp();

        endpoint = new MockReflexEndpoint(_MODULE_VALID_ID);
    }

    // =====
    // Tests
    // =====

    function testUnitRevertInvalidModuleId() external {
        vm.expectRevert(abi.encodeWithSelector(IReflexEndpoint.ModuleIdInvalid.selector, 0));
        new MockReflexEndpoint(0);
    }

    function testUnitResolveImplementationAddress() external {
        assertEq(installerEndpoint.implementation(), address(installer));
    }

    function testUnitResolveInvalidImplementationToZeroAddress() external {
        assertEq(endpoint.implementation(), address(0));
    }

    function testFuzzSentinelSideEffectsDelegateCall(bytes memory data_) public brutalizeMemory {
        // This should never happen in any actual deployments.
        vm.startPrank(address(0));

        (bool success, bytes memory data) = address(endpoint).call(
            // Prepend random data input with `sentinel()` selector.
            abi.encodePacked(bytes4(keccak256("sentinel()")), data_)
        );

        // Expect `delegatecall` to return `true` on call to non-contract address.
        assertTrue(success);

        // Expect return data to be empty, result is `popped`.
        assertEq(abi.encodePacked(data), abi.encodePacked(""));

        vm.stopPrank();
    }
}
