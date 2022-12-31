// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendors
import {Test} from "forge-std/Test.sol";

// Interfaces
import {TProxy} from "../src/interfaces/IProxy.sol";

// Internals
import {Proxy} from "../src/internals/Proxy.sol";

/**
 * @title Proxy Test
 */
contract ProxyTest is TProxy, Test {
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
}
