// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Mocks
import {ImplementationState} from "./abstracts/ImplementationState.sol";
import {MockReflexModule} from "./MockReflexModule.sol";

/**
 * @title Mock Implementation Gas Module
 */
contract MockImplementationGasModule is MockReflexModule, ImplementationState {
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

    function getEmpty() public view {}

    function getImplementationState0() public view returns (bytes32) {
        return _implementationState0;
    }

    function setImplementationState0(bytes32 message_) public {
        _implementationState0 = message_;
    }
}
