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
    // Design would likely be a bit different than the original, but the idea is the same.
    // Would be more simplistic
    // Would be more gas efficient
    // Would only support ERC20 (no dependencies)
    // SafeERC20 / SafeCast copied from Solady
    // Would only support percentage based circuit breakers
    // A way for users to recover locked funds
    // A way to track funds flowing through the system
    // Goal is to adhere to the standard as much as possible but with a more simplistic design

    // =========
    // Constants
    // =========

    /**
     * @dev `bytes32(uint256(keccak256("_REFLEX_CIRCUIT_BREAKER_STORAGE")) - 1)`
     * A `-1` offset is added so the preimage of the hash cannot be known,
     * reducing the chances of a possible attack.
     */
    bytes32 internal constant _REFLEX_CIRCUIT_BREAKER_STORAGE_SLOT =
        0xd9ac2ceb110c0df268ba862a6063bcc7110ab1a6271b4c65be465273acab1998;

    // =======
    // Storage
    // =======

    /**
     * @dev Append-only extendable.
     */
    struct ReflexCircuitBreakerStorage {
        bool isRateLimited;
        uint256 rateLimitCooldownPeriod;
        uint256 lastRateLimitTimestamp;
        uint256 gracePeriodEndTimestamp;
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev Get the Reflex Circuit Breaker storage pointer.
     * @return storage_ Pointer to the Reflex Circuit Breaker storage state.
     */
    // solhint-disable-next-line func-name-mixedcase
    function _REFLEX_CIRCUIT_BREAKER_STORAGE() internal pure returns (ReflexCircuitBreakerStorage storage storage_) {
        assembly ("memory-safe") {
            storage_.slot := _REFLEX_CIRCUIT_BREAKER_STORAGE_SLOT
        }
    }
}
