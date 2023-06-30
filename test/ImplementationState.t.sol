// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
import {Test} from "forge-std/Test.sol";

// Interfaces
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Sources
import {ReflexConstants} from "../src/ReflexConstants.sol";

// Mocks
import {ImplementationState} from "../test/mocks/abstracts/ImplementationState.sol";
import {MockImplementationDispatcher} from "../test/mocks/MockImplementationDispatcher.sol";
import {MockImplementationInstaller} from "../test/mocks/MockImplementationInstaller.sol";
import {MockImplementationModule} from "../test/mocks/MockImplementationModule.sol";

/**
 * @title Implementation State Test
 * @dev Used compiler version: solc 0.8.19+commit.7dd6d404
 */
contract ImplementationStateTest is ReflexConstants, Test {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_VERSION_INSTALLER = 1;
    bool internal constant _MODULE_UPGRADEABLE_INSTALLER = true;

    uint32 internal constant _MODULE_ID_EXAMPLE = 2;
    uint32 internal constant _MODULE_VERSION_EXAMPLE = 1;
    bool internal constant _MODULE_UPGRADEABLE_EXAMPLE = true;

    // =======
    // Storage
    // =======

    MockImplementationInstaller public installerImplementation;
    MockImplementationInstaller public installerEndpoint;

    MockImplementationDispatcher public dispatcher;

    MockImplementationModule public exampleModuleImplementation;
    MockImplementationModule public exampleModuleEndpoint;

    // =====
    // Tests
    // =====

    function testUnitStorageLayout() external {
        installerImplementation = new MockImplementationInstaller(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_ENDPOINT,
                moduleVersion: _MODULE_VERSION_INSTALLER,
                moduleUpgradeable: _MODULE_UPGRADEABLE_INSTALLER
            })
        );

        dispatcher = new MockImplementationDispatcher(address(this), address(installerImplementation));

        installerEndpoint = MockImplementationInstaller(dispatcher.getEndpoint(_MODULE_ID_INSTALLER));

        exampleModuleImplementation = new MockImplementationModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_EXAMPLE,
                moduleType: _MODULE_TYPE_SINGLE_ENDPOINT,
                moduleVersion: _MODULE_VERSION_EXAMPLE,
                moduleUpgradeable: _MODULE_UPGRADEABLE_EXAMPLE
            })
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(exampleModuleImplementation);
        installerEndpoint.addModules(moduleAddresses);

        exampleModuleEndpoint = MockImplementationModule(dispatcher.getEndpoint(_MODULE_ID_EXAMPLE));

        bytes32 reflexStorageSlot = dispatcher.REFLEX_STORAGE_SLOT();
        bytes32 implementationStorageSlot = dispatcher.IMPLEMENTATION_STORAGE_SLOT();

        // Assert owner is stored in Reflex storage slot 1.

        /**
         * | Name                | Type    | Slot                   | Offset | Bytes |
         * |---------------------|---------|------------------------|--------|-------|
         * | ReflexStorage.owner | address | RELEX_STORAGE_SLOT + 1 | 1      | 32    |
         */
        assertEq(dispatcher.sload(bytes32(uint256(reflexStorageSlot) + 1)), bytes32(uint256(uint160(address(this)))));

        // Assert pending owner is stored in Reflex storage slot 2.

        /**
         * | Name                       | Type    | Slot                   | Offset | Bytes |
         * |----------------------------|---------|------------------------|--------|-------|
         * | ReflexStorage.pendingOwner | address | RELEX_STORAGE_SLOT + 2 | 2      | 32    |
         */
        assertEq(dispatcher.sload(bytes32(uint256(reflexStorageSlot) + 2)), bytes32(uint256(uint160(address(0)))));

        installerEndpoint.transferOwnership(address(0xdeadbeef));

        assertEq(
            dispatcher.sload(bytes32(uint256(reflexStorageSlot) + 2)),
            bytes32(uint256(uint160(address(0xdeadbeef))))
        );
    }
}
