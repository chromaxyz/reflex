// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexBatch} from "../../src/periphery/ReflexBatch.sol";
import {ReflexModule} from "../../src/ReflexModule.sol";

/**
 * @title Mock Reflex Batch
 */
contract MockReflexBatch is ReflexBatch {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) ReflexModule(moduleSettings_) {}
}
