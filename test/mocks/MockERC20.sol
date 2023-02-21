// // SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Mocks
import {ExternalERC20} from "./abstracts/ExternalERC20.sol";

/**
 * @title Mock ERC20
 */
contract MockERC20 is ExternalERC20 {
    // ======
    // Errors
    // ======

    error KnownViewError();

    // ===========
    // Constructor
    // ===========

    /**
     * @param name_ Token name.
     * @param symbol_ Token symbol.
     * @param decimals_ Token decimals.
     */
    constructor(string memory name_, string memory symbol_, uint8 decimals_) ExternalERC20(name_, symbol_, decimals_) {}

    // ==========
    // Test stubs
    // ==========

    function getRevert() external pure {
        revert KnownViewError();
    }

    function mint(address to, uint256 value) external {
        _mint(to, value);
    }
}
