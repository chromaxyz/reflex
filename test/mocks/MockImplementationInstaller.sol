// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {ReflexInstaller} from "../../src/ReflexInstaller.sol";

// Mocks
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
}
