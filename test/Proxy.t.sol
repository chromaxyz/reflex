// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendors
import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

// Interfaces
import {TBaseModule} from "../src/interfaces/IBaseModule.sol";
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

    function setUp() public virtual override {
        super.setUp();

        proxy = new Proxy();
    }

    // =====
    // Tests
    // =====

    function testResolveInvalidImplementationToZeroAddress() public {
        assertEq(proxy.implementation(), address(0));
    }

    function testSentinelSideEffectsDelegateCall(
        bytes memory data_
    ) public BrutalizeMemory {
        // This should never happen in any actual deployments.
        vm.startPrank(address(0));

        (bool success, bytes memory data) = address(proxy).call(
            // Prepend random data input with `sentinel()` selector.
            abi.encodePacked(bytes4(keccak256("sentinel()")), data_)
        );

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
