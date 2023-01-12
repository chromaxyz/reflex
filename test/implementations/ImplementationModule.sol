// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseModule} from "../../src/BaseModule.sol";

// Implementations
import {ImplementationState} from "./ImplementationState.sol";

/**
 * @title Implementation Module
 */
contract ImplementationModule is BaseModule, ImplementationState {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(
        ModuleSettings memory moduleSettings_
    ) BaseModule(moduleSettings_) {}

    // ==========
    // Test stubs
    // ==========
}
