// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Contracts
import {BaseInstaller} from "../../src/abstracts/BaseInstaller.sol";

/**
 * @title Mock Base Installer
 */
contract MockBaseInstaller is BaseInstaller {
    constructor(uint16 moduleVersion_) BaseInstaller(moduleVersion_) {}
}
