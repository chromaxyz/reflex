// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseModule} from "../../src/BaseModule.sol";

/**
 * @title Mock Base Module
 */
contract MockBaseModule is BaseModule {
    // ======
    // Errors
    // ======

    error FailedToLog();

    // ===========
    // Constructor
    // ===========

    constructor(
        uint32 _moduleId,
        uint16 _moduleType,
        uint16 _moduleVersion
    ) BaseModule(_moduleId, _moduleType, _moduleVersion) {}

    // =====
    // Tests
    // =====

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

    function testProxyLog0Topic(bytes memory message_) external {
        _issueLogToProxy(abi.encodePacked(uint8(0), message_));
    }

    function testProxyLog1Topic(bytes memory message_) external {
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
        (, address proxyAddress) = _unpackParameters();

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
