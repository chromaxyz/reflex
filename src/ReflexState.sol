// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IReflexState} from "./interfaces/IReflexState.sol";

// Sources
import {ReflexConstants} from "./ReflexConstants.sol";

/**
 * @title Reflex State
 * @dev Append-only extendable, only after __gap: first 50 slots (0-49) are reserved!
 *
 * @dev Storage layout:
 * | Name            | Type                                                  | Slot | Offset | Bytes |
 * |-----------------|-------------------------------------------------------|------|--------|-------|
 * | _reentrancyLock | uint256                                               | 0    | 0      | 32    |
 * | _owner          | address                                               | 1    | 0      | 20    |
 * | _pendingOwner   | address                                               | 2    | 0      | 20    |
 * | _modules        | mapping(uint32 => address)                            | 3    | 0      | 32    |
 * | _proxies        | mapping(uint32 => address)                            | 4    | 0      | 32    |
 * | _relations      | mapping(address => struct TReflexState.TrustRelation) | 5    | 0      | 32    |
 * | __gap           | uint256[44]                                           | 6    | 0      | 1408  |
 */
abstract contract ReflexState is IReflexState, ReflexConstants {
    // =======
    // Storage
    // =======

    /**
     * @notice Global reentrancy lock.
     * @dev Slot 0 (32 bytes).
     */
    uint256 internal _reentrancyLock;

    /**
     * @notice Owner address.
     * @dev Slot 1 (20 bytes).
     */
    address internal _owner;

    /**
     * @notice Pending owner address.
     * @dev Slot 2 (20 bytes).
     */
    address internal _pendingOwner;

    /**
     * @notice Internal module mapping.
     * @dev Module id => module implementation.
     * @dev Slot 3 (32 bytes).
     */
    mapping(uint32 => address) internal _modules;

    /**
     * @notice Internal proxy mapping.
     * @dev Module id => proxy address (only for single-proxy modules).
     * @dev Slot 4 (32 bytes).
     */
    mapping(uint32 => address) internal _proxies;

    /**
     * @notice Internal proxy to module relation mapping.
     * @dev Proxy address => TrustRelation { moduleId, moduleType, moduleImplementation }.
     * @dev Slot 5 (32 bytes).
     */
    mapping(address => TrustRelation) internal _relations;

    /**
     * @notice This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * The size of the __gap array is calculated so that the amount of storage used by a
     * contract always adds up to the same number (in this case 50 storage slots, 0 to 49).
     * @dev Slot 6 (1408 bytes).
     */
    uint256[44] private __gap;
}
