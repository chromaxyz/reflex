// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexBase} from "../../src/ReflexBase.sol";
import {ReflexModule} from "../../src/ReflexModule.sol";

// Fixtures
import {MockHarness} from "../fixtures/MockHarness.sol";

// Mocks
import {MockReflexBase} from "./MockReflexBase.sol";

/**
 * @title Mock Reflex Module
 */
contract MockReflexModule is MockHarness, ReflexModule, MockReflexBase {
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
    constructor(ModuleSettings memory moduleSettings_) ReflexModule(moduleSettings_) {}

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

    // =========
    // Utilities
    // =========

    function _issueLogToEndpoint(bytes memory payload) internal {
        address endpointAddress = _unpackEndpointAddress();

        (bool success, ) = endpointAddress.call(payload);

        if (!success) {
            revert FailedToLog();
        }
    }

    // =========
    // Overrides
    // =========

    function _getEndpointCreationCode(
        uint32 moduleId_
    ) internal virtual override(MockReflexBase, ReflexBase) returns (bytes memory) {
        return super._getEndpointCreationCode(moduleId_);
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
