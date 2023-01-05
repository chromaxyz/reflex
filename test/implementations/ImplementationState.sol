// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseState} from "../../src/BaseState.sol";

/**
 * @title Implementation State
 *
 * @dev Storage layout:
 * | Name          | Type                                                | Slot | Offset | Bytes |
 * |---------------|-----------------------------------------------------|------|--------|-------|
 * | _owner        | address                                             | 0    | 0      | 20    |
 * | _pendingOwner | address                                             | 1    | 0      | 20    |
 * | _modules      | mapping(uint32 => address)                          | 2    | 0      | 32    |
 * | _proxies      | mapping(uint32 => address)                          | 3    | 0      | 32    |
 * | _trusts       | mapping(address => struct TBaseState.TrustRelation) | 4    | 0      | 32    |
 * | __gap         | uint256[45]                                         | 5    | 0      | 1440  |
 * | _exampleSlot0 | bytes32                                             | 50   | 0      | 32    |
 * | _exampleSlot1 | uint256                                             | 51   | 0      | 32    |
 * | _exampleSlot2 | address                                             | 52   | 0      | 20    |
 * | getSlot3      | address                                             | 53   | 0      | 20    |
 * | getSlot4      | bool                                                | 53   | 20     | 1     |
 * | _exampleSlot5 | mapping(address => uint256)                         | 54   | 0      | 32    |
 */
contract ImplementationState is BaseState {
    // =======
    // Storage
    // =======

    /**
     * @notice Implementation internal slot 0.
     * @dev Slot 51 (32 bytes).
     */
    bytes32 internal _exampleSlot0;

    /**
     * @notice Implementation internal slot 1.
     * @dev Slot 52 (32 bytes).
     */
    uint256 internal _exampleSlot1;

    /**
     * @notice Implementation internal slot 2.
     * @dev Slot 53 (20 bytes).
     */
    address internal _exampleSlot2;

    /**
     * @notice Implementation public slot 3.
     * @dev Slot 54 (20 bytes).
     */
    address public getSlot3 = address(0xAAAA);

    /**
     * @notice Implementation public slot 4.
     * @dev Slot 54 (20 byte offset, 1 byte).
     */
    bool public getSlot4 = true;

    // /**
    //  * @notice Implementation internal slot 5.
    //  * @dev Slot 54 (32 bytes).
    //  */
    mapping(address => uint256) internal _exampleSlot5;

    // ==========
    // Test stubs
    // ==========

    function getSlot0() public view returns (bytes32) {
        return _exampleSlot0;
    }

    function getSlot1() public view returns (uint256) {
        return _exampleSlot1;
    }

    function getSlot2() public view returns (address) {
        return _exampleSlot2;
    }

    function getSlot5(address location_) public view returns (uint256) {
        return _exampleSlot5[location_];
    }

    function setSlot0(bytes32 message_) public {
        _exampleSlot0 = message_;
    }

    function setSlot1(uint256 number_) public {
        _exampleSlot1 = number_;
    }

    function setSlot2(address location_) public {
        _exampleSlot2 = location_;
    }

    function setSlot3(address location_) public {
        getSlot3 = location_;
    }

    function setSlot4(bool value_) public {
        getSlot4 = value_;
    }

    function setSlot5(address location_, uint256 number_) public {
        _exampleSlot5[location_] = number_;
    }
}
