// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendors
import {Test} from "forge-std/Test.sol";

// Internals
import {Proxy} from "../src/internals/Proxy.sol";

/**
 * @title Proxy Test
 */
contract ProxyTest is Test {
    // =======
    // Storage
    // =======

    Proxy public proxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        proxy = new Proxy();
    }

    // =====
    // Tests
    // =====

    // function issueLogToProxy(bytes memory payload) private {
    //     (, address proxyAddr) = unpackTrailingParams();
    //     (bool success, ) = proxyAddr.call(payload);
    //     require(success, "e/log-proxy-fail");
    // }

    // function testProxyLogs() external {
    //     bytes memory extraData = "hello";

    //     issueLogToProxy(abi.encodePacked(uint8(0), extraData));

    //     issueLogToProxy(
    //         abi.encodePacked(uint8(1), bytes32(uint256(1)), extraData)
    //     );

    //     issueLogToProxy(
    //         abi.encodePacked(
    //             uint8(2),
    //             bytes32(uint256(1)),
    //             bytes32(uint256(2)),
    //             extraData
    //         )
    //     );

    //     issueLogToProxy(
    //         abi.encodePacked(
    //             uint8(3),
    //             bytes32(uint256(1)),
    //             bytes32(uint256(2)),
    //             bytes32(uint256(3)),
    //             extraData
    //         )
    //     );

    //     issueLogToProxy(
    //         abi.encodePacked(
    //             uint8(4),
    //             bytes32(uint256(1)),
    //             bytes32(uint256(2)),
    //             bytes32(uint256(3)),
    //             bytes32(uint256(4)),
    //             extraData
    //         )
    //     );
    // }
}
