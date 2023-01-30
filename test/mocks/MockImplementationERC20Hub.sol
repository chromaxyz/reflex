// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Mocks
import {ImplementationState} from "./abstracts/ImplementationState.sol";
import {MockReflexModule} from "../mocks/MockReflexModule.sol";

/**
 * @title Mock Implementation ERC20 Hub
 */
contract MockImplementationERC20Hub is MockReflexModule, ImplementationState {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockReflexModule(moduleSettings_) {}

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
        tokenProxy_ = _createProxy(moduleId_, moduleType_, address(0));

        Token storage token = _tokens[tokenProxy_];

        token.name = name_;
        token.symbol = symbol_;
        token.decimals = decimals_;

        return tokenProxy_;
    }
}
