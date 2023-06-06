// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexState} from "../../../src/ReflexState.sol";

/**
 * @title Mock Implementation State
 *
 * @dev Storage layout:
 * | Name                    | Type                                                  | Slot | Offset | Bytes |
 * |-------------------------|-------------------------------------------------------|------|--------|-------|
 * | _reentrancyStatus       | uint256                                               | 0    | 0      | 32    |
 * | _owner                  | address                                               | 1    | 0      | 20    |
 * | _pendingOwner           | address                                               | 2    | 0      | 20    |
 * | _modules                | mapping(uint32 => address)                            | 3    | 0      | 32    |
 * | _endpoints              | mapping(uint32 => address)                            | 4    | 0      | 32    |
 * | _relations              | mapping(address => struct IReflexState.TrustRelation) | 5    | 0      | 32    |
 * | __gap                   | uint256[44]                                           | 6    | 0      | 1408  |
 * | _implementationState0   | bytes32                                               | 50   | 0      | 32    |
 * | _implementationState1   | uint256                                               | 51   | 0      | 32    |
 * | _implementationState2   | address                                               | 52   | 0      | 20    |
 * | getImplementationState3 | address                                               | 53   | 0      | 20    |
 * | getImplementationState4 | bool                                                  | 53   | 20     | 1     |
 * | _implementationState5   | mapping(address => uint256)                           | 54   | 0      | 32    |
 * | _tokens                 | mapping(address => struct ImplementationState.Token)  | 55   | 0      | 32    |
 */
contract ImplementationState is ReflexState {
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

    // =======
    // Storage
    // =======

    /**
     * @notice Implementation state 0.
     *
     * @dev Slot 50 (32 bytes).
     */
    bytes32 internal _implementationState0;

    /**
     * @notice Implementation state 1.
     *
     * @dev Slot 51 (32 bytes).
     */
    uint256 internal _implementationState1;

    /**
     * @notice Implementation state 2.
     *
     * @dev Slot 52 (20 bytes).
     */
    address internal _implementationState2;

    /**
     * @notice Implementation state 3.
     *
     * @dev Slot 53 (20 bytes).
     */
    address internal _implementationState3;

    /**
     * @notice Implementation state 4.
     *
     * @dev Slot 53 (20 byte offset, 1 byte).
     */
    bool internal _implementationState4;

    /**
     * @notice Implementation state 5.
     *
     * @dev Slot 54 (32 bytes).
     */
    mapping(address => uint256) internal _implementationState5;

    // =============
    // Token Storage
    // =============

    /**
     * @notice Token mapping.
     *
     * @dev Slot 55 (32 bytes)
     */
    mapping(address => Token) internal _tokens;
}
