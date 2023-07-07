// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexCircuitBreaker} from "./interfaces/IReflexCircuitBreaker.sol";

// Sources
import {ReflexModule} from "../ReflexModule.sol";

/**
 * @title Reflex Circuit Breaker
 *
 * @dev Execution takes place within the Dispatcher's storage context.
 * @dev Upgradeable, extendable.
 */
abstract contract ReflexCircuitBreaker is IReflexCircuitBreaker, ReflexModule {

}
