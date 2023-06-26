// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Mocks
import {MockReflexModule} from "./MockReflexModule.sol";

/**
 * @title Mock Implementation Malicious Storage Module
 * @dev Example of a module which incorrectly implements storage by overriding `ImplementationState`.
 * @dev Instead it implements storage directly in the module.
 */
contract MockImplementationMaliciousStorageModule is MockReflexModule {
    // =======
    // Storage
    // =======

    /**
     * @dev NOTE: DO NOT IMPLEMENT STORAGE INSIDE OF MODULES!
     */
    // uint8 internal _number;

    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockReflexModule(moduleSettings_) {}

    // ==========
    // Test stubs
    // ==========

    function setImplementationState0(bytes32 message_) public {
        _IMPLEMENTATION_STORAGE().implementationState0 = message_;
    }

    function getImplementationState0() public view returns (bytes32) {
        return _IMPLEMENTATION_STORAGE().implementationState0;
    }

    // =======
    // Storage
    // =======

    /**
     * @dev Append-only extendable.
     */
    struct ImplementationStorage {
        /**
         * @notice Implementation state 0.
         */
        bytes32 implementationState0;
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev NOTE: DO NOT OVERRIDE THE DIAMOND STORAGE SLOT INSIDE OF MODULES!
     */
    function _IMPLEMENTATION_STORAGE() internal pure returns (ImplementationStorage storage storage_) {
        assembly {
            // keccak256("diamond.storage.implementation");
            storage_.slot := 0x0bb48b320f315d19be28d4978081415a136259679ad5feb20491088c12441c20
        }
    }
}
