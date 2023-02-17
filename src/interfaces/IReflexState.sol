// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

/**
 * @title Reflex State Test Interface
 */
interface TReflexState {
    // =======
    // Structs
    // =======

    /**
     * @notice Trust relationship between `Proxy` and `Dispatcher`.
     *
     * @dev Packed slot: 4 + 2 + 20 = 26 bytes out of 32 bytes.
     */
    struct TrustRelation {
        /**
         * @notice Module id.
         *
         * @dev 0 is untrusted.
         */
        uint32 moduleId;
        /**
         * @notice Module type.
         *
         * @dev 0 is untrusted.
         */
        uint16 moduleType;
        /**
         * @notice Module implementation.
         *
         * @dev Only non-0 for single-proxy modules.
         */
        address moduleImplementation;
    }
}

/**
 * @title Reflex State Interface
 */
interface IReflexState is TReflexState {

}
