// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @title Base Constants
 * @dev Append-only extendable
 */
abstract contract BaseConstants {
    // =========
    // Constants
    // =========

    // External single-proxy components
    // These are modules that are only accessible by a single address.
    uint32 internal constant _MODULE_ID_INSTALLER = 1;
    uint32 internal constant _MODULE_ID_LENS = 2;
    uint32 internal constant _EXTERNAL_SINGLE_PROXY_DELIMITER = 499_999;

    // External multi-proxy components
    // These are modules that have many addresses.
    uint32 internal constant _EXTERNAL_MULTI_PROXY_DELIMITER = 999_999;

    // Internal components
    // These are modules that are called internally by the system and don't have any public proxies.
    uint32 internal constant _INTERNAL_PROXY_DELIMITER = 1_499_999;
}
