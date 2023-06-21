// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexState} from "./interfaces/IReflexState.sol";

// Sources
import {ReflexConstants} from "./ReflexConstants.sol";

/**
 * @title Reflex State
 * @dev Append-only extendable, only after __REFLEX_GAP: first 50 slots (0-49) are reserved!
 *
 * @dev Storage layout:
 * | Name               | Type                                                  | Slot | Offset | Bytes |
 * | ------------------ | ----------------------------------------------------- | ---- | ------ | ----- |
 * | _reentrancyStatus  | uint256                                               | 0    | 0      | 32    |
 * | _owner             | address                                               | 1    | 0      | 20    |
 * | _pendingOwner      | address                                               | 2    | 0      | 20    |
 * | _modules           | mapping(uint32 => address)                            | 3    | 0      | 32    |
 * | _endpoints         | mapping(uint32 => address)                            | 4    | 0      | 32    |
 * | _relations         | mapping(address => struct IReflexState.TrustRelation) | 5    | 0      | 32    |
 * | __REFLEX_GAP       | uint256[44]                                           | 6    | 0      | 1408  |
 */

abstract contract ReflexState is IReflexState, ReflexConstants {
    // ======
    // Global
    // ======

    /**
     * @dev Global reentrancy status tracker.
     * @dev Slot 0 (32 bytes).
     */
    uint256 internal _reentrancyStatus;

    // =========
    // Ownership
    // =========

    /**
     * @dev Owner address.
     * @dev Storage slot: 1 (20 bytes).
     */
    address internal _owner;

    /**
     * @dev Pending owner address.
     * @dev Storage slot: 2 (20 bytes).
     */
    address internal _pendingOwner;

    // =======
    // Modules
    // =======

    /**
     * @dev Internal module mapping.
     * @dev Module id => module implementation.
     * @dev Storage slot: 3 (32 bytes).
     */
    mapping(uint32 => address) internal _modules;

    /**
     * @dev Internal endpoint mapping.
     * @dev Module id => endpoint address (only for single-endpoint modules).
     * @dev Storage slot: 4 (32 bytes).
     */
    mapping(uint32 => address) internal _endpoints;

    /**
     * @dev Internal endpoint to module relation mapping.
     * @dev Endpoint address => TrustRelation { moduleId, moduleType, moduleImplementation }.
     * @dev Storage slot: 5 (32 bytes).
     */
    mapping(address => TrustRelation) internal _relations;

    // ======
    // Spacer
    // ======

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * The size of the `__REFLEX_GAP` array is calculated so that the amount of storage used by a
     * contract always adds up to the same number.
     * @dev Reflex occupies storage slots 0 to 49 (50 in total).
     * @dev Storage slot: 6 (1408 bytes).
     */
    // solhint-disable-next-line var-name-mixedcase
    uint256[44] private __REFLEX_GAP;
}
