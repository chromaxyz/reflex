// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Modules
import {BaseInstaller} from "../../src/modules/BaseInstaller.sol";

/**
 * @title Mock Base Installer
 */
contract MockBaseInstaller is BaseInstaller {
    constructor(
        uint32 moduleId_,
        uint16 moduleType_,
        uint16 moduleVersion_
    ) BaseInstaller(moduleId_, moduleType_, moduleVersion_) {}
}
