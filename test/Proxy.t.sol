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
}
