// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseModule} from "../../src/interfaces/IBaseModule.sol";

/**
 * @title Mock Implementation External Module
 */
contract MockImplementationExternalModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(IBaseModule.ModuleSettings memory moduleSettings_) {}
}
