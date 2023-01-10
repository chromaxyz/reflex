// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseState} from "../../src/BaseState.sol";

/**
 * @title Implementation State Interface
 */
interface IImplementationState {
    // =======
    // Structs
    // =======

    struct Token {
        string name;
        string symbol;
        uint8 decimals;
        uint256 totalSupply;
        mapping(address => uint256) balanceOf;
        mapping(address => mapping(address => uint256)) allowance;
        mapping(address => uint256) nonces;
    }
}

/**
 * @title Implementation State
 *
 * @dev Storage layout:
 * | Name                    | Type                                                  | Slot | Offset | Bytes |
 * |-------------------------|-------------------------------------------------------|------|--------|-------|
 * | _reentrancyLock         | uint256                                               | 0    | 0      | 32    |
 * | _owner                  | address                                               | 1    | 0      | 20    |
 * | _pendingOwner           | address                                               | 2    | 0      | 20    |
 * | _modules                | mapping(uint32 => address)                            | 3    | 0      | 32    |
 * | _proxies                | mapping(uint32 => address)                            | 4    | 0      | 32    |
 * | _trusts                 | mapping(address => struct TBaseState.TrustRelation)   | 5    | 0      | 32    |
 * | __gap                   | uint256[44]                                           | 6    | 0      | 1408  |
 * | _implementationState0   | bytes32                                               | 50   | 0      | 32    |
 * | _implementationState1   | uint256                                               | 51   | 0      | 32    |
 * | _implementationState2   | address                                               | 52   | 0      | 20    |
 * | getImplementationState3 | address                                               | 53   | 0      | 20    |
 * | getImplementationState4 | bool                                                  | 53   | 20     | 1     |
 * | _implementationState5   | mapping(address => uint256)                           | 54   | 0      | 32    |
 * | _tokens                 | mapping(address => struct IImplementationState.Token) | 55   | 0      | 32    |
 */
contract ImplementationState is IImplementationState, BaseState {
    // =======
    // Storage
    // =======

    /**
     * @notice Implementation state 0.
     * @dev Slot 50 (32 bytes).
     */
    bytes32 internal _implementationState0;

    /**
     * @notice Implementation state 1.
     * @dev Slot 51 (32 bytes).
     */
    uint256 internal _implementationState1;

    /**
     * @notice Implementation state 2.
     * @dev Slot 52 (20 bytes).
     */
    address internal _implementationState2;

    /**
     * @notice Implementation state 3.
     * @dev Slot 53 (20 bytes).
     */
    address public getImplementationState3 = address(0xAAAA);

    /**
     * @notice Implementation state 4.
     * @dev Slot 53 (20 byte offset, 1 byte).
     */
    bool public getImplementationState4 = true;

    /**
     * @notice Implementation state 5.
     * @dev Slot 54 (32 bytes).
     */
    mapping(address => uint256) internal _implementationState5;

    // =============
    // Token Storage
    // =============

    /**
     * @notice Token mapping.
     * @dev Slot 55 (32 bytes)
     */
    mapping(address => Token) internal _tokens;

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

    function setImplementationState0(bytes32 message_) public {
        _implementationState0 = message_;
    }

    function setImplementationState1(uint256 number_) public {
        _implementationState1 = number_;
    }

    function setImplementationState2(address location_) public {
        _implementationState2 = location_;
    }

    function setImplementationState3(address location_) public {
        getImplementationState3 = location_;
    }

    function setImplementationState4(bool value_) public {
        getImplementationState4 = value_;
    }

    function setImplementationState5(
        address location_,
        uint256 number_
    ) public {
        _implementationState5[location_] = number_;
    }

    // ================
    // Token test stubs
    // ================

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
    ) public {
        _tokens[token_].name = name_;
        _tokens[token_].symbol = symbol_;
        _tokens[token_].decimals = decimals_;
    }
}
