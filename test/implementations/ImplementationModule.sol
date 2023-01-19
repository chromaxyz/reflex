// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Implementations
import {ImplementationState} from "./ImplementationState.sol";

// Mocks
import {MockReflexModule} from "../mocks/MockReflexModule.sol";

/**
 * @title Implementation Module
 */
contract ImplementationModule is MockReflexModule, ImplementationState {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockReflexModule(moduleSettings_) {}
}
