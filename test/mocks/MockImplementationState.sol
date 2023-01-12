// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

// Implementations
import {ImplementationState} from "../implementations/ImplementationState.sol";

/**
 * @title Mock Implementation State
 */
contract MockImplementationState is ImplementationState {
    // ==========
    // Test stubs
    // ==========

    function getImplementationState0() public view returns (bytes32) {
        return _implementationState0;
    }

    function getImplementationState1() public view returns (uint256) {
        return _implementationState1;
    }

    function getImplementationState2() public view returns (address) {
        return _implementationState2;
    }

    function getImplementationState5(
        address location_
    ) public view returns (uint256) {
        return _implementationState5[location_];
    }

    function setImplementationState0(bytes32 message_) external {
        _implementationState0 = message_;
    }

    function setImplementationState1(uint256 number_) external {
        _implementationState1 = number_;
    }

    function setImplementationState2(address location_) external {
        _implementationState2 = location_;
    }

    function setImplementationState3(address location_) external {
        getImplementationState3 = location_;
    }

    function setImplementationState4(bool value_) external {
        getImplementationState4 = value_;
    }

    function setImplementationState5(
        address location_,
        uint256 number_
    ) external {
        _implementationState5[location_] = number_;
    }

    function getToken(
        address token_
    )
        public
        view
        returns (string memory name_, string memory symbol_, uint8 decimals_)
    {
        name_ = _tokens[token_].name;
        symbol_ = _tokens[token_].symbol;
        decimals_ = _tokens[token_].decimals;
    }

    function setToken(
        address token_,
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) external {
        _tokens[token_].name = name_;
        _tokens[token_].symbol = symbol_;
        _tokens[token_].decimals = decimals_;
    }
}
