// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseInstaller} from "../../src/modules/BaseInstaller.sol";

// Implementations
import {ImplementationState} from "./ImplementationState.sol";

/**
 * @title Implementation Installer
 */
contract ImplementationInstaller is BaseInstaller, ImplementationState {
    // ===========
    // Constructor
    // ===========

    constructor(uint16 _moduleVersion) BaseInstaller(_moduleVersion) {}

    // ==========
    // Test stubs
    // ==========
}
