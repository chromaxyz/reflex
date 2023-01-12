// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseModule} from "../src/interfaces/IBaseModule.sol";
import {TProxy} from "../src/interfaces/IProxy.sol";

// Internals
import {Proxy} from "../src/internals/Proxy.sol";

// Sources
import {BaseConstants} from "../src/BaseConstants.sol";

// Fixtures
import {Harness} from "./fixtures/Harness.sol";

/**
 * @title Proxy Test
 */
contract ProxyTest is TProxy, BaseConstants, Harness {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_VALID_ID = 100;
    uint16 internal constant _MODULE_VALID_TYPE = _MODULE_TYPE_SINGLE_PROXY;

    // =======
    // Storage
    // =======

    Proxy public proxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        proxy = new Proxy(_MODULE_VALID_ID, _MODULE_VALID_TYPE);
    }

    // =====
    // Tests
    // =====

    function testRevertInvalidModuleId() external {
        vm.expectRevert(InvalidModuleId.selector);
        new Proxy(0, _MODULE_VALID_TYPE);
    }

    function testRevertInvalidModuleType() external {
        vm.expectRevert(InvalidModuleType.selector);
        new Proxy(_MODULE_VALID_ID, 777);
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
