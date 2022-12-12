// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @title Base State Test Interface
 */
interface TBaseState {
    // =====
    // Types
    // =====

    struct TrustRelation {
        // Packed slot: 4 + 20 = 24
        uint32 moduleId; // 0 is untrusted.
        address moduleImplementation; // only non-0 for external single-proxy modules.
    }
}

/**
 * @title BaseState Interface
 */
interface IBaseState is TBaseState {

}
