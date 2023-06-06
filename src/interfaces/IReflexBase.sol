// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexState} from "./IReflexState.sol";

/**
 * @title Reflex Base Interface
 */
interface IReflexBase is IReflexState {
    // ======
    // Errors
    // ======

    /**
     * @notice Thrown when error message is empty.
     */
    error EmptyError();

    /**
     * @notice Thrown when endpoint creation code reverts upon creation.
     */
    error EndpointInvalid();

    /**
     * @notice Thrown when the module id is invalid.
     */
    error ModuleIdInvalid();

    /**
     * @notice Thrown when the module type is invalid.
     */
    error ModuleTypeInvalid();

    /**
     * @notice Thrown when an attempt is made to re-enter the protected method.
     */
    error ReadOnlyReentrancy();

    /**
     * @notice Thrown when an attempt is made to re-enter the protected method.
     */
    error Reentrancy();

    // ======
    // Events
    // ======

    /**
     * @notice Emitted when an endpoint is created.
     * @param moduleId Module id.
     * @param endpointAddress The address of the created endpoint.
     */
    event EndpointCreated(uint32 indexed moduleId, address indexed endpointAddress);
}
