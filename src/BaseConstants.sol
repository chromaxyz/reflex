// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

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
     * @dev Modules that are called internally and don't have any public-facing proxies.
     */
    uint16 internal constant _MODULE_TYPE_INTERNAL = 3;

    // =======
    // Modules
    // =======

    /**
     * @dev Module id of built-in upgradeable installer module.
     */
    uint32 internal constant _MODULE_ID_INSTALLER = 1;

    /**
     * @dev Module version of built-in upgradeable installer module.
     */
    uint16 internal constant _MODULE_VERSION_INSTALLER = 1;

    /**
     * @dev Module upgradeability setting of built-in upgradeable installer module.
     */
    bool internal constant _MODULE_UPGRADEABLE_INSTALLER = true;

    /**
     * @dev Module removeability setting of built-in upgradeable installer module.
     */
    bool internal constant _MODULE_REMOVEABLE_INSTALLER = false;
}
