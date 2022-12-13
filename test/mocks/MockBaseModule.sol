// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseModule} from "../../src/BaseModule.sol";

// TODO: in progress

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

    function testProxyLogs() external {
        bytes memory extraData = "hello";

        _issueLogToProxy(abi.encodePacked(uint8(0), extraData));

        _issueLogToProxy(
            abi.encodePacked(uint8(1), bytes32(uint256(1)), extraData)
        );

        _issueLogToProxy(
            abi.encodePacked(
                uint8(2),
                bytes32(uint256(1)),
                bytes32(uint256(2)),
                extraData
            )
        );

        _issueLogToProxy(
            abi.encodePacked(
                uint8(3),
                bytes32(uint256(1)),
                bytes32(uint256(2)),
                bytes32(uint256(3)),
                extraData
            )
        );

        _issueLogToProxy(
            abi.encodePacked(
                uint8(4),
                bytes32(uint256(1)),
                bytes32(uint256(2)),
                bytes32(uint256(3)),
                bytes32(uint256(4)),
                extraData
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
