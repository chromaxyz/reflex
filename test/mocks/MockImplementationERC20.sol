// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Mocks
import {ImplementationERC20} from "../mocks/abstracts/ImplementationERC20.sol";

/**
 * @title Mock Implementation ERC20
 */
contract MockImplementationERC20 is ImplementationERC20 {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) ImplementationERC20(moduleSettings_) {}

    // ==========
    // Test stubs
    // ==========

    function emitTransferEvent(address proxyAddress_, address from_, address to_, uint256 amount_) external {
        _emitTransferEvent(proxyAddress_, from_, to_, amount_);
    }

    function emitApprovalEvent(address proxyAddress_, address owner_, address spender_, uint256 amount_) external {
        _emitApprovalEvent(proxyAddress_, owner_, spender_, amount_);
    }

    function mint(address to, uint256 value) external {
        _mint(to, value);
    }

    function burn(address from, uint256 value) external {
        _burn(from, value);
    }
}
