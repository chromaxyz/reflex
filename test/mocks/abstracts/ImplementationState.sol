// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexState} from "../../../src/ReflexState.sol";

/**
 * @title Implementation State
 */
abstract contract ImplementationState is ReflexState {
    // =========
    // Constants
    // =========

    /**
     * @dev `bytes32(uint256(keccak256("_IMPLEMENTATION_STORAGE")) - 1)`
     * A `-1` offset is added so the preimage of the hash cannot be known,
     * reducing the chances of a possible attack.
     */
    bytes32 internal constant _IMPLEMENTATION_STORAGE_SLOT =
        0xf8509337ad8a230e85046288664a1364ac578e6500ef88157efd044485b8c20a;

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
     * @dev Append-only extendable.
     */
    struct ImplementationStorage {
        /**
         * @notice Implementation state 0.
         */
        bytes32 implementationState0;
        /**
         * @notice Implementation state 1.
         */
        uint256 implementationState1;
        /**
         * @notice Implementation state 2.
         */
        address implementationState2;
        /**
         * @notice Implementation state 3.
         */
        address implementationState3;
        /**
         * @notice Implementation state 4.
         */
        bool implementationState4;
        /**
         * @notice Implementation state 5.
         */
        mapping(address => uint256) implementationState5;
        /**
         * @notice Token mapping.
         */
        mapping(address => Token) tokens;
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev Get the Implementation storage pointer.
     * @return storage_ Pointer to the Implementation storage state.
     */
    // solhint-disable-next-line func-name-mixedcase
    function _IMPLEMENTATION_STORAGE() internal pure returns (ImplementationStorage storage storage_) {
        assembly {
            storage_.slot := _IMPLEMENTATION_STORAGE_SLOT
        }
    }

    // =================
    // Reflex test stubs
    // =================

    // solhint-disable-next-line func-name-mixedcase
    function REFLEX_STORAGE_SLOT() public pure returns (bytes32) {
        return _REFLEX_STORAGE_SLOT;
    }

    function getReflexState0() public view returns (uint256) {
        return _REFLEX_STORAGE().reentrancyStatus;
    }

    function getReflexState1() public view returns (address) {
        return _REFLEX_STORAGE().owner;
    }

    function getReflexState2() public view returns (address) {
        return _REFLEX_STORAGE().pendingOwner;
    }

    function getReflexState3(uint32 moduleId_) public view returns (address) {
        return _REFLEX_STORAGE().modules[moduleId_];
    }

    function getReflexState4(uint32 moduleId_) public view returns (address) {
        return _REFLEX_STORAGE().endpoints[moduleId_];
    }

    function getReflexState5(address endpoint_) public view returns (TrustRelation memory) {
        return _REFLEX_STORAGE().relations[endpoint_];
    }

    // =========================
    // Implementation test stubs
    // =========================

    // solhint-disable-next-line func-name-mixedcase
    function IMPLEMENTATION_STORAGE_SLOT() public pure returns (bytes32) {
        return _IMPLEMENTATION_STORAGE_SLOT;
    }

    function getImplementationState0() public view returns (bytes32) {
        return _IMPLEMENTATION_STORAGE().implementationState0;
    }

    function getImplementationState1() public view returns (uint256) {
        return _IMPLEMENTATION_STORAGE().implementationState1;
    }

    function getImplementationState2() public view returns (address) {
        return _IMPLEMENTATION_STORAGE().implementationState2;
    }

    function getImplementationState3() public view returns (address) {
        return _IMPLEMENTATION_STORAGE().implementationState3;
    }

    function getImplementationState4() public view returns (bool) {
        return _IMPLEMENTATION_STORAGE().implementationState4;
    }

    function getImplementationState5(address target_) public view returns (uint256) {
        return _IMPLEMENTATION_STORAGE().implementationState5[target_];
    }

    function setImplementationState0(bytes32 message_) public {
        _IMPLEMENTATION_STORAGE().implementationState0 = message_;
    }

    function setImplementationState1(uint256 number_) public {
        _IMPLEMENTATION_STORAGE().implementationState1 = number_;
    }

    function setImplementationState2(address target_) public {
        _IMPLEMENTATION_STORAGE().implementationState2 = target_;
    }

    function setImplementationState3(address target_) public {
        _IMPLEMENTATION_STORAGE().implementationState3 = target_;
    }

    function setImplementationState4(bool flag_) public {
        _IMPLEMENTATION_STORAGE().implementationState4 = flag_;
    }

    function setImplementationState5(address target_, uint256 number_) public {
        _IMPLEMENTATION_STORAGE().implementationState5[target_] = number_;
    }

    function getToken(
        address token_,
        address user_
    )
        public
        view
        returns (string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_, uint256 balanceOf_)
    {
        name_ = _IMPLEMENTATION_STORAGE().tokens[token_].name;
        symbol_ = _IMPLEMENTATION_STORAGE().tokens[token_].symbol;
        decimals_ = _IMPLEMENTATION_STORAGE().tokens[token_].decimals;
        totalSupply_ = _IMPLEMENTATION_STORAGE().tokens[token_].totalSupply;
        balanceOf_ = _IMPLEMENTATION_STORAGE().tokens[token_].balanceOf[user_];
    }

    function setImplementationState(
        bytes32 message_,
        uint256 number_,
        address target_,
        bool flag_,
        address tokenA_,
        address tokenB_
    ) public {
        _IMPLEMENTATION_STORAGE().implementationState0 = message_;

        _IMPLEMENTATION_STORAGE().implementationState1 = number_;

        _IMPLEMENTATION_STORAGE().implementationState2 = target_;

        _IMPLEMENTATION_STORAGE().implementationState3 = target_;

        _IMPLEMENTATION_STORAGE().implementationState4 = flag_;

        _IMPLEMENTATION_STORAGE().implementationState5[target_] = number_;

        _IMPLEMENTATION_STORAGE().tokens[tokenA_].name = "Token A";
        _IMPLEMENTATION_STORAGE().tokens[tokenA_].symbol = "TKNA";
        _IMPLEMENTATION_STORAGE().tokens[tokenA_].decimals = 18;

        _IMPLEMENTATION_STORAGE().tokens[tokenB_].name = "Token B";
        _IMPLEMENTATION_STORAGE().tokens[tokenB_].symbol = "TKNB";
        _IMPLEMENTATION_STORAGE().tokens[tokenB_].decimals = 18;
    }
}
