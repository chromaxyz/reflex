// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseConstants} from "../src/BaseState.sol";

// Mocks
import {MockBaseInstaller} from "../test/mocks/MockBaseInstaller.sol";
import {MockBaseDispatcher} from "../test/mocks/MockBaseDispatcher.sol";
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

    // =========
    // Constants
    // =========

    address internal constant _ALICE = address(0xAAAA);
    address internal constant _BOB = address(0xBBBB);

    // =======
    // Storage
    // =======

    MockBaseInstaller private _installer;
    MockBaseInstaller private _installerProxy;
    MockBaseDispatcher private _dispatcher;
    MockBaseModule private _exampleModule;
    MockBaseModule private _exampleModuleProxy;

    uint32 private _exampleModuleId;
    uint16 private _exampleModuleType;
    uint16 private _exampleModuleVersion;

    uint16 private _installerModuleVersion;

    // =====
    // Setup
    // =====

    constructor() {
        _exampleModuleId = 2;
        _exampleModuleType = _MODULE_TYPE_SINGLE_PROXY;
        _exampleModuleVersion = 1;

        _installerModuleVersion = 1;
        _installer = new MockBaseInstaller(_exampleModuleVersion);

        _dispatcher = new MockBaseDispatcher(
            "Dispatcher",
            address(this),
            address(_installer)
        );

        _installerProxy = MockBaseInstaller(
            _dispatcher.moduleIdToProxy(_BUILT_IN_MODULE_ID_INSTALLER)
        );

        _exampleModule = new MockBaseModule(
            _exampleModuleId,
            _exampleModuleType,
            _exampleModuleVersion
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(_exampleModule);
        _installerProxy.addModules(moduleAddresses);

        _exampleModuleProxy = MockBaseModule(
            _dispatcher.moduleIdToProxy(_exampleModuleId)
        );
    }

    // =====
    // Tests
    // =====

    function expectModuleIdImmutable() external view {
        assert(_installerProxy.moduleId() == _BUILT_IN_MODULE_ID_INSTALLER);
        assert(_exampleModuleProxy.moduleId() == _exampleModuleId);
    }

    function expectModuleVersionImmutable() external view {
        assert(_installerProxy.moduleVersion() == _installerModuleVersion);
        assert(_exampleModuleProxy.moduleVersion() == _exampleModuleVersion);
    }

    function expectModuleTypeImmutable() external view {
        assert(_installerProxy.moduleType() == _MODULE_TYPE_SINGLE_PROXY);
        assert(_exampleModuleProxy.moduleType() == _exampleModuleType);
    }
}
