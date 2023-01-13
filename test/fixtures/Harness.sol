// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

/**
 * @title Harness
 * @dev A rigorous testing and invariant harness.
 * @author `Users` has been modified from: PRBTest (https://github.com/PaulRBerg/prb-math/blob/main/test/BaseTest.t.sol)
 * @author `GasCapture` has been modified from: Solmate (https://github.com/transmissions11/solmate/blob/main/src/test/utils/DSTestPlus.sol)
 * @author `BrualizeMemory` has been copied from: Solady (https://github.com/Vectorized/solady/blob/main/test/utils/TestPlus.sol)
 */
abstract contract Harness is Test {
    // ======
    // Errors
    // ======

    error FailedSetup();

    error FreeMemoryPointerOverflowed();

    error ZeroSlotNotZero();

    error NotZeroRightPadded();

    error Not32ByteWordAligned();

    error InsufficientMemoryAllocation();

    error NoTargetContracts();

    // =======
    // Structs
    // =======

    struct Users {
        // solhint-disable-next-line var-name-mixedcase
        address payable Alice;
        // solhint-disable-next-line var-name-mixedcase
        address payable Bob;
        // solhint-disable-next-line var-name-mixedcase
        address payable Caroll;
        // solhint-disable-next-line var-name-mixedcase
        address payable Dave;
    }

    // =======
    // Storage
    // =======

    address[] private _targets;

    Users internal _users;

    string internal _gasLabel;
    uint256 internal _gasStart;
    uint256 internal _gasUsed;

    // =========
    // Modifiers
    // =========

    /**
     * @dev Modifier to perform a gas capture.
     */
    modifier GasCapture(string memory label_) {
        _startGasCapture(label_);

        _;

        _stopGasCapture();
    }

    /**
     * @dev Modifier to brutalize memory.
     */
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

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        address brutalizedAddress = _brutalizedAddress(address(0));
        bool brutalizedAddressIsBrutalized;

        /// @solidity memory-safe-assembly
        assembly {
            brutalizedAddressIsBrutalized := gt(shr(160, brutalizedAddress), 0)
        }

        if (!brutalizedAddressIsBrutalized) revert FailedSetup();

        _users = Users({
            Alice: _createUser("Alice"),
            Bob: _createUser("Bob"),
            Caroll: _createUser("Caroll"),
            Dave: _createUser("Dave")
        });
    }

    // ==============
    // Public methods
    // ==============

    /**
     * @dev Internal view for invariant testing.
     */
    function targetContracts() public view returns (address[] memory) {
        if (_targets.length == 0) revert NoTargetContracts();

        return _targets;
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev Add target contract for invariant testing.
     */
    function _addTargetContract(address newTargetContract_) internal {
        _targets.push(newTargetContract_);
    }

    // =========
    // Utilities
    // =========

    /**
     * @dev Create user address from user label.
     */
    function _createUser(string memory label_) internal returns (address payable user) {
        user = payable(address(uint160(uint256(keccak256(abi.encodePacked(label_))))));
        vm.label(user, label_);
        vm.deal(user, 100e18);
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

        console2.log(string(abi.encodePacked("[GAS] ", _gasLabel, "()")), _gasUsed);
    }

    /**
     * @dev Brutalize address space.
     */
    function _brutalizedAddress(address value_) private view returns (address result_) {
        /// @solidity memory-safe-assembly
        assembly {
            // Some acrobatics to make the brutalized bits psuedorandomly
            // different with every call.
            mstore(0x00, or(calldataload(0), mload(0x40)))
            mstore(0x20, or(caller(), mload(0x00)))
            result_ := or(shl(160, keccak256(0x00, 0x40)), value_)
            mstore(0x40, add(0x20, mload(0x40)))
            mstore(0x00, result_)
        }
    }

    /**
     * @dev Internal memory check.
     */
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

        if (freeMemoryPointerOverflowed) revert FreeMemoryPointerOverflowed();
        if (zeroSlotIsNotZero) revert ZeroSlotNotZero();
    }

    /**
     * @dev Internal memory check.
     */
    function _checkMemory(bytes memory s_) internal pure {
        bool notZeroRightPadded;
        bool fmpNotWordAligned;
        bool insufficientMalloc;

        /// @solidity memory-safe-assembly
        assembly {
            let length := mload(s_)
            let lastWord := mload(add(add(s_, 0x20), and(length, not(31))))
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
                if gt(add(add(s_, 0x20), length), mload(0x40)) {
                    insufficientMalloc := 1
                }
            }
        }

        if (notZeroRightPadded) revert NotZeroRightPadded();
        if (fmpNotWordAligned) revert Not32ByteWordAligned();
        if (insufficientMalloc) revert InsufficientMemoryAllocation();

        _checkMemory();
    }

    /**
     * @dev Internal memory check.
     */
    function _checkMemory(string memory s_) internal pure {
        _checkMemory(bytes(s_));
    }

    // =====
    // Casts
    // =====

    /**
     * @dev Cast bool to uint8.
     */
    function _castBoolToUInt8(bool x_) internal pure returns (uint8 r_) {
        assembly {
            r_ := x_
        }
    }
}
