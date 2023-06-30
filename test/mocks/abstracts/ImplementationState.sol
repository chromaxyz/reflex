// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexState} from "../../../src/ReflexState.sol";

/**
 * @title Implementation State
 */
abstract contract ImplementationState is ReflexState {
    // =========
    // Constants
    // =========

    /**
     * @dev `bytes32(uint256(keccak256("_IMPLEMENTATION_STORAGE")) - 1)`
     * A `-1` offset is added so the preimage of the hash cannot be known,
     * reducing the chances of a possible attack.
     */
    bytes32 internal constant _IMPLEMENTATION_STORAGE_SLOT =
        0xf8509337ad8a230e85046288664a1364ac578e6500ef88157efd044485b8c20a;

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
            storage_.slot := _IMPLEMENTATION_STORAGE_SLOT
        }
    }

    // ==========
    // Test stubs
    // ==========

    function REFLEX_STORAGE_SLOT() public pure returns (bytes32) {
        return _REFLEX_STORAGE_SLOT;
    }

    function IMPLEMENTATION_STORAGE_SLOT() public pure returns (bytes32) {
        return _IMPLEMENTATION_STORAGE_SLOT;
    }

    function setImplementationState0(bytes32 message_) public {
        _IMPLEMENTATION_STORAGE().implementationState0 = message_;
    }

    function getImplementationState0() public view returns (bytes32) {
        return _IMPLEMENTATION_STORAGE().implementationState0;
    }

    function setImplementationState(
        bytes32 message_,
        uint256 number_,
        address target_,
        address tokenA_,
        address tokenB_,
        bool flag_
    ) public {
        _IMPLEMENTATION_STORAGE().implementationState0 = message_;

        _IMPLEMENTATION_STORAGE().implementationState1 = number_;

        _IMPLEMENTATION_STORAGE().implementationState2 = target_;

        _IMPLEMENTATION_STORAGE().implementationState3 = target_;

        _IMPLEMENTATION_STORAGE().implementationState4 = flag_;

        _IMPLEMENTATION_STORAGE().implementationState5[target_] = number_;

        _IMPLEMENTATION_STORAGE().tokens[tokenA_].name = "Token A";
        _IMPLEMENTATION_STORAGE().tokens[tokenA_].symbol = "TKNA";
        _IMPLEMENTATION_STORAGE().tokens[tokenA_].decimals = 18;

        _IMPLEMENTATION_STORAGE().tokens[tokenB_].name = "Token B";
        _IMPLEMENTATION_STORAGE().tokens[tokenB_].symbol = "TKNB";
        _IMPLEMENTATION_STORAGE().tokens[tokenB_].decimals = 18;
    }

    // =========
    // Utilities
    // =========

    function sload(bytes32 slot_) public view returns (bytes32 result_) {
        assembly ("memory-safe") {
            result_ := sload(slot_)
        }
    }

    function sload(bytes32 startSlot_, uint256 slotCount_) public view returns (bytes memory result_) {
        result_ = new bytes(32 * slotCount_);

        assembly ("memory-safe") {
            for {
                let i := 0
            } lt(i, slotCount_) {
                i := add(i, 1)
            } {
                mstore(add(result_, mul(add(i, 1), 32)), sload(add(startSlot_, i)))
            }
        }
    }
}
