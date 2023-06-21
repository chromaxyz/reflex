// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Mocks
import {MockReflexModule} from "./MockReflexModule.sol";

/**
 * @title Mock Implementation Malicious Self-Destruct Module
 */
contract MockImplementationMaliciousSelfDestructModule is MockReflexModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockReflexModule(moduleSettings_) {}

    // ==========
    // Test stubs
    // ==========

    function destroy(address payable receiver_) external {
        selfdestruct(receiver_);
    }
}
