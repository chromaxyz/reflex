// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

// Sources
import {BaseInstaller} from "../../src/modules/BaseInstaller.sol";

// Implementations
import {ImplementationState} from "./ImplementationState.sol";

/**
 * @title Implementation Installer
 */
contract ImplementationInstaller is BaseInstaller, ImplementationState {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module moduleSettings.
     */
    constructor(
        ModuleSettings memory moduleSettings_
    ) BaseInstaller(moduleSettings_) {}

    // ==========
    // Test stubs
    // ==========
}
