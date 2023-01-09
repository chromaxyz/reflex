// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseDispatcher} from "../../src/BaseDispatcher.sol";

// Implementations
import {ImplementationState} from "./ImplementationState.sol";

/**
 * @title Implementation Dispatcher
 */
contract ImplementationDispatcher is BaseDispatcher, ImplementationState {
    // ===========
    // Constructor
    // ===========

    constructor(
        address owner_,
        address installerModule_
    ) BaseDispatcher(owner_, installerModule_) {}

    // ==========
    // Test stubs
    // ==========

    function addToken(
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
