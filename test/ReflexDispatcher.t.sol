// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
import {VmSafe} from "forge-std/Vm.sol";

// Interfaces
import {IReflexDispatcher} from "../src/interfaces/IReflexDispatcher.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {MockImplementationERC20} from "./mocks/MockImplementationERC20.sol";
import {MockImplementationERC20Hub} from "./mocks/MockImplementationERC20Hub.sol";
import {MockReflexDispatcher} from "./mocks/MockReflexDispatcher.sol";
import {MockReflexModule} from "./mocks/MockReflexModule.sol";

/**
 * @title Reflex Dispatcher Test
 */
contract ReflexDispatcherTest is ReflexFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_SINGLE = 100;
    uint32 internal constant _MODULE_ID_MULTI_A = 101;
    uint32 internal constant _MODULE_ID_MULTI_B = 102;

    string internal constant _MODULE_NAME_MULTI_A = "TOKEN A";
    string internal constant _MODULE_SYMBOL_MULTI_A = "TKNA";
    uint8 internal constant _MODULE_DECIMALS_MULTI_A = 18;

    string internal constant _MODULE_NAME_MULTI_B = "TOKEN B";
    string internal constant _MODULE_SYMBOL_MULTI_B = "TKNB";
    uint8 internal constant _MODULE_DECIMALS_MULTI_B = 6;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        assertEq(dispatcher.getDispatcherEndpointCreationCodeCounter(), 1);
    }

    // =====
    // Tests
    // =====

    function testUnitRevertInvalidOwnerZeroAddress() external {
        vm.expectRevert(IReflexDispatcher.ZeroAddress.selector);
        new MockReflexDispatcher(address(0), address(installerImplementation));
    }

    function testUnitRevertInvalidInstallerZeroAddress() external {
        vm.expectRevert(IReflexDispatcher.ZeroAddress.selector);
        new MockReflexDispatcher(address(this), address(0));
    }

    function testUnitRevertInvalidInstallerModuleId() external {
        vm.expectRevert();
        new MockReflexDispatcher(address(this), address(_users.Alice));
    }

    function testFuzzRevertInvalidInstallerModuleId(uint32 moduleId_) external {
        vm.assume(moduleId_ != 0);
        vm.assume(moduleId_ != _MODULE_ID_INSTALLER);

        MockReflexModule module = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: moduleId_, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        vm.expectRevert(IReflexModule.ModuleIdInvalid.selector);
        new MockReflexDispatcher(address(this), address(module));
    }

    function testUnitRevertInvalidInstallerModuleType() external {
        MockReflexModule module = new MockReflexModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_INSTALLER, moduleType: _MODULE_TYPE_MULTI_ENDPOINT})
        );

        vm.expectRevert(IReflexModule.ModuleTypeInvalid.selector);
        new MockReflexDispatcher(address(this), address(module));
    }

    function testUnitLogEmittanceUponConstruction() external {
        vm.recordLogs();

        MockReflexDispatcher dispatcher_ = new MockReflexDispatcher(address(this), address(installerImplementation));

        address installerEndpoint_ = dispatcher_.getEndpoint(_MODULE_ID_INSTALLER);

        VmSafe.Log[] memory entries = vm.getRecordedLogs();

        // 3 logs are expected to be emitted.
        assertEq(entries.length, 3);

        // emit EndpointCreated(address,uint32)
        assertEq(entries[0].topics.length, 3);
        assertEq(entries[0].topics[0], keccak256("EndpointCreated(uint32,address)"));
        assertEq(entries[0].topics[1], bytes32(uint256(_MODULE_ID_INSTALLER)));
        assertEq(entries[0].topics[2], bytes32(uint256(uint160(address(installerEndpoint_)))));
        assertEq(entries[0].emitter, address(dispatcher_));

        // emit OwnershipTransferred(address,address);
        assertEq(entries[1].topics.length, 3);
        assertEq(entries[1].topics[0], keccak256("OwnershipTransferred(address,address)"));
        assertEq(entries[1].topics[1], bytes32(uint256(uint160(address(0)))));
        assertEq(entries[1].topics[2], bytes32(uint256(uint160(address(this)))));
        assertEq(entries[1].emitter, address(dispatcher_));

        // emit ModuleAdded(uint32,address);
        assertEq(entries[2].topics.length, 3);
        assertEq(entries[2].topics[0], keccak256("ModuleAdded(uint32,address)"));
        assertEq(entries[2].topics[1], bytes32(uint256(_MODULE_ID_INSTALLER)));
        assertEq(entries[2].topics[2], bytes32(uint256(uint160(address(installerImplementation)))));
        assertEq(entries[2].emitter, address(dispatcher_));
    }

    function testUnitInstallerConfiguration() external {
        assertEq(dispatcher.getEndpoint(_MODULE_ID_INSTALLER), address(installerEndpoint));
        assertEq(dispatcher.getModuleImplementation(_MODULE_ID_INSTALLER), address(installerImplementation));
        assertEq(installerEndpoint.owner(), address(this));
    }

    function testUnitRevertDispatchCallerNotTrusted() external {
        (bool success, bytes memory result) = address(dispatcher).call(
            "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        );

        assertFalse(success);

        vm.expectRevert(IReflexDispatcher.CallerNotTrusted.selector);
        assembly ("memory-safe") {
            revert(add(32, result), mload(result))
        }
    }

    function testUnitRevertDispatchMessageTooShort() external {
        vm.prank(address(installerEndpoint));

        (bool success, bytes memory result) = address(dispatcher).call("");

        assertFalse(success);

        vm.expectRevert(IReflexDispatcher.MessageTooShort.selector);
        assembly ("memory-safe") {
            revert(add(32, result), mload(result))
        }
    }

    // function testUnitRevertModuleNotRegistered() external {
    //     MockImplementationERC20Hub singleModule = new MockImplementationERC20Hub(
    //         IReflexModule.ModuleSettings({moduleId: _MODULE_ID_SINGLE, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
    //     );

    //     MockImplementationERC20 multiModule = new MockImplementationERC20(
    //         IReflexModule.ModuleSettings({moduleId: _MODULE_ID_MULTI_A, moduleType: _MODULE_TYPE_MULTI_ENDPOINT})
    //     );

    //     address[] memory moduleAddresses = new address[](2);
    //     moduleAddresses[1] = address(singleModule);
    //     moduleAddresses[2] = address(multiModule);
    //     installerEndpoint.addModules(moduleAddresses);

    //     MockImplementationERC20Hub singleModuleEndpoint = MockImplementationERC20Hub(
    //         dispatcher.getEndpoint(_MODULE_ID_SINGLE)
    //     );

    //     address[] memory moduleAddresses = new address[](1);
    //     moduleAddresses[0] = address(singleModule);
    //     installerEndpoint.addModules(moduleAddresses);

    //     MockImplementationERC20 multiModuleEndpointA = MockImplementationERC20(
    //         singleModuleEndpoint.addERC20(
    //             _MODULE_ID_MULTI_A,
    //             _MODULE_TYPE_MULTI_ENDPOINT,
    //             _MODULE_NAME_MULTI_A,
    //             _MODULE_SYMBOL_MULTI_A,
    //             _MODULE_DECIMALS_MULTI_A
    //         )
    //     );

    //     MockImplementationERC20 multiModuleEndpointA = singleModuleEndpoint.addERC20(
    //         _MODULE_ID_MULTI_B,
    //         _MODULE_TYPE_MULTI_ENDPOINT,
    //         _MODULE_NAME_MULTI_B,
    //         _MODULE_SYMBOL_MULTI_B,
    //         _MODULE_DECIMALS_MULTI_B
    //     );

    //     vm.expectRevert(IReflexDispatcher.ModuleNotRegistered.selector);

    //     // (bool success, bytes memory result) = address(dispatcher).call(
    //     //     "0x44733ae17fa9385be102ac3eac297483dd6233d62b3e14968d2c17fad02b7bb64139109c6533b7c2b9cadb81"
    //     // );
    //     // assertFalse(success);
    //     // assembly ("memory-safe") {
    //     //     revert(add(32, result), mload(result))
    //     // }
    // }
}
