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

    // TODO: -1 from hash to limit possibility of imaging attack

    /**
     * @dev keccak256("_REFLEX_REENTRANCY_STATUS_SLOT")
     */
    uint256 internal constant _REFLEX_REENTRANCY_STATUS_SLOT =
        0x1bff8ab3819afe054abaaba433fee942dbce1acbdd3ad44b63eb7f3d7e3d7c6e;

    /**
     * @dev keccak256("_REFLEX_OWNER_SLOT")
     */
    uint256 internal constant _REFLEX_OWNER_SLOT = 0x66fab7470a1b172d24d8ec1c1d3df505a4d1eb23185fb8f2159b4246aee78dd6;

    /**
     * @dev keccak256("_REFLEX_PENDING_OWNER_SLOT")
     */
    uint256 internal constant _REFLEX_PENDING_OWNER_SLOT =
        0x43d58e38ef34a5f762d9d672aafc2d706086180fe1fcf198e09ba43e8d7a3c5e;

    /**
     * @dev keccak256("_REFLEX_MODULES_SLOT_SEED")
     */
    uint256 internal constant _REFLEX_MODULES_SLOT_SEED =
        0x91a1f036e880e7c8244fba94379b4206a47facaa75abae2de806d1a7ad5a370a;

    /**
     * @dev keccak256("_REFLEX_ENDPOINTS_SLOT_SEED")
     */
    uint256 internal constant _REFLEX_ENDPOINTS_SLOT_SEED =
        0x0b7d34a26331cb481013b0f921f34eb65d6d805e87ae8b1c26c5322189bd01f0;

    /**
     * @dev keccak256("_REFLEX_RELATIONS_SLOT_SEED")
     */
    uint256 internal constant _REFLEX_RELATIONS_SLOT_SEED =
        0xd4327baa3012917a5cc22095ac31337b16e8e246050939e4c43f84e2b2dfed28;

    // ========
    // Pointers
    // ========

    function _reentrancyStatus() internal view returns (uint256 status_) {
        assembly ("memory-safe") {
            status_ := sload(_REFLEX_REENTRANCY_STATUS_SLOT)
        }
    }

    function _modules(uint32 moduleId_) internal view returns (address module_) {}

    function _endpoints(uint32 moduleId_) internal view returns (address endpoint_) {}

    function _relations(address endpointAddress_) internal view returns (TrustRelation memory relation_) {}

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
        // uint256 reentrancyStatus;
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
        mapping(uint32 moduleId => address endpoint) endpoints;
        /**
         * @dev Endpoint to module relation mapping.
         * @dev Endpoint address => TrustRelation { moduleId, moduleType, moduleImplementation }.
         */
        mapping(address endpoint => TrustRelation) relations;
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev Get the Reflex storage pointer.
     * @return storage_ Pointer to the Reflex storage state.
     */
    function _REFLEX_STORAGE() internal pure returns (ReflexStorage storage storage_) {
        assembly {
            // keccak256("diamond.storage.reflex");
            storage_.slot := 0x9f740cd913da282c2da6d110fbad427f7416cb449a0c4a3d267e106487084557
        }
    }
}
