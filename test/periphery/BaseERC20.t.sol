// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseModule} from "../../src/BaseModule.sol";
import {BaseState} from "../../src/BaseState.sol";

// Multi-proxy means a single underlying implementation but multiple proxies

/**
 * @title Base ERC20 State
 */
abstract contract BaseERC20State is BaseState {
    // =======
    // Storage
    // =======

    struct ERC20Storage {
        address asset;
    }

    mapping(address => ERC20Storage) internal tokenLookup;
}

/**
 * @title Base ERC20 Module
 */
contract BaseERC20Module is BaseModule, BaseERC20State {
    // ======
    // Events
    // ======

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    // ===========
    // Constructor
    // ===========

    constructor(
        uint32 moduleId_,
        uint16 moduleType_,
        uint16 moduleVersion_
    ) BaseModule(moduleId_, moduleType_, moduleVersion_) {}

    // ==============
    // View functions
    // ==============

    function name() external view returns (string memory) {
        (address asset, , ) = _caller();

        return string(IERC20(asset).name());
    }

    // ================
    // Public functions
    // ================

    // ==================
    // Internal functions
    // ==================

    function _mint(address to_, uint256 amount_) internal virtual {}

    function _burn(address to_, uint256 amount_) internal virtual {}

    // =================
    // Private functions
    // =================

    function _caller()
        private
        view
        returns (address asset_, address proxyAddress_, address messageSender_)
    {
        asset_ = tokenLookup[proxyAddress_];
        messageSender_ = _unpackMessageSender();
        proxyAddress_ = _unpackProxyAddress();
    }
}
