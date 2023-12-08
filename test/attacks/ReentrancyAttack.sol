// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

/**
 * @title Reentrancy Attack
 * @dev Test contract to simulate a reentrancy attack.
 */
contract ReentrancyAttack {
    // ======
    // Errors
    // ======

    error ReentrancyAttackFailed();

    // ==========
    // Test stubs
    // ==========

    function attackReenter(bytes4 data) external {
        (bool success, ) = msg.sender.call(abi.encodeWithSelector(data));

        if (!success) revert ReentrancyAttackFailed();
    }
}
