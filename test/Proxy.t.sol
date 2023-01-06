// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendors
import {Test} from "forge-std/Test.sol";

// Interfaces
import {TProxy} from "../src/interfaces/IProxy.sol";

// Internals
import {Proxy} from "../src/internals/Proxy.sol";

// Fixtures
import {Harness} from "./fixtures/Harness.sol";

/**
 * @title Proxy Test
 */
contract ProxyTest is TProxy, Test, Harness {
    // =======
    // Storage
    // =======

    Proxy public proxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        proxy = new Proxy();
    }

    // =====
    // Tests
    // =====

    function testResolveInvalidImplementationToZeroAddress() public {
        assertEq(proxy.implementation(), address(0));
    }

    function testSideEffectsDelegateCall(
        bytes memory data_
    ) public BrutalizeMemory {
        // Specifically filter out function selector clash of `implementation()` as it is beyond the scope of this test.
        vm.assume(bytes4(data_) != bytes4(keccak256("implementation()")));

        // This should never happen in any actual deployments.
        vm.startPrank(address(0));

        (bool success, bytes memory data) = address(proxy).call(data_);

        // Expect `delegatecall` to return `true` on call to non-contract address.
        assertTrue(success);

        // Expect return data to be empty, result is `popped`.
        assertEq(
            // Cast down to bytes32.
            abi.encodePacked(bytes32(data)),
            // Cast up to bytes32.
            abi.encodePacked(bytes32(""))
        );

        vm.stopPrank();
    }
}
