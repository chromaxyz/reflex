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
    // =========
    // Constants
    // =========

    /**
     * @dev NOTE: DO NOT RE-USE THE SAME STORAGE SLOT!
     */
    // solhint-disable-next-line function-name-mixedcase
    bytes32 internal constant _MALICIOUS_IMPLEMENTATION_STORAGE_SLOT =
        0xf8509337ad8a230e85046288664a1364ac578e6500ef88157efd044485b8c20a;

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

    function setMaliciousImplementationState0(bytes32 message_) public {
        _MALICIOUS_IMPLEMENTATION_STORAGE().implementationState0 = message_;
    }

    function getMaliciousImplementationState0() public view returns (bytes32) {
        return _MALICIOUS_IMPLEMENTATION_STORAGE().implementationState0;
    }

    // =======
    // Storage
    // =======

    /**
     * @dev Append-only extendable.
     */
    struct MaliciousImplementationStorage {
        /**
         * @notice Implementation state 0.
         */
        bytes32 implementationState0;
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev NOTE: DO NOT RE-USE THE SAME STORAGE SLOT!
     */
    // solhint-disable-next-line func-name-mixedcase
    function _MALICIOUS_IMPLEMENTATION_STORAGE()
        internal
        pure
        returns (MaliciousImplementationStorage storage storage_)
    {
        assembly {
            /**
             * @dev `bytes32(uint256(keccak256("_IMPLEMENTATION_STORAGE")) - 1)`
             * A `-1` offset is added so the preimage of the hash cannot be known,
             * reducing the chances of a possible attack.
             */
            storage_.slot := _MALICIOUS_IMPLEMENTATION_STORAGE_SLOT
        }
    }

    // ==========
    // Test stubs
    // ==========

    // solhint-disable-next-line func-name-mixedcase
    function MALICIOUS_IMPLEMENTATION_STORAGE_SLOT() public pure returns (bytes32) {
        return _MALICIOUS_IMPLEMENTATION_STORAGE_SLOT;
    }
}
