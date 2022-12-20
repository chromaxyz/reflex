// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {BaseFixture} from "./fixtures/BaseFixture.sol";
import {InvariantFixture} from "./fixtures/InvariantFixture.sol";

/**
 * @title System Invariants Test
 * @dev System-level invariant test
 */
contract SystemInvariantsTest is BaseFixture, InvariantFixture {
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

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        _addTargetContract(address(installer));
        _addTargetContract(address(installerProxy));
        _addTargetContract(address(dispatcher));

        _addTargetSenders(address(this));
    }

    // =====
    // Tests
    // =====

    // Assertion: The `Installer` must always have the same `moduleId` for it is immutable.
    function invariantInstallerModuleIdImmutable() external {
        assertTrue(installerProxy.moduleId() == _BUILT_IN_MODULE_ID_INSTALLER);
    }

    // Assertion: The `Installer` must always be of single-proxy type for it is immutable.
    function invariantInstallerModuleTypeImmutable() external {
        assertTrue(installerProxy.moduleType() == _MODULE_TYPE_SINGLE_PROXY);
    }

    // Assertion: The `Installer` must always have the same `moduleVersion` for it is immutable.
    function invariantInstallerModuleVersionImmutable() external {
        assertTrue(installerProxy.moduleVersion() == _INSTALLER_MODULE_VERSION);
    }

    // TODO: it should discover a path where it is able to remove the installer module
    function invariantInstallerLookupModuleId() external {
        // address[] memory moduleAddresses = new address[](1);
        // moduleAddresses[0] = address(installer);
        // installerProxy.removeModules(moduleAddresses);

        assertEq(
            dispatcher.moduleIdToImplementation(_BUILT_IN_MODULE_ID_INSTALLER),
            address(installer)
        );
    }
}
