// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @title Base Proxy Test Interface
 */
interface TBaseProxy {
    // ======
    // Errors
    // ======

    error InvalidModuleId();
}

/**
 * @title Base Proxy Interface
 */
interface IBaseProxy is TBaseProxy {
    // =======
    // Methods
    // =======

    function implementation() external view returns (address);

    function sentinel() external;
}
