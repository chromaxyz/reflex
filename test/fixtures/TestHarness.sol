// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
// solhint-disable-next-line no-console
import {console2} from "forge-std/console2.sol";
import {Test} from "forge-std/Test.sol";

// Fixtures
import {Users} from "./Users.sol";

/**
 * @title Test Harness
 *
 * @dev A rigorous testing and invariant harness.
 *
 * @author `brutalizeMemory` has been copied from: Solady
 * (https://github.com/Vectorized/solady/blob/main/test/utils/TestPlus.sol) (MIT)
 */
abstract contract TestHarness is Users, Test {
    // ======
    // Errors
    // ======

    error FailedSetup();

    error FreeMemoryPointerOverflowed();

    error ZeroSlotNotZero();

    error NotZeroRightPadded();

    error Not32ByteWordAligned();

    error InsufficientMemoryAllocation();

    // =======
    // Storage
    // =======

    string internal _profile;

    string internal _gasLabel;
    uint256 internal _gasStart;
    uint256 internal _gasUsed;

    uint256 internal _currentTimestamp;
    uint256[] internal _timestamps;
    uint256 internal _timestampCount;

    // =========
    // Modifiers
    // =========

    /**
     * @dev Modifier to perform a gas capture.
     */
    modifier captureGas(string memory label_) {
        _startGasCapture(label_);

        _;

        _stopGasCapture();
    }

    /**
     * @dev Modifier to brutalize memory.
     * Fills the memory with junk, for more robust testing of inline assembly which reads / writes to the memory.
     */
    modifier brutalizeMemory() {
        // To prevent a solidity 0.8.13 bug.
        // See: https://blog.soliditylang.org/2022/06/15/inline-assembly-memory-side-effects-bug
        // Basically, we need to access a solidity variable from the assembly to
        // tell the compiler that this assembly block is not in isolation.
        {
            uint256 zero;

            assembly ("memory-safe") {
                let offset := mload(0x40) // Start the offset at the free memory pointer.
                calldatacopy(offset, zero, calldatasize())

                // Fill the 64 bytes of scratch space with garbage.
                mstore(zero, caller())
                mstore(0x20, keccak256(offset, calldatasize()))
                mstore(zero, keccak256(zero, 0x40))

                let r0 := mload(zero)
                let r1 := mload(0x20)

                let cSize := add(codesize(), iszero(codesize()))
                if iszero(lt(cSize, 32)) {
                    cSize := sub(cSize, and(mload(0x02), 31))
                }
                let start := mod(mload(0x10), cSize)
                let size := mul(sub(cSize, start), gt(cSize, start))
                let times := div(0x7ffff, cSize)
                if iszero(lt(times, 128)) {
                    times := 128
                }

                // Occasionally offset the offset by a psuedorandom large amount.
                // Can't be too large, or we will easily get out-of-gas errors.
                offset := add(offset, mul(iszero(and(r1, 0xf)), and(r0, 0xfffff)))

                // Fill the free memory with garbage.
                for {
                    let w := not(0)
                } 1 {

                } {
                    mstore(offset, r0)
                    mstore(add(offset, 0x20), r1)
                    offset := add(offset, 0x40)
                    // We use codecopy instead of the identity precompile
                    // to avoid polluting the `forge test -vvvv` output with tons of junk.
                    codecopy(offset, start, size)
                    codecopy(add(offset, size), 0, start)
                    offset := add(offset, cSize)
                    times := add(times, w) // `sub(times, 1)`.
                    if iszero(times) {
                        break
                    }
                }
            }
        }

        _;

        // Check if the free memory pointer and the zero slot are not contaminated.
        // Useful for cases where these slots are used for temporary storage.
        bool zeroSlotIsNotZero;
        bool freeMemoryPointerOverflowed;

        assembly ("memory-safe") {
            // Write ones to the free memory, to make subsequent checks fail if
            // insufficient memory is allocated.
            mstore(mload(0x40), not(0))

            // Test at a lower, but reasonable limit for more safety room.
            if gt(mload(0x40), 0xffffffff) {
                freeMemoryPointerOverflowed := 1
            }

            // Check the value of the zero slot.
            zeroSlotIsNotZero := mload(0x60)
        }

        if (freeMemoryPointerOverflowed) revert FreeMemoryPointerOverflowed();
        if (zeroSlotIsNotZero) revert ZeroSlotNotZero();
    }

    // ===========
    // Constructor
    // ===========

    constructor() {
        _profile = vm.envOr("FOUNDRY_PROFILE", string("default"));
    }

    // =========
    // Utilities
    // =========

    /**
     * @dev Check if the profile is active.
     */
    function _isProfile(string memory profile_) internal view returns (bool) {
        return (keccak256(abi.encodePacked((_profile))) == keccak256(abi.encodePacked((profile_))));
    }

    /**
     * @dev Start a gas capture log.
     */
    function _startGasCapture(string memory label_) internal {
        _gasLabel = label_;
        _gasStart = gasleft();
    }

    /**
     * @dev Finish a gas capture log and log the result.
     */
    function _stopGasCapture() internal {
        _gasUsed = _gasStart - gasleft();

        // solhint-disable-next-line no-console
        console2.log(string(abi.encodePacked("[GAS] ", _gasLabel, "()")), _gasUsed);
    }
}
