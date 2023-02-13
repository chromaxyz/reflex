// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

/**
 * @title Reflex Proxy Test Interface
 */
interface TReflexProxy {
    // ======
    // Errors
    // ======

    error InvalidModuleId();
}

/**
 * @title Reflex Proxy Interface
 */
interface IReflexProxy is TReflexProxy {
    // =======
    // Methods
    // =======

    function implementation() external view returns (address);

    function sentinel() external;
}
