// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseState, IBaseState} from "./IBaseState.sol";

/**
 * @title Base Test Interface
 */
interface TBase is TBaseState {
    // ======
    // Errors
    // ======

    error EmptyError();

    error Reentrancy();

    error InternalModule();

    error InvalidModuleId();

    error InvalidModuleType();

    // ======
    // Events
    // ======

    event ProxyCreated(address indexed proxyAddress_);
}

/**
 * @title Base Interface
 */
interface IBase is IBaseState, TBase {

}
