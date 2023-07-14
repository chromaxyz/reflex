// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
import {VmSafe} from "forge-std/Vm.sol";

// Interfaces
import {IReflexDispatcher} from "../../src/interfaces/IReflexDispatcher.sol";
import {IReflexModule} from "../../src/interfaces/IReflexModule.sol";

// Fixtures
import {ReflexFixture} from "../fixtures/ReflexFixture.sol";

// Mocks
import {MockImplementationERC20} from "../mocks/MockImplementationERC20.sol";
import {MockImplementationERC20Hub} from "../mocks/MockImplementationERC20Hub.sol";
import {MockReflexDispatcher} from "../mocks/MockReflexDispatcher.sol";
import {MockReflexModule} from "../mocks/MockReflexModule.sol";

/**
 * @title Reflex Dispatcher Test
 */
contract ReflexDispatcherTest is ReflexFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_SINGLE = 100;
    uint32 internal constant _MODULE_ID_MULTI_AB = 101;

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

    function testFuzzRevertModuleNotRegistered(address target_, uint256 amountA_, uint256 amountB_) external {
        MockImplementationERC20Hub singleModule = new MockImplementationERC20Hub(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_SINGLE, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModule);
        installerEndpoint.addModules(moduleAddresses);

        MockImplementationERC20Hub singleModuleEndpoint = MockImplementationERC20Hub(
            dispatcher.getEndpoint(_MODULE_ID_SINGLE)
        );

        MockImplementationERC20 multiModuleAB = new MockImplementationERC20(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_MULTI_AB, moduleType: _MODULE_TYPE_MULTI_ENDPOINT})
        );

        MockImplementationERC20 multiModuleEndpointA = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_ID_MULTI_AB,
                _MODULE_TYPE_MULTI_ENDPOINT,
                _MODULE_NAME_MULTI_A,
                _MODULE_SYMBOL_MULTI_A,
                _MODULE_DECIMALS_MULTI_A
            )
        );

        MockImplementationERC20 multiModuleEndpointB = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_ID_MULTI_AB,
                _MODULE_TYPE_MULTI_ENDPOINT,
                _MODULE_NAME_MULTI_B,
                _MODULE_SYMBOL_MULTI_B,
                _MODULE_DECIMALS_MULTI_B
            )
        );

        vm.expectRevert(IReflexDispatcher.ModuleNotRegistered.selector);
        multiModuleEndpointA.mint(target_, amountA_);

        vm.expectRevert(IReflexDispatcher.ModuleNotRegistered.selector);
        multiModuleEndpointB.mint(target_, amountB_);

        moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleAB);
        installerEndpoint.addModules(moduleAddresses);

        multiModuleEndpointA.mint(target_, amountA_);
        assertEq(multiModuleEndpointA.balanceOf(target_), amountA_);

        multiModuleEndpointB.mint(target_, amountB_);
        assertEq(multiModuleEndpointB.balanceOf(target_), amountB_);
    }
}
