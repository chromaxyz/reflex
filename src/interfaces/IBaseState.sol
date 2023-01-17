// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @title Base State Test Interface
 */
interface TBaseState {
    // =====
    // Types
    // =====

    /**
     * @notice Trust relationship between `Proxy` and `Dispatcher`.
     * @dev Packed slot: 4 + 2 + 20 = 26 bytes out of 32 bytes.
     */
    struct TrustRelation {
        /**
         * @notice Module id.
         * @dev 0 is untrusted.
         */
        uint32 moduleId;
        /**
         * @notice Module type.
         * @dev 0 is untrusted.
         */
        uint16 moduleType;
        /**
         * @notice Module implementation.
         * @dev Only non-0 for single-proxy modules.
         */
        address moduleImplementation;
    }
}

/**
 * @title Base State Interface
 */
interface IBaseState is TBaseState {

}
