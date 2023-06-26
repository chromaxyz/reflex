// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

/**
 * @title Mock Harness
 *
 * @dev A rigorous mock harness.
 *
 * @author `_brutalized` has been modified from: Solady
 * (https://github.com/Vectorized/solady/blob/main/test/utils/mocks/MockOwnableRoles.sol) (MIT)
 */
abstract contract MockHarness {
    // ======
    // Errors
    // ======

    error FailedSetup();

    // ===========
    // Constructor
    // ===========

    constructor() {
        address brutalizedAddress = _brutalize(address(0));

        bool brutalizedAddressIsBrutalized;

        assembly ("memory-safe") {
            brutalizedAddressIsBrutalized := gt(shr(160, brutalizedAddress), 0)
        }

        if (!brutalizedAddressIsBrutalized) revert FailedSetup();
    }

    // =========
    // Utilities
    // =========

    function _brutalize(address target_) internal view returns (address result_) {
        assembly ("memory-safe") {
            // Some acrobatics to make the brutalized bits psuedorandomly different with every call.
            mstore(0x00, or(calldataload(0), mload(0x40)))
            mstore(0x20, or(caller(), mload(0x00)))
            result_ := or(shl(160, keccak256(0x00, 0x40)), target_)
            mstore(0x40, add(0x20, mload(0x40)))
            mstore(0x00, result_)
        }
    }
}
