// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {ReflexInstaller} from "../../src/ReflexInstaller.sol";

/**
 * @title Mock Reflex Installer
 */
contract MockReflexInstaller is ReflexInstaller {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) ReflexInstaller(moduleSettings_) {}
}
