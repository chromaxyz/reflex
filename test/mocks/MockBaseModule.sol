// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseModule} from "../../src/BaseModule.sol";

// Mocks
import {MockBase} from "./MockBase.sol";

/**
 * @title Mock Base Module
 */
contract MockBaseModule is BaseModule, MockBase {
    // ===========
    // Constructor
    // ===========

    constructor(
        ModuleSettings memory moduleSettings_
    ) BaseModule(moduleSettings_) {}

    // ==========
    // Test stubs
    // ==========

    function sentinel() external pure returns (bool) {
        return true;
    }

    function testRevertBytesCustomError(
        uint256 code,
        string calldata message
    ) external {
        CustomErrorThrower thrower = new CustomErrorThrower();

        (, bytes memory data) = address(thrower).call(
            abi.encodeWithSelector(
                CustomErrorThrower.throwCustomError.selector,
                code,
                message
            )
        );

        _revertBytes(data);
    }

    function testRevertPanicAssert() external {
        PanicThrower thrower = new PanicThrower();

        (, bytes memory data) = address(thrower).call(
            abi.encodeWithSignature("throwPanicAssert()")
        );

        _revertBytes(data);
    }

    function testRevertPanicDivisionByZero() external {
        PanicThrower thrower = new PanicThrower();

        (, bytes memory data) = address(thrower).call(
            abi.encodeWithSignature("throwPanicDivisionByZero()")
        );

        _revertBytes(data);
    }

    function testRevertPanicArithmeticOverflow() external {
        PanicThrower thrower = new PanicThrower();

        (, bytes memory data) = address(thrower).call(
            abi.encodeWithSignature("throwPanicArithmeticOverflow()")
        );

        _revertBytes(data);
    }

    function testRevertPanicArithmeticUnderflow() external {
        PanicThrower thrower = new PanicThrower();

        (, bytes memory data) = address(thrower).call(
            abi.encodeWithSignature("throwPanicArithmeticUnderflow()")
        );

        _revertBytes(data);
    }

    function testProxyLog0Topic(bytes memory message_) external {
        _issueLogToProxy(abi.encodePacked(uint8(0), message_));
    }

    function testProxyLog1Topic(bytes calldata message_) external {
        _issueLogToProxy(
            abi.encodePacked(uint8(1), bytes32(uint256(1)), message_)
        );
    }

    function testProxyLog2Topic(bytes memory message_) external {
        _issueLogToProxy(
            abi.encodePacked(
                uint8(2),
                bytes32(uint256(1)),
                bytes32(uint256(2)),
                message_
            )
        );
    }

    function testProxyLog3Topic(bytes memory message_) external {
        _issueLogToProxy(
            abi.encodePacked(
                uint8(3),
                bytes32(uint256(1)),
                bytes32(uint256(2)),
                bytes32(uint256(3)),
                message_
            )
        );
    }

    function testProxyLog4Topic(bytes memory message_) external {
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

    function testRevertProxyLogOutOfBounds(bytes memory message_) external {
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

    function _issueLogToProxy(bytes memory payload) private {
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
    function throwCustomError(
        uint256 code,
        string calldata message
    ) external pure {
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
