// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @title Invariant Fixture
 */
abstract contract InvariantFixture {
    // ======
    // Errors
    // ======

    error NoTargetContracts();
    error NoTargetSenders();

    // =======
    // Storage
    // =======

    address[] private _targetContracts;
    address[] private _targetSenders;

    // ==============
    // View functions
    // ==============

    function targetContracts()
        public
        view
        returns (address[] memory targetContracts_)
    {
        if (_targetContracts.length == uint256(0)) revert NoTargetContracts();

        return _targetContracts;
    }

    function targetSenders()
        public
        view
        returns (address[] memory targetSenders_)
    {
        if (_targetSenders.length == uint256(0)) revert NoTargetSenders();

        return _targetSenders;
    }

    // ==================
    // Internal functions
    // ==================

    function _addTargetContract(address newTargetContract_) internal {
        _targetContracts.push(newTargetContract_);
    }

    function _addTargetSenders(address newTargetSender_) internal {
        _targetSenders.push(newTargetSender_);
    }
}
