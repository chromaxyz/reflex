// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Mocks
import {ImplementationState} from "./abstracts/ImplementationState.sol";
import {MockReflexModule} from "./MockReflexModule.sol";

/**
 * @title Mock Implementation Deprecated Module
 */
contract MockImplementationDeprecatedModule is MockReflexModule, ImplementationState {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockReflexModule(moduleSettings_) {}
}
