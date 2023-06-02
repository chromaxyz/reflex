// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexEndpoint} from "../../src/ReflexEndpoint.sol";

/**
 * @title Mock Reflex Endpoint
 */
contract MockReflexEndpoint is ReflexEndpoint {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleId_ Module id.
     */
    constructor(uint32 moduleId_) ReflexEndpoint(moduleId_) {}
}
