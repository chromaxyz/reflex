// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Mocks
import {MockImplementationModule} from "./MockImplementationModule.sol";

/**
 * @title Mock Implementation ERC20 Hub
 */
contract MockImplementationERC20Hub is MockImplementationModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockImplementationModule(moduleSettings_) {}

    // ==========
    // Test stubs
    // ==========

    function addERC20(
        uint32 moduleId_,
        uint16 moduleType_,
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) external returns (address tokenEndpoint_) {
        tokenEndpoint_ = _createEndpoint(moduleId_, moduleType_, address(0));

        Token storage token = _tokens[tokenEndpoint_];

        token.name = name_;
        token.symbol = symbol_;
        token.decimals = decimals_;

        return tokenEndpoint_;
    }
}
