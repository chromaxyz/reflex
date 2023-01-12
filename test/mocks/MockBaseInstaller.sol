// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Modules
import {BaseInstaller} from "../../src/modules/BaseInstaller.sol";

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
    constructor(
        ModuleSettings memory moduleSettings_
    ) BaseInstaller(moduleSettings_) {}
}
