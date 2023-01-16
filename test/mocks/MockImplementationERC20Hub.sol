// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Implementations
import {ImplementationState} from "../implementations/ImplementationState.sol";

// Mocks
import {MockBaseModule} from "../mocks/MockBaseModule.sol";

/**
 * @title Mock Implementation ERC20 Hub
 */
contract MockImplementationERC20Hub is MockBaseModule, ImplementationState {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleConfiguration_ Module configuration.
     */
    constructor(ModuleConfiguration memory moduleConfiguration_) MockBaseModule(moduleConfiguration_) {}

    // ==========
    // Test stubs
    // ==========

    function addERC20(
        uint32 moduleId_,
        uint16 moduleType_,
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) external returns (address tokenProxy_) {
        tokenProxy_ = _createProxy(moduleId_, moduleType_);

        Token storage token = _tokens[tokenProxy_];

        token.name = name_;
        token.symbol = symbol_;
        token.decimals = decimals_;

        return tokenProxy_;
    }
}
