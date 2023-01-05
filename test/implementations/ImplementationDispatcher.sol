// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseDispatcher} from "../../src/BaseDispatcher.sol";

// Implementations
import {ImplementationState} from "./ImplementationState.sol";

/**
 * @title Implementation Dispatcher
 */
contract ImplementationDispatcher is BaseDispatcher, ImplementationState {
    // ===========
    // Constructor
    // ===========

    constructor(
        address owner_,
        address installerModule_
    ) BaseDispatcher(owner_, installerModule_) {}

    // ==========
    // Test stubs
    // ==========
}
