// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @title Base Constants
 * @dev Append-only extendable, only use internal constants!
 */
abstract contract BaseConstants {
    // =======
    // Globals
    // =======

    /**
     * @dev Reentrancy mutex unlocked state.
     */
    uint256 internal constant _REENTRANCY_LOCK_UNLOCKED = 1;

    /**
     * @dev Reentrancy mutex locked state.
     */
    uint256 internal constant _REENTRANCY_LOCK_LOCKED = 2;

    // =============
    // Configuration
    // =============

    /**
     * @dev Modules that have a single proxy to a single implementation relation.
     */
    uint16 internal constant _MODULE_TYPE_SINGLE_PROXY = 1;

    /**
     * @dev Modules that have a multiple proxies to a single implementation relation.
     */
    uint16 internal constant _MODULE_TYPE_MULTI_PROXY = 2;

    /**
     * @dev Modules that are available internally, called internally and don't have any public-facing proxies.
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
