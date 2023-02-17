// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

/**
 * @title Reflex Endpoint Test Interface
 */
interface TReflexEndpoint {
    // ======
    // Errors
    // ======

    error InvalidModuleId();
}

/**
 * @title Reflex Endpoint Interface
 */
interface IReflexEndpoint is TReflexEndpoint {
    // =======
    // Methods
    // =======

    function implementation() external view returns (address);

    function sentinel() external;
}
