// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {ReflexInstaller} from "../../src/ReflexInstaller.sol";

// Implementations
import {ImplementationModule} from "./ImplementationModule.sol";

/**
 * @title Implementation Installer
 */
contract ImplementationInstaller is ReflexInstaller, ImplementationModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) ImplementationModule(moduleSettings_) {}
}
