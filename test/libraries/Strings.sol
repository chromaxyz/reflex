// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @dev String library.
 * @author `toString` has been copied from: Solady (https://github.com/Vectorized/solady/blob/main/src/utils/LibString.sol) (MIT)
 */
library Strings {
    /**
     * @dev Returns the base 10 decimal representation of `value`.
     */
    function toString(uint256 value_) internal pure returns (string memory str_) {
        /// @solidity memory-safe-assembly
        assembly {
            // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
            // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
            // We will need 1 word for the trailing zeros padding, 1 word for the length,
            // and 3 words for a maximum of 78 digits.
            str_ := add(mload(0x40), 0x80)
            // Update the free memory pointer to allocate.
            mstore(0x40, add(str_, 0x20))
            // Zeroize the slot after the string.
            mstore(str_, 0)

            // Cache the end of the memory to calculate the length later.
            let end := str_

            let w := not(0) // Tsk.
            // We write the string from rightmost digit to leftmost digit.
            // The following is essentially a do-while loop that also handles the zero case.
            for {
                let temp := value_
            } 1 {

            } {
                str_ := add(str_, w) // `sub(str_, 1)`.
                // Write the character to the pointer.
                // The ASCII index of the '0' character is 48.
                mstore8(str_, add(48, mod(temp, 10)))
                // Keep dividing `temp` until zero.
                temp := div(temp, 10)
                if iszero(temp) {
                    break
                }
            }

            let length := sub(end, str_)
            // Move the pointer 32 bytes leftwards to make room for the length.
            str_ := sub(str_, 0x20)
            // Store the length.
            mstore(str_, length)
        }
    }
}
