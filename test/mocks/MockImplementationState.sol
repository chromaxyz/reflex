// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
import {CommonBase} from "forge-std/Base.sol";
import {StdAssertions} from "forge-std/StdAssertions.sol";
import {stdStorageSafe, StdStorage} from "forge-std/StdStorage.sol";

// Mocks
import {ImplementationState} from "./abstracts/ImplementationState.sol";

/**
 * @title Mock Implementation State
 */
contract MockImplementationState is ImplementationState, StdAssertions, CommonBase {
    using stdStorageSafe for StdStorage;

    // ==========
    // Test stubs
    // ==========

    function setStorageSlot(bytes32 message_) public {
        setImplementationState0(message_);
    }

    function setStorageSlots(
        bytes32 message_,
        uint256 number_,
        address location_,
        address tokenA_,
        address tokenB_,
        bool flag_
    ) public {
        setImplementationState0(message_);
        setImplementationState1(number_);
        setImplementationState2(location_);
        setImplementationState3(location_);
        setImplementationState4(flag_);
        setImplementationState5(location_, number_);

        setToken(tokenA_, "Token A", "TKNA", 18);
        setToken(tokenB_, "Token B", "TKNB", 18);
    }

    function verifyStorageSlot(bytes32 message_) public {
        /**
         * | Name                    | Type                                                 | Slot | Offset | Bytes |
         * |-------------------------|------------------------------------------------------|------|--------|-------|
         * | _implementationState0   | bytes32                                              | 50   | 0      | 32    |
         */
        assertEq(stdstore.target(address(this)).sig("getImplementationState0()").find(), 50);
        assertEq(stdstore.target(address(this)).sig("getImplementationState0()").read_bytes32(), message_);
    }

    function verifyStorageSlots(
        bytes32 message_,
        uint256 number_,
        address location_,
        address tokenA_,
        address tokenB_,
        bool flag_
    ) public {
        /**
         * | Name                    | Type                                                 | Slot | Offset | Bytes |
         * |-------------------------|------------------------------------------------------|------|--------|-------|
         * | _implementationState0   | bytes32                                              | 50   | 0      | 32    |
         */
        assertEq(stdstore.target(address(this)).sig("getImplementationState0()").find(), 50);
        assertEq(stdstore.target(address(this)).sig("getImplementationState0()").read_bytes32(), message_);

        /**
         * | Name                    | Type                                                 | Slot | Offset | Bytes |
         * |-------------------------|------------------------------------------------------|------|--------|-------|
         * | _implementationState1   | uint256                                              | 51   | 0      | 32    |
         */
        assertEq(stdstore.target(address(this)).sig("getImplementationState1()").find(), 51);
        assertEq(stdstore.target(address(this)).sig("getImplementationState1()").read_uint(), number_);

        /**
         * | Name                    | Type                                                 | Slot | Offset | Bytes |
         * |-------------------------|------------------------------------------------------|------|--------|-------|
         * | _implementationState2   | address                                              | 52   | 0      | 20    |
         */
        assertEq(stdstore.target(address(this)).sig("getImplementationState2()").find(), 52);
        assertEq(stdstore.target(address(this)).sig("getImplementationState2()").read_address(), location_);

        // Due to StdStorage not supporting packed slots at this point in time we access
        // the underlying storage slots directly.

        bytes32[] memory reads;
        bytes32 current;

        /**
         * | Name                    | Type                                                 | Slot | Offset | Bytes |
         * |-------------------------|------------------------------------------------------|------|--------|-------|
         * | getImplementationState3 | address                                              | 53   | 0      | 20    |
         */
        vm.record();
        getImplementationState3();
        (reads, ) = vm.accesses(address(this));
        assertEq(uint256(reads[0]), 53);
        current = vm.load(address(this), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), location_);

        /**
         * | Name                    | Type                                                 | Slot | Offset | Bytes |
         * |-------------------------|------------------------------------------------------|------|--------|-------|
         * | getImplementationState4 | bool                                                 | 53   | 20     | 1     |
         */
        vm.record();
        getImplementationState4();
        (reads, ) = vm.accesses(address(this));
        assertEq(uint256(reads[0]), 53);
        current = vm.load(address(this), bytes32(reads[0]));
        assertEq(uint8(uint256(current) >> (20 * 8)), _castBoolToUInt8(flag_));

        /**
         * | Name                    | Type                                                 | Slot | Offset | Bytes |
         * |-------------------------|------------------------------------------------------|------|--------|-------|
         * | _implementationState5   | mapping(address => uint256)                          | 54   | 0      | 32    |
         */
        vm.record();
        getImplementationState5(location_);
        (reads, ) = vm.accesses(address(this));
        assertEq((reads[0]), keccak256(abi.encode(location_, uint256(54))));
        current = vm.load(address(this), bytes32(reads[0]));
        assertEq(uint256(current), number_);

        /**
         * | Name                    | Type                                                 | Slot | Offset | Bytes |
         * |-------------------------|------------------------------------------------------|------|--------|-------|
         * | _tokens                 | mapping(address => struct ImplementationState.Token) | 55   | 0      | 32    |
         */
        vm.record();
        getToken(tokenA_, address(this));
        (reads, ) = vm.accesses(address(this));
        assertEq((reads[0]), keccak256(abi.encode(tokenA_, uint256(55))));

        vm.record();
        getToken(tokenB_, address(this));
        (reads, ) = vm.accesses(address(this));
        assertEq((reads[0]), keccak256(abi.encode(tokenB_, uint256(55))));
    }

    function getImplementationState0() public view returns (bytes32) {
        return _implementationState0;
    }

    function getImplementationState1() public view returns (uint256) {
        return _implementationState1;
    }

    function getImplementationState2() public view returns (address) {
        return _implementationState2;
    }

    function getImplementationState3() public view returns (address) {
        return _implementationState3;
    }

    function getImplementationState4() public view returns (bool) {
        return _implementationState4;
    }

    function getImplementationState5(address location_) public view returns (uint256) {
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
        _implementationState3 = location_;
    }

    function setImplementationState4(bool value_) public {
        _implementationState4 = value_;
    }

    function setImplementationState5(address location_, uint256 number_) public {
        _implementationState5[location_] = number_;
    }

    function getToken(
        address token_,
        address user_
    )
        public
        view
        returns (string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_, uint256 balanceOf_)
    {
        name_ = _tokens[token_].name;
        symbol_ = _tokens[token_].symbol;
        decimals_ = _tokens[token_].decimals;
        totalSupply_ = _tokens[token_].totalSupply;
        balanceOf_ = _tokens[token_].balanceOf[user_];
    }

    function setToken(address token_, string memory name_, string memory symbol_, uint8 decimals_) public {
        _tokens[token_].name = name_;
        _tokens[token_].symbol = symbol_;
        _tokens[token_].decimals = decimals_;
    }

    // =========
    // Utilities
    // =========

    /**
     * @dev Cast bool to uint8.
     */
    function _castBoolToUInt8(bool x_) internal pure returns (uint8 r_) {
        assembly ("memory-safe") {
            r_ := x_
        }
    }
}
