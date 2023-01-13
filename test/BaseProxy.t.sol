// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseProxy} from "../src/interfaces/IBaseProxy.sol";

// Internals
import {BaseProxy} from "../src/internals/BaseProxy.sol";

// Fixtures
import {Harness} from "./fixtures/Harness.sol";

/**
 * @title Base Proxy Test
 */
contract BaseProxyTest is TBaseProxy, Harness {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_VALID_ID = 100;

    // =======
    // Storage
    // =======

    BaseProxy public proxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        proxy = new BaseProxy(_MODULE_VALID_ID);
    }

    // =====
    // Tests
    // =====

    function testRevertInvalidModuleId() external {
        vm.expectRevert(InvalidModuleId.selector);
        new BaseProxy(0);
    }

    function testResolveInvalidImplementationToZeroAddress() external {
        assertEq(proxy.implementation(), address(0));
    }

    function testSentinelSideEffectsDelegateCall(bytes memory data_) public BrutalizeMemory {
        // This should never happen in any actual deployments.
        vm.startPrank(address(0));

        (bool success, bytes memory data) = address(proxy).call(
            // Prepend random data input with `sentinel()` selector.
            abi.encodePacked(bytes4(keccak256("sentinel()")), data_)
        );

        // Expect `delegatecall` to return `true` on call to non-contract address.
        assertTrue(success);

        // Expect return data to be empty, result is `popped`.
        assertEq(abi.encodePacked(data), abi.encodePacked(""));

        vm.stopPrank();
    }
}
