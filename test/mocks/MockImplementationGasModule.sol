// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexModule} from "../../src/ReflexModule.sol";

// Mocks
import {ImplementationState} from "./abstracts/ImplementationState.sol";

/**
 * @title Mock Reflex Module
 */
contract MockReflexGasModule is ReflexModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) ReflexModule(moduleSettings_) {}
}

/**
 * @title Mock Implementation Gas Module
 */
contract MockImplementationGasModule is MockReflexGasModule, ImplementationState {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockReflexGasModule(moduleSettings_) {}

    // ==========
    // Test stubs
    // ==========

    function getEmpty() public view {}

    function getImplementationState0() public view returns (bytes32) {
        return _implementationState0;
    }

    function setImplementationState0(bytes32 message_) public {
        _implementationState0 = message_;
    }
}
