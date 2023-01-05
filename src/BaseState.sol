// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseState} from "./interfaces/IBaseState.sol";

// Sources
import {BaseConstants} from "./BaseConstants.sol";

/**
 * @title Base State
 * @dev Append-only, extendable after __gap: first 50 slots (0-49) are reserved.
 *
 * @dev Storage layout:
 * | Name          | Type                                                | Slot | Offset | Bytes |
 * |---------------|-----------------------------------------------------|------|--------|-------|
 * | _owner        | address                                             | 0    | 0      | 20    |
 * | _pendingOwner | address                                             | 1    | 0      | 20    |
 * | _modules      | mapping(uint32 => address)                          | 2    | 0      | 32    |
 * | _proxies      | mapping(uint32 => address)                          | 3    | 0      | 32    |
 * | _trusts       | mapping(address => struct TBaseState.TrustRelation) | 4    | 0      | 32    |
 * | __gap         | uint256[45]                                         | 5    | 0      | 1440  |
 */
abstract contract BaseState is IBaseState, BaseConstants {
    // =======
    // Storage
    // =======

    /**
     * @notice Protocol owner.
     * @dev Slot 0 (20 bytes).
     */
    address internal _owner;

    /**
     * @notice Pending protocol owner.
     * @dev Slot 1 (20 bytes).
     */
    address internal _pendingOwner;

    /**
     * @notice Module id => module implementation.
     * @dev Slot 2 (32 bytes).
     */
    mapping(uint32 => address) internal _modules;

    /**
     * @notice Module id => proxy address (only for single-proxy modules).
     * @dev Slot 3 (32 bytes).
     */
    mapping(uint32 => address) internal _proxies;

    /**
     * @notice Proxy address => TrustRelation { moduleId, moduleImplementation }.
     * @dev Slot 4 (32 bytes).
     */
    mapping(address => TrustRelation) internal _trusts;

    /**
     * @notice This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * The size of the __gap array is calculated so that the amount of storage used by a
     * contract always adds up to the same number (in this case 50 storage slots, 0 to 49).
     * @dev Slot 5 (1440 bytes).
     */
    uint256[45] private __gap;
}
