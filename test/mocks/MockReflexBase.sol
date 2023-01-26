// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {ReflexBase} from "../../src/ReflexBase.sol";

/**
 * @title Mock Reflex Base
 */
contract MockReflexBase is ReflexBase {
    // =======
    // Storage
    // =======

    /**
     * @dev `bytes32(uint256(keccak256("reentrancy.counter")) - 1))`
     */
    bytes32 internal constant _REENTRANCY_COUNTER_SLOT =
        0xc2db8520a4cb85e45c0b428b71b461e7932f3b9c2b41fa1662675e79660783f2;

    // ===========
    // Constructor
    // ===========

    constructor() {
        _reentrancyLock = _REENTRANCY_LOCK_UNLOCKED;
    }

    // ==========
    // Test stubs
    // ==========

    function reentrancyCounter() public view returns (uint256 n_) {
        n_ = _getCounter();
    }

    function getReentrancyStatus() public view returns (uint256) {
        return _reentrancyLock;
    }

    function callback() external nonReentrant {
        _increaseCounter();
    }

    function countDirectRecursive(uint256 n_) public nonReentrant {
        if (n_ > 0) {
            _increaseCounter();
            countDirectRecursive(n_ - 1);
        }
    }

    function countIndirectRecursive(uint256 n_) public nonReentrant {
        if (n_ > 0) {
            _increaseCounter();

            (bool success, bytes memory data) = address(this).call(
                abi.encodeWithSignature("countIndirectRecursive(uint256)", n_ - 1)
            );

            if (!success) _revertBytes(data);
        }
    }

    function countAndCall(ReentrancyAttack attacker_) public nonReentrant {
        _increaseCounter();
        bytes4 func = bytes4(keccak256("callback()"));
        attacker_.callSender(func);
    }

    function guardedCheckLocked() public nonReentrant {
        require(getReentrancyStatus() == _REENTRANCY_LOCK_LOCKED);
    }

    function unguardedCheckUnlocked() public view {
        require(getReentrancyStatus() == _REENTRANCY_LOCK_UNLOCKED);
    }

    function createProxy(uint256 moduleId_, uint256 moduleType_) public returns (address) {
        return _createProxy(moduleId_, moduleType_);
    }

    function callInternalModule(uint256 moduleId_, bytes memory input_) public returns (bytes memory) {
        return _callInternalModule(moduleId_, input_);
    }

    function revertBytes(bytes memory errorMessage_) public pure {
        return _revertBytes(errorMessage_);
    }

    // ================
    // Internal methods
    // ================

    function _getCounter() internal view returns (uint256 n) {
        assembly {
            n := sload(_REENTRANCY_COUNTER_SLOT)
        }
    }

    function _setCounter(uint256 n) internal {
        assembly {
            sstore(_REENTRANCY_COUNTER_SLOT, n)
        }
    }

    function _increaseCounter() internal {
        uint256 value = _getCounter();
        _setCounter(value + 1);
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
