// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexDispatcher} from "../../src/ReflexDispatcher.sol";

// Mocks
import {ImplementationState} from "./abstracts/ImplementationState.sol";

/**
 * @title Mock Implementation Dispatcher
 */
contract MockImplementationDispatcher is ReflexDispatcher, ImplementationState {
    // ===========
    // Constructor
    // ===========

    /**
     * @param owner_ Protocol owner.
     * @param installerModule_ Installer module address.
     */
    constructor(address owner_, address installerModule_) ReflexDispatcher(owner_, installerModule_) {}
}
