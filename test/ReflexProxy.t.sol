// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TReflexProxy} from "../src/interfaces/IReflexProxy.sol";

// Sources
import {ReflexProxy} from "../src/ReflexProxy.sol";

// Fixtures
import {TestHarness} from "./fixtures/TestHarness.sol";

/**
 * @title Reflex Proxy Test
 */
contract ReflexProxyTest is TReflexProxy, TestHarness {
    // =========
    // Constants
    // =========

    uint256 internal constant _MODULE_VALID_ID = 100;

    // =======
    // Storage
    // =======

    ReflexProxy public proxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        proxy = new ReflexProxy(_MODULE_VALID_ID);
    }

    // =====
    // Tests
    // =====

    function testUnitRevertInvalidModuleId() external {
        vm.expectRevert(InvalidModuleId.selector);
        new ReflexProxy(0);
    }

    function testUnitResolveInvalidImplementationToZeroAddress() external {
        assertEq(proxy.implementation(), address(0));
    }

    function testFuzzSentinelSideEffectsDelegateCall(bytes memory data_) public BrutalizeMemory {
        // This should never happen in any actual deployments.
        vm.startPrank(address(0));

        (bool success, bytes memory data) = address(proxy).call(
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
