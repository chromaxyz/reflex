// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseState} from "./interfaces/IBaseState.sol";

// Sources
import {BaseConstants} from "./BaseConstants.sol";

/**
 * @title Base State
 * @dev Append-only extendable
 */
abstract contract BaseState is IBaseState, BaseConstants {
    // =======
    // Storage
    // =======

    /**
     * @notice Protocol name.
     * @dev Slot 0 (32 bytes)
     */
    string internal _name;

    /**
     * @notice Protocol owner.
     * @dev Slot 1 (20 bytes)
     */
    address internal _owner;

    /**
     * @notice Pending protocol owner.
     * @dev Slot 2 (20 bytes)
     */
    address internal _pendingOwner;

    /**
     * @notice Module id => module implementation.
     * @dev Slot 3 (32 bytes)
     */
    mapping(uint32 => address) internal _modules;

    /**
     * @notice Module id => proxy address (only for single-proxy modules).
     * @dev Slot 4 (32 bytes)
     */
    mapping(uint32 => address) internal _proxies;

    /**
     * @notice Proxy address => TrustRelation { moduleId, moduleImplementation }.
     * @dev Slot 5 (32 bytes)
     */
    mapping(address => TrustRelation) internal _trusts;

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * The size of the __gap array is calculated so that the amount of storage used by a
     * contract always adds up to the same number (in this case 50 storage slots).
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[45] private __gap;
}
