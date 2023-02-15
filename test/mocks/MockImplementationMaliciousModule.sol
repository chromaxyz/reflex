// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Mocks
import {MockReflexModule} from "./MockReflexModule.sol";

/**
 * @title Mock Implementation Malicious Module
 */
contract MockImplementationMaliciousModule is MockReflexModule {
    // =======
    // Storage
    // =======

    /**
     * @dev NOTE: DO NOT IMPLEMENT STORAGE INSIDE OF MODULES!
     */
    uint8 internal _number;

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

    function setNumber(uint8 number_) external {
        _number = number_;
    }

    function getNumber() external view returns (uint8) {
        return _number;
    }
}
