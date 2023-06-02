// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexState, TReflexState} from "./IReflexState.sol";

/**
 * @title Reflex Base Test Interface
 */
interface TReflexBase is TReflexState {
    // ======
    // Errors
    // ======

    error EmptyError();

    error InvalidEndpoint();

    error InvalidModuleId();

    error InvalidModuleType();

    error Reentrancy();

    // ======
    // Events
    // ======

    event EndpointCreated(address indexed endpointAddress);
}

/**
 * @title Reflex Base Interface
 */
interface IReflexBase is IReflexState, TReflexBase {

}
