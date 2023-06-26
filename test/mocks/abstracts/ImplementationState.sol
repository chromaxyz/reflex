// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexState} from "../../../src/ReflexState.sol";

/**
 * @title Implementation State
 */
abstract contract ImplementationState is ReflexState {
    // =======
    // Structs
    // =======

    struct Token {
        string name;
        string symbol;
        uint8 decimals;
        uint256 totalSupply;
        mapping(address => uint256) balanceOf;
        mapping(address => mapping(address => uint256)) allowance;
        mapping(address => uint256) nonces;
    }

    // =======
    // Storage
    // =======

    /**
     * @dev Append-only extendable.
     */
    struct ImplementationStorage {
        /**
         * @notice Implementation state 0.
         */
        bytes32 implementationState0;
        /**
         * @notice Implementation state 1.
         */
        uint256 implementationState1;
        /**
         * @notice Implementation state 2.
         */
        address implementationState2;
        /**
         * @notice Implementation state 3.
         */
        address implementationState3;
        /**
         * @notice Implementation state 4.
         */
        bool implementationState4;
        /**
         * @notice Implementation state 5.
         */
        mapping(address => uint256) implementationState5;
        /**
         * @notice Token mapping.
         */
        mapping(address => Token) tokens;
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev Get the Implementation storage pointer.
     * @return storage_ Pointer to the Implementation storage state.
     */
    function _IMPLEMENTATION_STORAGE() internal pure returns (ImplementationStorage storage storage_) {
        assembly {
            // keccak256("diamond.storage.implementation");
            storage_.slot := 0x0bb48b320f315d19be28d4978081415a136259679ad5feb20491088c12441c20
        }
    }
}
