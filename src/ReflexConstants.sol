// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

/**
 * @title Reflex Constants
 *
 * @dev Append-only extendable, only use internal constants!
 */
abstract contract ReflexConstants {
    // =======
    // Globals
    // =======

    /**
     * @dev Reentrancy guard unlocked state.
     */
    uint256 internal constant _REENTRANCY_GUARD_UNLOCKED = 1;

    /**
     * @dev Reentrancy guard locked state.
     */
    uint256 internal constant _REENTRANCY_GUARD_LOCKED = 2;

    // =============
    // Configuration
    // =============

    /**
     * @dev Modules that have a single endpoint to a single implementation relation.
     */
    uint16 internal constant _MODULE_TYPE_SINGLE_ENDPOINT = 1;

    /**
     * @dev Modules that have multiple endpoints to a single implementation relation.
     */
    uint16 internal constant _MODULE_TYPE_MULTI_ENDPOINT = 2;

    /**
     * @dev Modules that are available internally, called internally and don't have any public-facing endpoints.
     */
    uint16 internal constant _MODULE_TYPE_INTERNAL = 3;

    // =======
    // Modules
    // =======

    /**
     * @dev Module id of built-in upgradeable installer module.
     */
    uint32 internal constant _MODULE_ID_INSTALLER = 1;
}
