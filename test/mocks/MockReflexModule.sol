// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexModule} from "../../src/ReflexModule.sol";

// Fixtures
import {MockHarness} from "../fixtures/MockHarness.sol";

/**
 * @title Mock Reflex Module
 */
contract MockReflexModule is MockHarness, ReflexModule {
    // =========
    // Constants
    // =========

    /**
     * @dev `bytes32(uint256(keccak256("_REENTRANCY_COUNTER_SLOT")) - 1)`
     */
    bytes32 internal constant _REENTRANCY_COUNTER_SLOT =
        0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d;

    // =====
    // Error
    // =====

    error EndpointAddressInvalid();

    error MessageSenderInvalid();

    error FailedToLog();

    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) ReflexModule(moduleSettings_) {
        _REFLEX_STORAGE().reentrancyStatus = _REENTRANCY_GUARD_UNLOCKED;
    }

    // ==========
    // Test stubs
    // ==========

    function revertBytesCustomError(uint256 code, string calldata message) external {
        CustomErrorThrower thrower = new CustomErrorThrower();

        (, bytes memory data) = address(thrower).call(
            abi.encodeWithSelector(CustomErrorThrower.throwCustomError.selector, code, message)
        );

        _revertBytes(data);
    }

    function revertPanicAssert() external {
        PanicThrower thrower = new PanicThrower();

        (, bytes memory data) = address(thrower).call(abi.encodeWithSignature("throwPanicAssert()"));

        _revertBytes(data);
    }

    function revertPanicDivisionByZero() external {
        PanicThrower thrower = new PanicThrower();

        (, bytes memory data) = address(thrower).call(abi.encodeWithSignature("throwPanicDivisionByZero()"));

        _revertBytes(data);
    }

    function revertPanicArithmeticOverflow() external {
        PanicThrower thrower = new PanicThrower();

        (, bytes memory data) = address(thrower).call(abi.encodeWithSignature("throwPanicArithmeticOverflow()"));

        _revertBytes(data);
    }

    function revertPanicArithmeticUnderflow() external {
        PanicThrower thrower = new PanicThrower();

        (, bytes memory data) = address(thrower).call(abi.encodeWithSignature("throwPanicArithmeticUnderflow()"));

        _revertBytes(data);
    }

    function endpointLog0Topic(bytes memory message_) external {
        _issueLogToEndpoint(abi.encodePacked(uint8(0), message_));
    }

    function endpointLog1Topic(bytes calldata message_) external {
        _issueLogToEndpoint(abi.encodePacked(uint8(1), bytes32(uint256(1)), message_));
    }

    function endpointLog2Topic(bytes memory message_) external {
        _issueLogToEndpoint(abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_));
    }

    function endpointLog3Topic(bytes memory message_) external {
        _issueLogToEndpoint(
            abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)
        );
    }

    function endpointLog4Topic(bytes memory message_) external {
        _issueLogToEndpoint(
            abi.encodePacked(
                uint8(4),
                bytes32(uint256(1)),
                bytes32(uint256(2)),
                bytes32(uint256(3)),
                bytes32(uint256(4)),
                message_
            )
        );
    }

    function revertEndpointLogOutOfBounds(bytes memory message_) external {
        _issueLogToEndpoint(
            abi.encodePacked(
                uint8(5),
                bytes32(uint256(1)),
                bytes32(uint256(2)),
                bytes32(uint256(3)),
                bytes32(uint256(4)),
                bytes32(uint256(5)),
                message_
            )
        );
    }

    function unpackMessageSender() external pure returns (address) {
        return _unpackMessageSender();
    }

    function unpackEndpointAddress() external pure returns (address) {
        return _unpackEndpointAddress();
    }

    function unpackTrailingParameters() external pure returns (address, address) {
        return _unpackTrailingParameters();
    }

    // ==========
    // Test stubs
    // ==========

    function reentrancyCounter() public view returns (uint256 n_) {
        n_ = _getCounter(_REENTRANCY_COUNTER_SLOT);
    }

    function getReentrancyStatus() public view returns (uint256) {
        return _REFLEX_STORAGE().reentrancyStatus;
    }

    function isReentrancyStatusLocked() public view returns (bool) {
        return _reentrancyStatusLocked();
    }

    function callback() external nonReentrant {
        _increaseCounter(_REENTRANCY_COUNTER_SLOT);
    }

    function countDirectRecursive(uint256 n_) public nonReentrant {
        if (n_ > 0) {
            _increaseCounter(_REENTRANCY_COUNTER_SLOT);
            countDirectRecursive(n_ - 1);
        }
    }

    function countIndirectRecursive(uint256 n_) public nonReentrant {
        if (n_ > 0) {
            _increaseCounter(_REENTRANCY_COUNTER_SLOT);

            (bool success, bytes memory data) = address(this).call(
                abi.encodeWithSignature("countIndirectRecursive(uint256)", n_ - 1)
            );

            if (!success) _revertBytes(data);
        }
    }

    function countAndCall(ReentrancyAttack attacker_) public nonReentrant {
        _increaseCounter(_REENTRANCY_COUNTER_SLOT);

        attacker_.callSender(bytes4(keccak256("callback()")));
    }

    function guardedCheckLocked() public nonReentrant {
        assert(isReentrancyStatusLocked());
        assert(getReentrancyStatus() == _REENTRANCY_GUARD_LOCKED);
    }

    function readCallbackTargetUnprotected() public {}

    function readCallbackTargetProtected() public nonReadReentrant {}

    function readGuardedCheckProtected() public nonReentrant {
        assert(isReentrancyStatusLocked());
        assert(getReentrancyStatus() == _REENTRANCY_GUARD_LOCKED);

        readCallbackTargetProtected();
    }

    function readGuardedCheckUnprotected() public nonReentrant {
        assert(isReentrancyStatusLocked());
        assert(getReentrancyStatus() == _REENTRANCY_GUARD_LOCKED);

        readCallbackTargetUnprotected();
    }

    function unguardedCheckUnlocked() public view {
        assert(!isReentrancyStatusLocked());
        assert(getReentrancyStatus() == _REENTRANCY_GUARD_UNLOCKED);
    }

    function createEndpoint(
        uint32 moduleId_,
        uint16 moduleType_,
        address moduleImplementation_
    ) public returns (address) {
        return _createEndpoint(moduleId_, moduleType_, moduleImplementation_);
    }

    function callInternalModule(uint32 moduleId_, bytes memory input_) public returns (bytes memory) {
        return _callInternalModule(moduleId_, input_);
    }

    function revertBytes(bytes memory errorMessage_) public pure {
        return _revertBytes(errorMessage_);
    }

    // =========
    // Utilities
    // =========

    function _getCounter(bytes32 slot_) internal view returns (uint256 n_) {
        assembly ("memory-safe") {
            n_ := sload(slot_)
        }
    }

    function _setCounter(bytes32 slot_, uint256 n_) internal {
        assembly ("memory-safe") {
            sstore(slot_, n_)
        }
    }

    function _increaseCounter(bytes32 slot_) internal {
        uint256 value = _getCounter(slot_);
        _setCounter(slot_, value + 1);
    }

    function _issueLogToEndpoint(bytes memory payload) internal {
        address endpointAddress = _unpackEndpointAddress();

        (bool success, ) = endpointAddress.call(payload);

        if (!success) {
            revert FailedToLog();
        }
    }
}

// =========
// Utilities
// =========

interface ICustomError {
    struct CustomErrorPayload {
        uint256 code;
        string message;
    }

    error CustomError(CustomErrorPayload payload);
}

contract CustomErrorThrower is ICustomError {
    function throwCustomError(uint256 code, string calldata message) external pure {
        revert CustomError(CustomErrorPayload({code: code, message: message}));
    }
}

contract PanicThrower {
    function throwPanicAssert() external pure {
        assert(false);
    }

    function throwPanicDivisionByZero() external pure returns (uint256) {
        uint256 x = 0;

        return type(uint256).max / x;
    }

    function throwPanicArithmeticOverflow() external pure returns (uint256) {
        return type(uint256).max + 1;
    }

    function throwPanicArithmeticUnderflow() external pure returns (uint256) {
        return type(uint256).min - 1;
    }
}

// =========
// Utilities
// =========

/**
 * @title Reentrancy Attack
 */
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
