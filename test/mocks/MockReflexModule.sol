// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {ReflexModule} from "../../src/ReflexModule.sol";

// Mocks
import {MockReflexBase} from "./MockReflexBase.sol";

/**
 * @title Mock Reflex Module
 */
contract MockReflexModule is ReflexModule, MockReflexBase {
    // =====
    // Error
    // =====

    error InvalidProxyAddress();

    error InvalidMessageSender();

    error FailedToLog();

    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) ReflexModule(moduleSettings_) {}

    // ==========
    // Test stubs
    // ==========

    function sentinel() external pure returns (bool) {
        if (_unpackProxyAddress() == address(0)) revert InvalidProxyAddress();
        if (_unpackMessageSender() == address(0)) revert InvalidMessageSender();

        return true;
    }

    function testUnitRevertBytesCustomError(uint256 code, string calldata message) external {
        CustomErrorThrower thrower = new CustomErrorThrower();

        (, bytes memory data) = address(thrower).call(
            abi.encodeWithSelector(CustomErrorThrower.throwCustomError.selector, code, message)
        );

        _revertBytes(data);
    }

    function testUnitRevertPanicAssert() external {
        PanicThrower thrower = new PanicThrower();

        (, bytes memory data) = address(thrower).call(abi.encodeWithSignature("throwPanicAssert()"));

        _revertBytes(data);
    }

    function testUnitRevertPanicDivisionByZero() external {
        PanicThrower thrower = new PanicThrower();

        (, bytes memory data) = address(thrower).call(abi.encodeWithSignature("throwPanicDivisionByZero()"));

        _revertBytes(data);
    }

    function testUnitRevertPanicArithmeticOverflow() external {
        PanicThrower thrower = new PanicThrower();

        (, bytes memory data) = address(thrower).call(abi.encodeWithSignature("throwPanicArithmeticOverflow()"));

        _revertBytes(data);
    }

    function testUnitRevertPanicArithmeticUnderflow() external {
        PanicThrower thrower = new PanicThrower();

        (, bytes memory data) = address(thrower).call(abi.encodeWithSignature("throwPanicArithmeticUnderflow()"));

        _revertBytes(data);
    }

    function testFuzzProxyLog0Topic(bytes memory message_) external {
        _issueLogToProxy(abi.encodePacked(uint8(0), message_));
    }

    function testFuzzProxyLog1Topic(bytes calldata message_) external {
        _issueLogToProxy(abi.encodePacked(uint8(1), bytes32(uint256(1)), message_));
    }

    function testFuzzProxyLog2Topic(bytes memory message_) external {
        _issueLogToProxy(abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_));
    }

    function testFuzzProxyLog3Topic(bytes memory message_) external {
        _issueLogToProxy(
            abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)
        );
    }

    function testFuzzProxyLog4Topic(bytes memory message_) external {
        _issueLogToProxy(
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

    function testUnitRevertProxyLogOutOfBounds(bytes memory message_) external {
        _issueLogToProxy(
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

    function testUnitUnpackMessageSender() external pure returns (address) {
        return _unpackMessageSender();
    }

    function testUnitUnpackProxyAddress() external pure returns (address) {
        return _unpackProxyAddress();
    }

    function testUnitUnpackTrailingParameters() external pure returns (address, address) {
        return _unpackTrailingParameters();
    }

    // ================
    // Internal methods
    // ================

    function _issueLogToProxy(bytes memory payload) internal {
        address proxyAddress = _unpackProxyAddress();

        (bool success, ) = proxyAddress.call(payload);

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
