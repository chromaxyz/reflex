// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexStorage} from "./interfaces/IReflexStorage.sol";

// Sources
import {ReflexConstants} from "./ReflexConstants.sol";

/**
 * @title Reflex Storage
 * @dev Append-only extendable.
 */
abstract contract ReflexStorage is IReflexStorage, ReflexConstants {
    // =========
    // Constants
    // =========

    /**
     * @dev Storage entrypoint of Reflex.
     * @dev `bytes32(keccak256(abi.encode(uint256(keccak256("reflex")) - 1)) & ~bytes32(uint256(0xff)))`
     * Uses EIP-7201 Namespaced Storage Layout: https://eips.ethereum.org/EIPS/eip-7201
     * The formula is chosen to be safe against collisions with the standard Solidity storage layout.
     */
    bytes32 internal constant _REFLEX_STORAGE_SLOT = 0x73ad830a85e52f69177de11e47bee176868f5b16670f49ea9de2fc41c4c0f900;

    /**
     * @dev Storage slot of the global reentrancy status tracker.
     * @dev `_REFLEX_STORAGE_LAYOUT + 0`
     */
    uint256 internal constant _REFLEX_STORAGE_REENTRANCY_STATUS_SLOT =
        0x73ad830a85e52f69177de11e47bee176868f5b16670f49ea9de2fc41c4c0f900 + 0;

    /**
     * @dev Storage slot of the owner address.
     * @dev `_REFLEX_STORAGE_LAYOUT + 1`
     */
    uint256 internal constant _REFLEX_STORAGE_OWNER_SLOT =
        0x73ad830a85e52f69177de11e47bee176868f5b16670f49ea9de2fc41c4c0f900 + 1;

    /**
     * @dev Storage slot of the pending owner address.
     * @dev `_REFLEX_STORAGE_LAYOUT + 2`
     */
    uint256 internal constant _REFLEX_STORAGE_PENDING_OWNER_SLOT =
        0x73ad830a85e52f69177de11e47bee176868f5b16670f49ea9de2fc41c4c0f900 + 2;

    /**
     * @dev Storage slot of the module mapping.
     * @dev `_REFLEX_STORAGE_LAYOUT + 3`
     */
    uint256 internal constant _REFLEX_STORAGE_MODULES_SLOT =
        0x73ad830a85e52f69177de11e47bee176868f5b16670f49ea9de2fc41c4c0f900 + 3;

    /**
     * @dev Storage slot of the endpoint mapping.
     * @dev `_REFLEX_STORAGE_LAYOUT + 4`
     */
    uint256 internal constant _REFLEX_STORAGE_ENDPOINTS_SLOT =
        0x73ad830a85e52f69177de11e47bee176868f5b16670f49ea9de2fc41c4c0f900 + 4;

    /**
     * @dev Storage slot of the endpoint to module relation mapping.
     * @dev `_REFLEX_STORAGE_LAYOUT + 5`
     */
    uint256 internal constant _REFLEX_STORAGE_RELATIONS_SLOT =
        0x73ad830a85e52f69177de11e47bee176868f5b16670f49ea9de2fc41c4c0f900 + 5;

    // =======
    // Storage
    // =======

    /**
     * @dev Append-only extendable.
     */
    /// @custom:storage-location erc7201:reflex
    struct ReflexStorageLayout {
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
     * @return storage_ Pointer to the Reflex storage slot.
     */
    // solhint-disable-next-line func-name-mixedcase
    function _REFLEX_STORAGE() internal pure returns (ReflexStorageLayout storage storage_) {
        assembly ("memory-safe") {
            storage_.slot := _REFLEX_STORAGE_SLOT
        }
    }
}
