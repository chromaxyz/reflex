// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Internals
import {Base} from "../../src/internals/Base.sol";
import {BaseState} from "../../src/BaseState.sol";

abstract contract MockBaseState is BaseState {
    // =======
    // Storage
    // =======

    uint256 public reentrancyCounter = 0;
}

/**
 * @title Mock Base
 */
contract MockBase is Base, MockBaseState {
    // ===========
    // Constructor
    // ===========

    constructor() {
        unlockReentrancyLock();
    }

    // ==========
    // Test stubs
    // ==========

    function getReentrancyStatus() public view returns (uint256) {
        return _reentrancyLock;
    }

    function lockReentrancyLock() external {
        _reentrancyLock = _REENTRANCY_LOCK_LOCKED;
    }

    function unlockReentrancyLock() public {
        _reentrancyLock = _REENTRANCY_LOCK_UNLOCKED;
    }

    function callback() external nonReentrant {
        _increaseCounter();
    }

    function countDirectRecursive(uint256 n) public nonReentrant {
        if (n > 0) {
            _increaseCounter();
            countDirectRecursive(n - 1);
        }
    }

    function countIndirectRecursive(uint256 n) public nonReentrant {
        if (n > 0) {
            _increaseCounter();

            (bool success, bytes memory data) = address(this).call(
                abi.encodeWithSignature(
                    "countIndirectRecursive(uint256)",
                    n - 1
                )
            );

            if (!success) _revertBytes(data);
        }
    }

    function countAndCall(ReentrancyAttack attacker) public nonReentrant {
        _increaseCounter();
        bytes4 func = bytes4(keccak256("callback()"));
        attacker.callSender(func);
    }

    function guardedCheckLocked() public nonReentrant {
        require(getReentrancyStatus() == _REENTRANCY_LOCK_LOCKED);
    }

    function unguardedCheckUnlocked() public view {
        require(getReentrancyStatus() == _REENTRANCY_LOCK_UNLOCKED);
    }

    function createProxy(
        uint32 moduleId_,
        uint16 moduleType_
    ) public returns (address) {
        return _createProxy(moduleId_, moduleType_);
    }

    function callInternalModule(
        uint32 moduleId_,
        bytes memory input_
    ) public returns (bytes memory) {
        return _callInternalModule(moduleId_, input_);
    }

    function unpackMessageSender() public pure returns (address) {
        return _unpackMessageSender();
    }

    function unpackProxyAddress() public pure returns (address) {
        return _unpackProxyAddress();
    }

    function revertBytes(bytes memory errorMessage_) public pure {
        return _revertBytes(errorMessage_);
    }

    // =========
    // Utilities
    // =========

    function _increaseCounter() internal {
        reentrancyCounter += 1;
    }
}

// =========
// Utilities
// =========

contract ReentrancyAttack {
    // ======
    // Errors
    // ======

    error ReentrancyAttackFailed();

    // ==========
    // Test stubs
    // ==========

    function callSender(bytes4 data) external {
        (bool success, ) = msg.sender.call(abi.encodeWithSelector(data));

        if (!success) revert ReentrancyAttackFailed();
    }
}
