// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

/**
 * @title Reflex Endpoint Interface
 */
interface IReflexEndpoint {
    // ======
    // Errors
    // ======

    /**
     * @notice Thrown when the module id is invalid.
     */
    error ModuleIdInvalid(uint32 moduleId);
}
