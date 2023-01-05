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
 * | _exampleSlot1 | bytes32                                             | 50   | 0      | 32    |
 * | _exampleSlot2 | uint256                                             | 51   | 0      | 32    |
 * | _exampleSlot3 | address                                             | 52   | 0      | 20    |
 * | getSlot4      | address                                             | 53   | 0      | 20    |
 * | getSlot5      | bool                                                | 53   | 20     | 1     |
 * | _exampleSlot6 | mapping(address => uint256)                         | 54   | 0      | 32    |
 */
contract ImplementationState is BaseState {
    // =======
    // Storage
    // =======

    /**
     * @notice Internal slot 1.
     * @dev Slot 51 (32 bytes).
     */
    bytes32 internal _exampleSlot1;

    /**
     * @notice Internal slot 2.
     * @dev Slot 52 (32 bytes).
     */
    uint256 internal _exampleSlot2;

    /**
     * @notice Internal slot 3.
     * @dev Slot 53 (20 bytes).
     */
    address internal _exampleSlot3;

    /**
     * @notice Public slot 4.
     * @dev Slot 54 (20 bytes).
     */
    address public getSlot4 = address(0xAAAA);

    /**
     * @notice Public slot 5.
     * @dev Slot 54 (20 byte offset, 1 byte).
     */
    bool public getSlot5 = true;

    // /**
    //  * @notice Internal slot 6.
    //  * @dev Slot 54 (32 bytes).
    //  */
    mapping(address => uint256) internal _exampleSlot6;

    // ==========
    // Test stubs
    // ==========

    function getSlot1() public view returns (bytes32) {
        return _exampleSlot1;
    }

    function getSlot2() public view returns (uint256) {
        return _exampleSlot2;
    }

    function getSlot3() public view returns (address) {
        return _exampleSlot3;
    }

    function getSlot6(address location_) public view returns (uint256) {
        return _exampleSlot6[location_];
    }

    function setSlot1(bytes32 message_) public {
        _exampleSlot1 = message_;
    }

    function setSlot2(uint256 number_) public {
        _exampleSlot2 = number_;
    }

    function setSlot3(address location_) public {
        _exampleSlot3 = location_;
    }

    function setSlot4(address location_) public {
        getSlot4 = location_;
    }

    function setSlot5(bool value_) public {
        getSlot5 = value_;
    }

    function setSlot6(address location_, uint256 number_) public {
        _exampleSlot6[location_] = number_;
    }
}
