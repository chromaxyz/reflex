// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Mocks
import {MockImplementationModule} from "../MockImplementationModule.sol";

/**
 * @title Implementation ERC20
 */
abstract contract ImplementationERC20 is MockImplementationModule {
    // ======
    // Errors
    // ======

    error EndpointEventEmittanceFailed();

    // ======
    // Events
    // ======

    /**
     * @notice Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /**
     * @notice Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockImplementationModule(moduleSettings_) {}

    // ============
    // View methods
    // ============

    /**
     * @notice Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        (Token storage token, , ) = _unpackCalldata();

        return token.name;
    }

    /**
     * @notice Returns the symbol of the token.
     */
    function symbol() public view virtual returns (string memory) {
        (Token storage token, , ) = _unpackCalldata();

        return token.symbol;
    }

    /**
     * @notice Returns the decimals places of the token.
     */
    function decimals() public view virtual returns (uint8) {
        (Token storage token, , ) = _unpackCalldata();

        return token.decimals;
    }

    /**
     * @notice Returns the amount of tokens in existence.
     */
    function totalSupply() public view virtual returns (uint256) {
        (Token storage token, , ) = _unpackCalldata();

        return token.totalSupply;
    }

    /**
     * @notice Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address user_) public view virtual returns (uint256) {
        (Token storage token, , ) = _unpackCalldata();

        return token.balanceOf[user_];
    }

    /**
     * @notice Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner_, address spender_) public view virtual returns (uint256) {
        (Token storage token, , ) = _unpackCalldata();

        return token.allowance[owner_][spender_];
    }

    // ==============
    // Public methods
    // ==============

    /**
     * @notice Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender_, uint256 amount_) public virtual returns (bool) {
        (Token storage token, address endpointAddress, address messageSender) = _unpackCalldata();

        token.allowance[messageSender][spender_] = amount_;

        _emitApprovalEvent(endpointAddress, messageSender, spender_, amount_);

        return true;
    }

    /**
     * @notice Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to_, uint256 amount_) public virtual returns (bool) {
        (Token storage token, address endpointAddress, address messageSender) = _unpackCalldata();

        token.balanceOf[messageSender] -= amount_;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            token.balanceOf[to_] += amount_;
        }

        _emitTransferEvent(endpointAddress, messageSender, to_, amount_);

        return true;
    }

    /**
     * @notice Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from_, address to_, uint256 amount_) public virtual returns (bool) {
        (Token storage token, address endpointAddress, address messageSender) = _unpackCalldata();

        uint256 allowed = token.allowance[from_][messageSender];

        if (allowed != type(uint256).max) {
            token.allowance[from_][messageSender] = allowed - amount_;
        }

        token.balanceOf[from_] -= amount_;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            token.balanceOf[to_] += amount_;
        }

        _emitTransferEvent(endpointAddress, from_, to_, amount_);

        return true;
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev Creates `amount` tokens and assigns them to `account`, increasing the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     */
    function _mint(address to_, uint256 amount_) internal virtual {
        (Token storage token, address endpointAddress, ) = _unpackCalldata();

        token.totalSupply += amount_;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            token.balanceOf[to_] += amount_;
        }

        _emitTransferEvent(endpointAddress, address(0), to_, amount_);
    }

    /**
     * @notice Destroys `amount` tokens from `account`, reducing the total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address from_, uint256 amount_) internal virtual {
        (Token storage token, address endpointAddress, ) = _unpackCalldata();

        token.balanceOf[from_] -= amount_;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            token.totalSupply -= amount_;
        }

        _emitTransferEvent(endpointAddress, from_, address(0), amount_);
    }

    /**
     * @dev Emit `Transfer` event from the `Endpoint` rather than the `Dispatcher`.
     */
    function _emitTransferEvent(
        address endpointAddress_,
        address from_,
        address to_,
        uint256 amount_
    ) internal virtual {
        (bool success, ) = endpointAddress_.call(
            abi.encodePacked(
                uint8(3),
                keccak256(bytes("Transfer(address,address,uint256")),
                bytes32(uint256(uint160(from_))),
                bytes32(uint256(uint160(to_))),
                amount_
            )
        );

        if (!success) revert EndpointEventEmittanceFailed();
    }

    /**
     * @dev Emit `Approval` event from the `Endpoint` rather than the `Dispatcher`.
     */
    function _emitApprovalEvent(
        address endpointAddress_,
        address owner_,
        address spender_,
        uint256 amount_
    ) internal virtual {
        (bool success, ) = endpointAddress_.call(
            abi.encodePacked(
                uint8(3),
                keccak256(bytes("Approval(address,address,uint256)")),
                bytes32(uint256(uint160(owner_))),
                bytes32(uint256(uint160(spender_))),
                amount_
            )
        );

        if (!success) revert EndpointEventEmittanceFailed();
    }

    /**
     * @dev Unpack the caller calldata.
     */
    function _unpackCalldata()
        internal
        view
        virtual
        returns (Token storage token_, address endpointAddress_, address messageSender_)
    {
        (messageSender_, endpointAddress_) = _unpackTrailingParameters();
        token_ = _tokens[endpointAddress_];
    }
}
