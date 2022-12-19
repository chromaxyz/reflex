// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseDispatcher} from "../../src/BaseDispatcher.sol";

// Implementation
import {ImplementationState} from "./ImplementationState.sol";

/**
 * @title Implementation Dispatcher
 */
contract Dispatcher is BaseDispatcher, ImplementationState {
    // ===========
    // Constructor
    // ===========

    constructor(
        string memory name_,
        address owner_,
        address installerModule_
    ) BaseDispatcher(name_, owner_, installerModule_) {}
}
