// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseModule} from "../src/interfaces/IBaseModule.sol";

// Fixtures
import {BaseFixture} from "./fixtures/BaseFixture.sol";

// Implementations
import {ImplementationTokens} from "./implementations/ImplementationTokens.sol";

// Mocks
import {MockBaseModule} from "./mocks/MockBaseModule.sol";

// TODO: add multiple `ImplementationToken` proxies (tokenA, tokenB, tokenC)

/**
 * @title Base Module Multi Proxy Test
 */
contract BaseModuleMultiProxyTest is TBaseModule, BaseFixture {
    // =======
    // Storage
    // =======

    ImplementationTokens public tokens;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        tokens.setupTokens();
    }

    // =====
    // Tests
    // =====

    // TODO: add tests
}
