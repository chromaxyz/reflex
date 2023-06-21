// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Mocks
import {ImplementationERC20} from "../mocks/abstracts/ImplementationERC20.sol";

/**
 * @title Mock Implementation ERC20 Malicious Storage Module
 */
contract MockImplementationERC20MaliciousStorageModule is ImplementationERC20 {
    // =======
    // Storage
    // =======

    /**
     * @dev NOTE: DO NOT IMPLEMENT STORAGE INSIDE OF MODULES!
     */
    uint8 internal _number;

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

    function emitTransferEvent(address endpointAddress_, address from_, address to_, uint256 amount_) external {
        _emitTransferEvent(endpointAddress_, from_, to_, amount_);
    }

    function emitApprovalEvent(address endpointAddress_, address owner_, address spender_, uint256 amount_) external {
        _emitApprovalEvent(endpointAddress_, owner_, spender_, amount_);
    }

    function mint(address to, uint256 value) external {
        _mint(to, value);
    }

    function burn(address from, uint256 value) external {
        _burn(from, value);
    }

    function setNumber(uint8 number_) external {
        _number = number_;
    }

    function getNumber() external view returns (uint8) {
        return _number;
    }
}
