// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {console2} from "forge-std/console2.sol";

/**
 * @title Harness
 * @dev `GasCapture` has been copied from: Solmate (https://github.com/transmissions11/solmate/blob/main/src/test/utils/DSTestPlus.sol)
 * @dev `BrualizeMemory` has been copied from: Solady (https://github.com/Vectorized/solady/blob/main/test/utils/TestPlus.sol)
 */
abstract contract Harness {
    // =======
    // Storage
    // =======

    string internal _gasLabel;
    uint256 internal _gasStart;
    uint256 internal _gasUsed;

    // =========
    // Modifiers
    // =========

    modifier GasCapture(string memory label_) {
        _startGasCapture(label_);

        _;

        _stopGasCapture();
    }

    modifier BrutalizeMemory() {
        /// @solidity memory-safe-assembly
        assembly {
            let offset := mload(0x40) // Start the offset at the free memory pointer.
            calldatacopy(offset, 0, calldatasize())

            // Fill the 64 bytes of scratch space with garbage.
            mstore(0x00, xor(gas(), calldatasize()))
            mstore(0x20, xor(caller(), keccak256(offset, calldatasize())))
            mstore(0x00, keccak256(0x00, 0x40))
            mstore(0x20, keccak256(0x00, 0x40))

            let size := 0x40 // Start with 2 slots.
            mstore(offset, mload(0x00))
            mstore(add(offset, 0x20), mload(0x20))

            for {
                let i := add(11, and(mload(0x00), 1))
            } 1 {

            } {
                let nextOffset := add(offset, size)
                // Duplicate the data.
                pop(
                    staticcall(
                        gas(), // Pass along all the gas in the call.
                        0x04, // Call the identity precompile address.
                        offset, // Offset is the bytes' pointer.
                        size, // We want to pass the length of the bytes.
                        nextOffset, // Store the return value at the next offset.
                        size // Since the precompile just returns its input, we reuse size.
                    )
                )
                // Duplicate the data again.
                returndatacopy(add(nextOffset, size), 0, size)
                offset := nextOffset
                size := mul(2, size)

                i := sub(i, 1)

                if iszero(i) {
                    break
                }
            }
        }

        _;

        _checkMemory();
    }

    // =========
    // Utilities
    // =========

    function _startGasCapture(string memory label_) internal {
        _gasLabel = label_;
        _gasStart = gasleft();
    }

    function _stopGasCapture() internal {
        _gasUsed = _gasStart - gasleft();

        console2.log(string(abi.encodePacked("[GAS] ", _gasLabel)), _gasUsed);
    }

    function _checkMemory() internal pure {
        bool zeroSlotIsNotZero;
        bool freeMemoryPointerOverflowed;

        /// @solidity memory-safe-assembly
        assembly {
            // Test at a lower, but reasonable limit for more safety room.
            if gt(mload(0x40), 0xffffffff) {
                freeMemoryPointerOverflowed := 1
            }
            // Check the value of the zero slot.
            zeroSlotIsNotZero := mload(0x60)
        }

        if (freeMemoryPointerOverflowed)
            revert("Free memory pointer overflowed!");
        if (zeroSlotIsNotZero) revert("Zero slot is not zero!");
    }

    function _checkMemory(bytes memory s) internal pure {
        bool notZeroRightPadded;
        bool fmpNotWordAligned;
        bool insufficientMalloc;

        /// @solidity memory-safe-assembly
        assembly {
            let length := mload(s)
            let lastWord := mload(add(add(s, 0x20), and(length, not(31))))
            let remainder := and(length, 31)
            if remainder {
                if shl(mul(8, remainder), lastWord) {
                    notZeroRightPadded := 1
                }
            }
            // Check if the free memory pointer is a multiple of 32.
            fmpNotWordAligned := and(mload(0x40), 31)
            // Write some garbage to the free memory.
            mstore(mload(0x40), keccak256(0x00, 0x60))
            // Check if the memory allocated is sufficient.
            if length {
                if gt(add(add(s, 0x20), length), mload(0x40)) {
                    insufficientMalloc := 1
                }
            }
        }

        if (notZeroRightPadded) revert("Not zero right padded!");
        if (fmpNotWordAligned)
            revert("Free memory pointer `0x40` not 32-byte word aligned!");
        if (insufficientMalloc) revert("Insufficient memory allocation!");

        _checkMemory();
    }

    function _checkMemory(string memory s) internal pure {
        _checkMemory(bytes(s));
    }
}
