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

    error EmptyError();

    error EndpointInvalid();

    error ModuleIdInvalid();

    error ModuleTypeInvalid();

    error ReadOnlyReentrancy();

    error Reentrancy();

    // ======
    // Events
    // ======

    event EndpointCreated(address indexed endpointAddress);
}
