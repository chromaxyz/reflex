// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

/**
 * @title Reflex State Interface
 */
interface IReflexState {
    // =======
    // Structs
    // =======

    /**
     * @notice Trust relationship between `Endpoint` and `Dispatcher`.
     * @dev Packed slot: 4 + 2 + 20 = 26 bytes out of 32 bytes.
     */
    struct TrustRelation {
        /**
         * @dev Module id.
         * @dev 0 is untrusted.
         */
        uint32 moduleId;
        /**
         * @dev Module type.
         * @dev 0 is untrusted.
         */
        uint16 moduleType;
        /**
         * @dev Module implementation.
         * @dev 0 for multi-endpoint and internal modules.
         */
        address moduleImplementation;
    }
}
