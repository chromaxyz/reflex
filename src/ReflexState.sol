// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexState} from "./interfaces/IReflexState.sol";

// Sources
import {ReflexConstants} from "./ReflexConstants.sol";

/**
 * @title Reflex State
 * @dev Append-only extendable.
 */
abstract contract ReflexState is IReflexState, ReflexConstants {
    // =========
    // Constants
    // =========

    /**
     * @dev `bytes32(uint256(keccak256("_REFLEX_STORAGE")) - 1)`
     * A `-1` offset is added so the preimage of the hash cannot be known,
     * reducing the chances of a possible attack.
     */
    bytes32 internal constant _REFLEX_STORAGE_SLOT = 0x9ae9f1beea1ab16fc6eb61501e697d7f95dba720bc92d8f5c0ec2c2a99f1ae09;

    /**
     * @dev Storage slot of the global reentrancy status tracker.
     * @dev `(uint256(keccak256("_REFLEX_STORAGE")) - 1) + 0`
     */
    uint256 internal constant _REFLEX_STORAGE_REENTRANCY_STATUS_SLOT =
        0x9ae9f1beea1ab16fc6eb61501e697d7f95dba720bc92d8f5c0ec2c2a99f1ae09 + 0;

    /**
     * @dev Storage slot of the owner address.
     * @dev `(uint256(keccak256("_REFLEX_STORAGE")) - 1) + 1`
     */
    uint256 internal constant _REFLEX_STORAGE_OWNER_SLOT =
        0x9ae9f1beea1ab16fc6eb61501e697d7f95dba720bc92d8f5c0ec2c2a99f1ae09 + 1;

    /**
     * @dev Storage slot of the pending owner address.
     * @dev `(uint256(keccak256("_REFLEX_STORAGE")) - 1) + 2`
     */
    uint256 internal constant _REFLEX_STORAGE_PENDING_OWNER_SLOT =
        0x9ae9f1beea1ab16fc6eb61501e697d7f95dba720bc92d8f5c0ec2c2a99f1ae09 + 2;

    /**
     * @dev Storage slot of the module mapping.
     * @dev `(uint256(keccak256("_REFLEX_STORAGE")) - 1) + 3`
     */
    uint256 internal constant _REFLEX_STORAGE_MODULES_SLOT =
        0x9ae9f1beea1ab16fc6eb61501e697d7f95dba720bc92d8f5c0ec2c2a99f1ae09 + 3;

    /**
     * @dev Storage slot of the endpoint mapping.
     * @dev `(uint256(keccak256("_REFLEX_STORAGE")) - 1) + 4`
     */
    uint256 internal constant _REFLEX_STORAGE_ENDPOINTS_SLOT =
        0x9ae9f1beea1ab16fc6eb61501e697d7f95dba720bc92d8f5c0ec2c2a99f1ae09 + 4;

    /**
     * @dev Storage slot of the endpoint to module relation mapping.
     * @dev `(uint256(keccak256("_REFLEX_STORAGE")) - 1) + 5`
     */
    uint256 internal constant _REFLEX_STORAGE_RELATIONS_SLOT =
        0x9ae9f1beea1ab16fc6eb61501e697d7f95dba720bc92d8f5c0ec2c2a99f1ae09 + 5;

    // =======
    // Storage
    // =======

    /**
     * @dev Append-only extendable.
     */
    struct ReflexStorage {
        /**
         * @dev Global reentrancy status tracker.
         */
        uint256 reentrancyStatus;
        /**
         * @dev Owner address.
         */
        address owner;
        /**
         * @dev Pending owner address.
         */
        address pendingOwner;
        /**
         * @dev Module mapping.
         * @dev Module id => module implementation.
         */
        mapping(uint32 => address) modules;
        /**
         * @dev Endpoint mapping.
         * @dev Module id => endpoint address (only for single-endpoint modules).
         */
        mapping(uint32 => address) endpoints;
        /**
         * @dev Endpoint to module relation mapping.
         * @dev Endpoint address => TrustRelation { moduleId, moduleType, moduleImplementation }.
         */
        mapping(address => TrustRelation) relations;
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev Get the Reflex storage pointer.
     * @return storage_ Pointer to the Reflex storage state.
     */
    // solhint-disable-next-line func-name-mixedcase
    function _REFLEX_STORAGE() internal pure returns (ReflexStorage storage storage_) {
        assembly ("memory-safe") {
            storage_.slot := _REFLEX_STORAGE_SLOT
        }
    }
}
