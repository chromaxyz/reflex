// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexDispatcher} from "../../src/ReflexDispatcher.sol";

// Fixtures
import {MockHarness} from "../fixtures/MockHarness.sol";

/**
 * @title Mock Reflex Dispatcher
 */
contract MockReflexDispatcher is MockHarness, ReflexDispatcher {
    // ===========
    // Constructor
    // ===========

    constructor(address owner_, address installerModule_) ReflexDispatcher(owner_, installerModule_) {}

    // ==========
    // Test stubs
    // ==========

    function setModuleToImplementation(uint32 moduleId_, address moduleImplementation_) public {
        _REFLEX_STORAGE().modules[moduleId_] = moduleImplementation_;
    }
}
