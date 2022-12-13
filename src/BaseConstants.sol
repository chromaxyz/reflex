// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @title Base Constants
 * @dev Append-only extendable
 */
abstract contract BaseConstants {
    // TODO: replace delimiters with enum or constants, like Balancer V2 differentiating between pools

    // =========
    // Constants
    // =========

    /**
     * @dev These are modules that are only accessible by a single address.
     */
    uint16 internal constant _PROXY_TYPE_SINGLE_PROXY = 1;

    /**
     * @dev These are modules that have many addresses.
     */
    uint16 internal constant _PROXY_TYPE_MULTI_PROXY = 2;

    /**
     * @dev These are modules that are called internally by the system and don't have any public proxies.
     */
    uint16 internal constant _PROXY_TYPE_INTERNAL_PROXY = 3;

    uint32 internal constant _MODULE_ID_INSTALLER = 1;
}
