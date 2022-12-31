// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TProxy} from "../src/interfaces/IProxy.sol";

// Internals
import {Proxy} from "../src/internals/Proxy.sol";

// Fixtures
import {ConstantsFixture} from "./fixtures/ConstantsFixture.sol";

/**
 * @title Proxy Test
 */
contract ProxyTest is TProxy, ConstantsFixture {
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
