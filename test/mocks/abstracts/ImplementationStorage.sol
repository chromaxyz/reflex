// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexStorage} from "../../../src/ReflexStorage.sol";

/**
 * @title Implementation Storage
 */
abstract contract ImplementationStorage is ReflexStorage {
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
    struct ImplementationStorageLayout {
        /**
         * @notice Implementation storage 0.
         */
        bytes32 implementationStorage0;
        /**
         * @notice Implementation storage 1.
         */
        uint256 implementationStorage1;
        /**
         * @notice Implementation storage 2.
         */
        address implementationStorage2;
        /**
         * @notice Implementation storage 3.
         */
        address implementationStorage3;
        /**
         * @notice Implementation storage 4.
         */
        bool implementationStorage4;
        /**
         * @notice Implementation storage 5.
         */
        mapping(address => uint256) implementationStorage5;
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
     * @return storage_ Pointer to the Implementation storage slot.
     */
    // solhint-disable-next-line func-name-mixedcase
    function _IMPLEMENTATION_STORAGE() internal pure returns (ImplementationStorageLayout storage storage_) {
        assembly ("memory-safe") {
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

    function getReflexStorage0() public view returns (uint256) {
        return _REFLEX_STORAGE().reentrancyStatus;
    }

    function getReflexStorage1() public view returns (address) {
        return _REFLEX_STORAGE().owner;
    }

    function getReflexStorage2() public view returns (address) {
        return _REFLEX_STORAGE().pendingOwner;
    }

    function getReflexStorage3(uint32 moduleId_) public view returns (address) {
        return _REFLEX_STORAGE().modules[moduleId_];
    }

    function getReflexStorage4(uint32 moduleId_) public view returns (address) {
        return _REFLEX_STORAGE().endpoints[moduleId_];
    }

    function getReflexStorage5(address endpoint_) public view returns (TrustRelation memory) {
        return _REFLEX_STORAGE().relations[endpoint_];
    }

    // =========================
    // Implementation test stubs
    // =========================

    // solhint-disable-next-line func-name-mixedcase
    function IMPLEMENTATION_STORAGE_SLOT() public pure returns (bytes32) {
        return _IMPLEMENTATION_STORAGE_SLOT;
    }

    function getImplementationStorage0() public view returns (bytes32) {
        return _IMPLEMENTATION_STORAGE().implementationStorage0;
    }

    function getImplementationStorage1() public view returns (uint256) {
        return _IMPLEMENTATION_STORAGE().implementationStorage1;
    }

    function getImplementationStorage2() public view returns (address) {
        return _IMPLEMENTATION_STORAGE().implementationStorage2;
    }

    function getImplementationStorage3() public view returns (address) {
        return _IMPLEMENTATION_STORAGE().implementationStorage3;
    }

    function getImplementationStorage4() public view returns (bool) {
        return _IMPLEMENTATION_STORAGE().implementationStorage4;
    }

    function getImplementationStorage5(address target_) public view returns (uint256) {
        return _IMPLEMENTATION_STORAGE().implementationStorage5[target_];
    }

    function setImplementationStorage0(bytes32 message_) public {
        _IMPLEMENTATION_STORAGE().implementationStorage0 = message_;
    }

    function setImplementationStorage1(uint256 number_) public {
        _IMPLEMENTATION_STORAGE().implementationStorage1 = number_;
    }

    function setImplementationStorage2(address target_) public {
        _IMPLEMENTATION_STORAGE().implementationStorage2 = target_;
    }

    function setImplementationStorage3(address target_) public {
        _IMPLEMENTATION_STORAGE().implementationStorage3 = target_;
    }

    function setImplementationStorage4(bool flag_) public {
        _IMPLEMENTATION_STORAGE().implementationStorage4 = flag_;
    }

    function setImplementationStorage5(address target_, uint256 number_) public {
        _IMPLEMENTATION_STORAGE().implementationStorage5[target_] = number_;
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

    function setImplementationStorage(
        bytes32 message_,
        uint256 number_,
        address target_,
        bool flag_,
        address tokenA_,
        address tokenB_
    ) public {
        _IMPLEMENTATION_STORAGE().implementationStorage0 = message_;
        _IMPLEMENTATION_STORAGE().implementationStorage1 = number_;
        _IMPLEMENTATION_STORAGE().implementationStorage2 = target_;
        _IMPLEMENTATION_STORAGE().implementationStorage3 = target_;
        _IMPLEMENTATION_STORAGE().implementationStorage4 = flag_;
        _IMPLEMENTATION_STORAGE().implementationStorage5[target_] = number_;

        _IMPLEMENTATION_STORAGE().tokens[tokenA_].name = "Token A";
        _IMPLEMENTATION_STORAGE().tokens[tokenA_].symbol = "TKNA";
        _IMPLEMENTATION_STORAGE().tokens[tokenA_].decimals = 18;

        _IMPLEMENTATION_STORAGE().tokens[tokenB_].name = "Token B";
        _IMPLEMENTATION_STORAGE().tokens[tokenB_].symbol = "TKNB";
        _IMPLEMENTATION_STORAGE().tokens[tokenB_].decimals = 18;
    }
}
