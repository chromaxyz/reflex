// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Mocks
import {ImplementationState} from "./abstracts/ImplementationState.sol";
import {MockReflexModule} from "./MockReflexModule.sol";

/**
 * @title Mock Implementation Module
 */
contract MockImplementationModule is MockReflexModule, ImplementationState {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockReflexModule(moduleSettings_) {}
}
