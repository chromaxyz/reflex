// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
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

    // =========
    // Overrides
    // =========

    /**
     * @dev NOTE: DO NOT IMPLEMENT INVALID ENDPOINT CREATION CODE!
     */
    function _getEndpointCreationCode(uint32 moduleId_) internal virtual override returns (bytes memory) {
        // Special case for to test invalid endpoint in `ImplementationEndpoint.t.sol`
        if (moduleId_ == 777) return abi.encodePacked(type(RevertingInvalidEndpoint).creationCode);

        return super._getEndpointCreationCode(moduleId_);
    }
}

// =========
// Utilities
// =========

/**
 * @title Reverting Invalid Endpoint
 */
contract RevertingInvalidEndpoint {
    constructor() {
        assembly {
            revert(0, 0)
        }
    }
}
