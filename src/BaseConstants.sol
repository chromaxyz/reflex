// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @title Base Constants
 * @dev Append-only extendable, only use internal constants!
 */
abstract contract BaseConstants {
    // =========
    // Constants
    // =========

    /**
     * @dev Reentrancy mutex unlocked state.
     */
    uint256 internal constant _REENTRANCY_LOCK_UNLOCKED = 1;

    /**
     * @dev Reentrancy mutex locked state.
     */
    uint256 internal constant _REENTRANCY_LOCK_LOCKED = 2;

    /**
     * @dev These are modules that have a single proxy to a single implementation.
     */
    uint16 internal constant _MODULE_TYPE_SINGLE_PROXY = 1;

    /**
     * @dev These are modules that have multiple proxies to a single implementation.
     */
    uint16 internal constant _MODULE_TYPE_MULTI_PROXY = 2;

    /**
     * @dev These are modules that are called internally by the system and don't have any public proxies.
     */
    uint16 internal constant _MODULE_TYPE_INTERNAL = 3;

    /**
     * @dev Module id of built-in upgradeable installer module.
     */
    uint32 internal constant _MODULE_ID_INSTALLER = 1;

    /**
     * @dev Module version of built-in upgradeable installer module.
     */
    uint16 internal constant _MODULE_VERSION_INSTALLER = 1;

    /**
     * @dev Module upgradeability of built-in upgradeable installer module.
     */
    bool internal constant _MODULE_UPGRADEABLE_INSTALLER = true;

    /**
     * @dev Module removeability of built-in upgradeable installer module.
     */
    bool internal constant _MODULE_REMOVEABLE_INSTALLER = false;
}
