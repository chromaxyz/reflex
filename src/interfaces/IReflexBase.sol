// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TReflexState, IReflexState} from "./IReflexState.sol";

/**
 * @title Reflex Base Test Interface
 */
interface TReflexBase is TReflexState {
    // ======
    // Errors
    // ======

    error EmptyError();

    error InternalModule();

    error InvalidModuleId();

    error InvalidModuleType();

    error Reentrancy();

    // ======
    // Events
    // ======

    event ProxyCreated(address indexed proxyAddress_);
}

/**
 * @title Reflex Base Interface
 */
interface IReflexBase is IReflexState, TReflexBase {

}
