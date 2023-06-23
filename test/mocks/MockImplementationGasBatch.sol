// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexBase} from "../../src/ReflexBase.sol";
import {ReflexBatch} from "../../src/periphery/ReflexBatch.sol";

// Mocks
import {MockReflexModule} from "./MockReflexModule.sol";

/**
 * @title Mock Implementation Gas Batch
 */
contract MockImplementationGasBatch is ReflexBatch, MockReflexModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockReflexModule(moduleSettings_) {}

    // =========
    // Overrides
    // =========

    function _getEndpointCreationCode(
        uint32 moduleId_
    ) internal virtual override(ReflexBase, MockReflexModule) returns (bytes memory) {
        return super._getEndpointCreationCode(moduleId_);
    }
}
