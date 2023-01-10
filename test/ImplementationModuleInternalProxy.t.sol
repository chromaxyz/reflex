// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

/**
 * @title Implementation Module Internal Proxy Test
 */
contract ImplementationModuleInternalProxyTest is ImplementationFixture {
    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();
    }

    // =====
    // Tests
    // =====

    function testUpgradeInternalProxy() external {}
}
