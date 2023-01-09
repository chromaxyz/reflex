// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseModule} from "../../src/BaseModule.sol";

// Implementations
import {ImplementationState} from "./ImplementationState.sol";
import {ImplementationToken} from "./ImplementationToken.sol";

/**
 * @title Implementation Tokens
 */
contract ImplementationTokens is BaseModule, ImplementationState {
    // =========
    // Constants
    // =========

    uint32 internal constant _TOKEN_A_MODULE_ID = 100;
    uint16 internal constant _TOKEN_A_MODULE_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _TOKEN_A_MODULE_VERSION = 1;

    uint32 internal constant _TOKEN_B_MODULE_ID = 101;
    uint16 internal constant _TOKEN_B_MODULE_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _TOKEN_B_MODULE_VERSION = 1;

    uint32 internal constant _TOKEN_C_MODULE_ID = 102;
    uint16 internal constant _TOKEN_C_MODULE_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _TOKEN_C_MODULE_VERSION = 1;

    // =======
    // Storage
    // =======

    ImplementationToken public tokenA;
    ImplementationToken public tokenB;
    ImplementationToken public tokenC;

    address public tokenAProxy;
    address public tokenBProxy;
    address public tokenCProxy;

    // ===========
    // Constructor
    // ===========

    constructor(
        uint32 moduleId_,
        uint16 moduleType_,
        uint16 moduleVersion_
    ) BaseModule(moduleId_, moduleType_, moduleVersion_) {}

    // ==========
    // Test stubs
    // ==========

    function setupTokens() external {
        tokenA = new ImplementationToken(
            _TOKEN_A_MODULE_ID,
            _TOKEN_A_MODULE_TYPE,
            _TOKEN_A_MODULE_VERSION
        );
        _configureToken(tokenA, "Token A", "TKNA", 18);

        tokenB = new ImplementationToken(
            _TOKEN_B_MODULE_ID,
            _TOKEN_B_MODULE_TYPE,
            _TOKEN_B_MODULE_VERSION
        );
        _configureToken(tokenB, "Token B", "TKNB", 18);

        tokenC = new ImplementationToken(
            _TOKEN_C_MODULE_ID,
            _TOKEN_C_MODULE_TYPE,
            _TOKEN_C_MODULE_VERSION
        );
        _configureToken(tokenC, "Token C", "TKNC", 18);

        tokenAProxy = _createProxy(_TOKEN_A_MODULE_ID, _TOKEN_A_MODULE_TYPE);
        tokenBProxy = _createProxy(_TOKEN_B_MODULE_ID, _TOKEN_B_MODULE_TYPE);
        tokenCProxy = _createProxy(_TOKEN_C_MODULE_ID, _TOKEN_C_MODULE_TYPE);
    }

    // ==================
    // Internal functions
    // ==================

    function _configureToken(
        ImplementationToken token_,
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) internal {
        _tokens[address(token_)].name = name_;
        _tokens[address(token_)].symbol = symbol_;
        _tokens[address(token_)].decimals = decimals_;
    }
}
