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
    struct ReflexStorage {
        /**
         * @dev Global reentrancy status tracker.
         * @dev Slot 0 (32 bytes).
         */
        uint256 reentrancyStatus;
        /**
         * @dev Owner address.
         * @dev Storage slot: 1 (20 bytes).
         */
        address owner;
        /**
         * @dev Pending owner address.
         * @dev Storage slot: 2 (20 bytes).
         */
        address pendingOwner;
        /**
         * @dev Internal module mapping.
         * @dev Module id => module implementation.
         * @dev Storage slot: 3 (32 bytes).
         */
        mapping(uint32 => address) modules;
        /**
         * @dev Internal endpoint mapping.
         * @dev Module id => endpoint address (only for single-endpoint modules).
         * @dev Storage slot: 4 (32 bytes).
         */
        mapping(uint32 => address) endpoints;
        /**
         * @dev Internal endpoint to module relation mapping.
         * @dev Endpoint address => TrustRelation { moduleId, moduleType, moduleImplementation }.
         * @dev Storage slot: 5 (32 bytes).
         */
        mapping(address => TrustRelation) relations;
    }

    function _s() internal pure returns (ReflexStorage storage s_) {
        bytes32 slot = _REFLEX_STORAGE;

        assembly {
            s_.slot := slot
        }
    }
}
