// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

/**
 * @title Base State Test Interface
 */
interface TBaseState {
    // =====
    // Types
    // =====

    /**
     * @notice Trust relationship between `Proxy` and `Dispatcher`.
     * @dev Packed slot: 4 + 20 = 24 bytes out of 32 bytes.
     */
    struct TrustRelation {
        /**
         * @notice Module id.
         * @dev 0 is untrusted.
         */
        uint32 moduleId;
        /**
         * @notice Module implementation.
         * @dev Only non-0 for external single-proxy modules.
         */
        address moduleImplementation;
    }
}

/**
 * @title BaseState Interface
 */
interface IBaseState is TBaseState {
    // =======
    // Methods
    // =======
}
