// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexDispatcher} from "../../src/ReflexDispatcher.sol";

// Mocks
import {ImplementationStorage} from "./abstracts/ImplementationStorage.sol";

/**
 * @title Mock Implementation Dispatcher
 */
contract MockImplementationDispatcher is ReflexDispatcher, ImplementationStorage {
    // ===========
    // Constructor
    // ===========

    /**
     * @param owner_ Contract owner.
     * @param installerModule_ Installer module address.
     */
    constructor(address owner_, address installerModule_) ReflexDispatcher(owner_, installerModule_) {}
}
