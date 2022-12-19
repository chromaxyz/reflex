// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseModule} from "../../src/BaseModule.sol";

// Implementations
import {ImplementationState} from "./ImplementationState.sol";

/**
 * @title Implementation Module
 */
contract ImplementationModule is BaseModule, ImplementationState {
    // ===========
    // Constructor
    // ===========

    constructor(
        uint32 _moduleId,
        uint16 _moduleType,
        uint16 _moduleVersion
    ) BaseModule(_moduleId, _moduleType, _moduleVersion) {}
}
