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
        mapping(uint32 moduleId => address moduleImplementation) modules;
        /**
         * @dev Endpoint mapping.
         * @dev Module id => endpoint address (only for single-endpoint modules).
         */
        mapping(uint32 moduleId => address endpointAddress) endpoints;
        /**
         * @dev Endpoint to module relation mapping.
         * @dev Endpoint address => TrustRelation { moduleId, moduleType, moduleImplementation }.
         */
        mapping(address endpointAddress => TrustRelation) relations;
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev Get the storage pointer.
     * @return storage_ Storage pointer.
     */
    function _REFLEX_STORAGE() internal pure returns (ReflexStorage storage storage_) {
        assembly {
            // keccak256("diamond.storage.reflex");
            storage_.slot := 0x9f740cd913da282c2da6d110fbad427f7416cb449a0c4a3d267e106487084557
        }
    }
}
