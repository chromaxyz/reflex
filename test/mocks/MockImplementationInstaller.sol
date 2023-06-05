// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexBase} from "../../src/ReflexBase.sol";
import {ReflexInstaller} from "../../src/ReflexInstaller.sol";

// Mocks
import {MockReflexModule} from "./MockReflexModule.sol";
import {MockImplementationModule} from "./MockImplementationModule.sol";

/**
 * @title Mock Implementation Installer
 */
contract MockImplementationInstaller is ReflexInstaller, MockImplementationModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockImplementationModule(moduleSettings_) {}

    // ============
    // Overrides
    // ============

    function _beforeEndpointCreation(
        uint32 moduleId_
    ) internal pure virtual override(ReflexBase, MockReflexModule) returns (bytes memory) {
        return super._beforeEndpointCreation(moduleId_);
    }
}
