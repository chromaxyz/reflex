// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseState} from "./interfaces/IBaseState.sol";

/**
 * @title Base Constants
 * @dev Append-only extendable, only use internal constants!
 */
abstract contract BaseConstants {
    // =========
    // Constants
    // =========

    // TODO: replace with enum?

    /**
     * @dev These are modules that are only accessible by a single address.
     */
    uint16 internal constant _MODULE_TYPE_SINGLE_PROXY = 1;

    /**
     * @dev These are modules that have many addresses.
     */
    uint16 internal constant _MODULE_TYPE_MULTI_PROXY = 2;

    /**
     * @dev These are modules that are called internally by the system and don't have any public proxies.
     */
    uint16 internal constant _MODULE_TYPE_INTERNAL = 3;

    /**
     * @dev Module id of built-in upgradeable installer module.
     */
    uint32 internal constant _BUILT_IN_MODULE_ID_INSTALLER = 1;
}

/**
 * @title Base State
 * @dev Append-only extendable below __gap.
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
     * @notice This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * The size of the __gap array is calculated so that the amount of storage used by a
     * contract always adds up to the same number (in this case 50 storage slots).
     * @dev Slot 6 (1440 bytes)
     */
    uint256[45] private __gap;
}
