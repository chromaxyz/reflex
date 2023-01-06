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
     * @dev These are modules that are only accessible by a single address.
     */
    uint16 internal constant _MODULE_TYPE_SINGLE_PROXY = 1;

    /**
     * @dev These are modules that have many addresses.
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
}
