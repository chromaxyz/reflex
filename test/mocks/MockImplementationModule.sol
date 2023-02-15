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

    // ==========
    // Test stubs
    // ==========

    function setImplementationState0(bytes32 message_) public {
        _implementationState0 = message_;
    }

    function getImplementationState0() public view returns (bytes32) {
        return _implementationState0;
    }
}
