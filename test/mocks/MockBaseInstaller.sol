// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseInstaller} from "../../src/BaseInstaller.sol";

/**
 * @title Mock Base Installer
 */
contract MockBaseInstaller is BaseInstaller {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) BaseInstaller(moduleSettings_) {}
}
