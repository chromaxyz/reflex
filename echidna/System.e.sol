// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseConstants} from "../src/BaseState.sol";

// Mocks
import {MockBaseModule} from "../test/mocks/MockBaseModule.sol";

/**
 * @title System Invariants Test
 * @dev System-level invariants test
 */
contract SystemEchidnaTest is BaseConstants {
    // ========
    // Workflow
    // ========

    // Steps:
    //
    // - 1. Define invariants in English
    // - 2. Write the invariants in Solidity
    // - 3. Run invariant tests:
    //      - If invariants are broken: investigate
    //      - Once all the invariants pass go back to 1.

    // In practice:
    //
    // - Function-level invariant:
    //      - Testing a single function
    //      - Doesn't rely on a lot of system state or is pure
    //      - Can be tested in an isolated fashion
    //      - Example: `associate property of addition`, `subtraction is NOT commutative` OR `depositing tokens in a contract`

    // - System-level invariant:
    //      - Relies on the deployment of large part or the entire system
    //      - Invariants are usually stateful
    //      - Example: `user balance < total supply` OR `yield is monotonically increasing`

    // ==========
    // Invariants
    // ==========

    // Base Installer:
    //      - The `Installer` must always have the same `moduleId` for it is immutable.
    //      - The `Installer` must always be of single-proxy type for it is immutable.
    //      - The `Installer` must always have the same `moduleVersion` for it is immutable.

    // Base Module:
    //      - The `moduleId`, `moduleType`, `moduleVersion` are immutable throughout contract lifetime.
    //      - A `moduleId` of 0 must not be allowed.

    // Base Dispatcher:
    //      - One must not be able to remove the `Installer` module (known flaw).
    //      - One must always be able to look up the `Installer` proxy by its `moduleId`
    //      - One must always be able to look up the `Installer` implementation by its `moduleId`
    //      - One must always be able to look up the `TrustRelation` by its `proxyAddress`

    // =======
    // Storage
    // =======

    MockBaseModule private _module;

    uint32 private _moduleId;
    uint16 private _moduleType;
    uint16 private _moduleVersion;

    // =====
    // Setup
    // =====

    constructor() {
        _moduleId = 2;
        _moduleType = _MODULE_TYPE_SINGLE_PROXY;
        _moduleVersion = 1;

        _module = new MockBaseModule(_moduleId, _moduleType, _moduleVersion);
    }

    // =====
    // Tests
    // =====

    function echidna_ModuleIdImmutable() external view returns (bool) {
        return _module.moduleId() == _moduleId;
    }

    function echidna_ModuleVersionImmutable() external view returns (bool) {
        return _module.moduleVersion() == _moduleVersion;
    }

    function echidna_ModuleTypeImmutable() external view returns (bool) {
        return _module.moduleType() == _moduleType;
    }
}
