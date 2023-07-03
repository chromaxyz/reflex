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

    // solhint-disable-next-line var-name-mixedcase
    bytes32 public REFLEX_STORAGE_SLOT;
    // solhint-disable-next-line var-name-mixedcase
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

        // Due to StdStorage not supporting packed slots at this point in time
        // we access the underlying storage slots directly.
        bytes32[] memory reads;
        bytes32 current;

        /**
         * | Name                           | Type    | Slot                   | Offset | Bytes |
         * |--------------------------------|---------|------------------------|--------|-------|
         * | ReflexStorage.reentrancyStatus | address | RELEX_STORAGE_SLOT + 0 | 0      | 32    |
         */
        vm.record();
        dispatcher.getReflexState0();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(REFLEX_STORAGE_SLOT) + 0);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(uint256(current), 1);

        /**
         * | Name                | Type    | Slot                   | Offset | Bytes |
         * |---------------------|---------|------------------------|--------|-------|
         * | ReflexStorage.owner | address | RELEX_STORAGE_SLOT + 1 | 0      | 32    |
         */
        vm.record();
        dispatcher.getReflexState1();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(REFLEX_STORAGE_SLOT) + 1);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), address(this));

        /**
         * | Name                       | Type    | Slot                   | Offset | Bytes |
         * |----------------------------|---------|------------------------|--------|-------|
         * | ReflexStorage.pendingOwner | address | RELEX_STORAGE_SLOT + 2 | 0      | 32    |
         */
        vm.record();
        dispatcher.getReflexState2();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(REFLEX_STORAGE_SLOT) + 2);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), address(0));

        installerEndpoint.transferOwnership(address(target_));

        vm.record();
        dispatcher.getReflexState2();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(REFLEX_STORAGE_SLOT) + 2);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), address(target_));

        /**
         * | Name                | Type    | Slot                    | Offset | Bytes |
         * |---------------------|---------|-------------------------|--------|-------|
         * | ReflexState.modules | address | REFLEX_STORAGE_SLOT + 3 | 0      | 32    |
         */
        vm.record();
        dispatcher.getReflexState3(_MODULE_ID_EXAMPLE);
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq((reads[0]), keccak256(abi.encode(_MODULE_ID_EXAMPLE, uint256(REFLEX_STORAGE_SLOT) + 3)));
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), address(exampleModuleImplementation));

        /**
         * | Name                  | Type    | Slot                    | Offset | Bytes |
         * |-----------------------|---------|-------------------------|--------|-------|
         * | ReflexState.endpoints | address | REFLEX_STORAGE_SLOT + 4 | 0      | 32    |
         */
        vm.record();
        dispatcher.getReflexState4(_MODULE_ID_EXAMPLE);
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq((reads[0]), keccak256(abi.encode(_MODULE_ID_EXAMPLE, uint256(REFLEX_STORAGE_SLOT) + 4)));
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), address(exampleModuleEndpoint));

        /**
         * | Name                  | Type    | Slot                    | Offset | Bytes |
         * |-----------------------|---------|-------------------------|--------|-------|
         * | ReflexState.relations | address | REFLEX_STORAGE_SLOT + 5 | 0      | 32    |
         */
        vm.record();
        dispatcher.getReflexState5(address(exampleModuleEndpoint));
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq((reads[0]), keccak256(abi.encode(address(exampleModuleEndpoint), uint256(REFLEX_STORAGE_SLOT) + 5)));
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(uint32(uint256(current)), exampleModuleImplementation.moduleId());
        assertEq(uint16(uint256(current) >> 32), exampleModuleImplementation.moduleType());
        assertEq(address(uint160(uint256(current) >> 48)), address(exampleModuleImplementation));
    }

    function testFuzzStorageImplementationStorageLayout(
        bytes32 message_,
        uint256 number_,
        address target_,
        bool flag_,
        address tokenA_,
        address tokenB_
    ) external {
        // Due to StdStorage not supporting packed slots at this point in time
        // we access the underlying storage slots directly.
        bytes32[] memory reads;
        bytes32 current;

        // Set implementation state.
        installerEndpoint.setImplementationState(message_, number_, target_, flag_, tokenA_, tokenB_);

        /**
         * | Name                                     | Type    | Slot                            | Offset | Bytes |
         * |------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationState.implementationState0 | address | IMPLEMENTATION_STORAGE_SLOT + 0 | 0      | 32    |
         */
        vm.record();
        dispatcher.getImplementationState0();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(IMPLEMENTATION_STORAGE_SLOT) + 0);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(current, message_);

        /**
         * | Name                                     | Type    | Slot                            | Offset | Bytes |
         * |------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationState.implementationState1 | address | IMPLEMENTATION_STORAGE_SLOT + 1 | 0      | 32    |
         */
        vm.record();
        dispatcher.getImplementationState1();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(IMPLEMENTATION_STORAGE_SLOT) + 1);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(uint256(current), number_);

        /**
         * | Name                                     | Type    | Slot                            | Offset | Bytes |
         * |------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationState.implementationState2 | address | IMPLEMENTATION_STORAGE_SLOT + 2 | 0      | 20    |
         */
        vm.record();
        dispatcher.getImplementationState2();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(IMPLEMENTATION_STORAGE_SLOT) + 2);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), target_);

        /**
         * | Name                                     | Type    | Slot                            | Offset | Bytes |
         * |------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationState.implementationState3 | address | IMPLEMENTATION_STORAGE_SLOT + 3 | 0      | 20    |
         */
        vm.record();
        dispatcher.getImplementationState3();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(IMPLEMENTATION_STORAGE_SLOT) + 3);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), target_);

        /**
         * | Name                                     | Type    | Slot                            | Offset | Bytes |
         * |------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationState.implementationState4 | address | IMPLEMENTATION_STORAGE_SLOT + 3 | 0      | 1     |
         */
        vm.record();
        dispatcher.getImplementationState4();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(IMPLEMENTATION_STORAGE_SLOT) + 3);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(uint8(uint256(current) >> 160), _castBoolToUInt8(flag_));

        /**
         * | Name                                     | Type    | Slot                            | Offset | Bytes |
         * |------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationState.implementationState5 | address | IMPLEMENTATION_STORAGE_SLOT + 4 | 0      | 32    |
         */
        vm.record();
        dispatcher.getImplementationState5(target_);
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq((reads[0]), keccak256(abi.encode(target_, uint256(IMPLEMENTATION_STORAGE_SLOT) + 4)));
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(uint256(current), number_);

        /**
         * | Name                       | Type    | Slot                            | Offset | Bytes |
         * |----------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationState.tokens | address | IMPLEMENTATION_STORAGE_SLOT + 5 | 0      | 32    |
         */
        vm.record();
        dispatcher.getToken(tokenA_, address(dispatcher));
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq((reads[0]), keccak256(abi.encode(tokenA_, uint256(IMPLEMENTATION_STORAGE_SLOT) + 5)));

        vm.record();
        dispatcher.getToken(tokenB_, address(dispatcher));
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq((reads[0]), keccak256(abi.encode(tokenB_, uint256(IMPLEMENTATION_STORAGE_SLOT) + 5)));
    }

    // =========
    // Utilities
    // =========

    /**
     * @dev Cast bool to uint8.
     */
    function _castBoolToUInt8(bool x_) internal pure returns (uint8 r_) {
        assembly ("memory-safe") {
            r_ := x_
        }
    }
}
