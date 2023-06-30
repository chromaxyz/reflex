// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Sources
import {ReflexConstants} from "../src/ReflexConstants.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationModule} from "./mocks/MockImplementationModule.sol";

/**
 * @title Implementation State Test
 */
contract ImplementationStateTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_EXAMPLE = 2;
    uint32 internal constant _MODULE_VERSION_EXAMPLE = 1;
    bool internal constant _MODULE_UPGRADEABLE_EXAMPLE = true;

    // =======
    // Storage
    // =======

    MockImplementationModule public exampleModuleImplementation;
    MockImplementationModule public exampleModuleEndpoint;

    bytes32 public REFLEX_STORAGE_SLOT;
    bytes32 public IMPLEMENTATION_STORAGE_SLOT;

    // =====
    // Tests
    // =====

    function setUp() public virtual override {
        super.setUp();

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

        REFLEX_STORAGE_SLOT = dispatcher.REFLEX_STORAGE_SLOT();
        IMPLEMENTATION_STORAGE_SLOT = dispatcher.IMPLEMENTATION_STORAGE_SLOT();
    }

    function testFuzzStorageReflexStorageLayout(address target_) external {
        vm.assume(target_ != address(0));

        // Assert owner is stored in Reflex storage slot 1.

        /**
         * | Name                | Type    | Slot                   | Offset | Bytes |
         * |---------------------|---------|------------------------|--------|-------|
         * | ReflexStorage.owner | address | RELEX_STORAGE_SLOT + 1 | 0      | 32    |
         */
        assertEq(dispatcher.sload(bytes32(uint256(REFLEX_STORAGE_SLOT) + 1)), bytes32(uint256(uint160(address(this)))));

        // Assert pending owner is stored in Reflex storage slot 2.

        /**
         * | Name                       | Type    | Slot                   | Offset | Bytes |
         * |----------------------------|---------|------------------------|--------|-------|
         * | ReflexStorage.pendingOwner | address | RELEX_STORAGE_SLOT + 2 | 0      | 32    |
         */
        assertEq(dispatcher.sload(bytes32(uint256(REFLEX_STORAGE_SLOT) + 2)), bytes32(uint256(uint160(address(0)))));

        installerEndpoint.transferOwnership(address(target_));

        assertEq(
            dispatcher.sload(bytes32(uint256(REFLEX_STORAGE_SLOT) + 2)),
            bytes32(uint256(uint160(address(target_))))
        );
    }

    function testFuzzStorageImplementationStorageLayout(
        bytes32 message_,
        uint256 number_,
        address target_,
        address tokenA_,
        address tokenB_,
        bool flag_
    ) external {
        installerEndpoint.setImplementationState(message_, number_, target_, tokenA_, tokenB_, flag_);

        /**
         * | Name                                     | Type    | Slot                            | Offset | Bytes |
         * |------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationState.implementationState0 | address | IMPLEMENTATION_STORAGE_SLOT + 0 | 0      | 32    |
         */
        assertEq(dispatcher.sload(bytes32(uint256(IMPLEMENTATION_STORAGE_SLOT) + 0)), bytes32(message_));
    }
}
