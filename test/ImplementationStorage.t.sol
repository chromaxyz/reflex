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
contract ImplementationStorageTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_SINGLE = 100;

    // =======
    // Storage
    // =======

    MockImplementationModule public singleModuleImplementation;
    MockImplementationModule public singleModuleEndpoint;

    // solhint-disable-next-line var-name-mixedcase
    bytes32 public REFLEX_STORAGE_SLOT;
    // solhint-disable-next-line var-name-mixedcase
    bytes32 public IMPLEMENTATION_STORAGE_SLOT;

    // =====
    // Tests
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModuleImplementation = new MockImplementationModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_SINGLE, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModuleImplementation);
        installerEndpoint.addModules(moduleAddresses);

        singleModuleEndpoint = MockImplementationModule(dispatcher.getEndpoint(_MODULE_ID_SINGLE));

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
         * | Name                                 | Type    | Slot                   | Offset | Bytes |
         * |--------------------------------------|---------|------------------------|--------|-------|
         * | ReflexStorageLayout.reentrancyStatus | address | RELEX_STORAGE_SLOT + 0 | 0      | 32    |
         */
        vm.record();
        dispatcher.getReflexStorage0();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(REFLEX_STORAGE_SLOT) + 0);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(uint256(current), 1);

        /**
         * | Name                      | Type    | Slot                   | Offset | Bytes |
         * |---------------------------|---------|------------------------|--------|-------|
         * | ReflexStorageLayout.owner | address | RELEX_STORAGE_SLOT + 1 | 0      | 32    |
         */
        vm.record();
        dispatcher.getReflexStorage1();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(REFLEX_STORAGE_SLOT) + 1);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), address(this));

        /**
         * | Name                             | Type    | Slot                   | Offset | Bytes |
         * |----------------------------------|---------|------------------------|--------|-------|
         * | ReflexStorageLayout.pendingOwner | address | RELEX_STORAGE_SLOT + 2 | 0      | 32    |
         */
        vm.record();
        dispatcher.getReflexStorage2();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(REFLEX_STORAGE_SLOT) + 2);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), address(0));

        installerEndpoint.transferOwnership(address(target_));

        vm.record();
        dispatcher.getReflexStorage2();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(REFLEX_STORAGE_SLOT) + 2);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), address(target_));

        /**
         * | Name                        | Type    | Slot                    | Offset | Bytes |
         * |-----------------------------|---------|-------------------------|--------|-------|
         * | ReflexStorageLayout.modules | address | REFLEX_STORAGE_SLOT + 3 | 0      | 32    |
         */
        vm.record();
        dispatcher.getReflexStorage3(_MODULE_ID_SINGLE);
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq((reads[0]), keccak256(abi.encode(_MODULE_ID_SINGLE, uint256(REFLEX_STORAGE_SLOT) + 3)));
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), address(singleModuleImplementation));

        /**
         * | Name                          | Type    | Slot                    | Offset | Bytes |
         * |-------------------------------|---------|-------------------------|--------|-------|
         * | ReflexStorageLayout.endpoints | address | REFLEX_STORAGE_SLOT + 4 | 0      | 32    |
         */
        vm.record();
        dispatcher.getReflexStorage4(_MODULE_ID_SINGLE);
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq((reads[0]), keccak256(abi.encode(_MODULE_ID_SINGLE, uint256(REFLEX_STORAGE_SLOT) + 4)));
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), address(singleModuleEndpoint));

        /**
         * | Name                          | Type    | Slot                    | Offset | Bytes |
         * |-------------------------------|---------|-------------------------|--------|-------|
         * | ReflexStorageLayout.relations | address | REFLEX_STORAGE_SLOT + 5 | 0      | 32    |
         */
        vm.record();
        dispatcher.getReflexStorage5(address(singleModuleEndpoint));
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq((reads[0]), keccak256(abi.encode(address(singleModuleEndpoint), uint256(REFLEX_STORAGE_SLOT) + 5)));
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(uint32(uint256(current)), singleModuleImplementation.moduleId());
        assertEq(address(uint160(uint256(current) >> 32)), address(singleModuleImplementation));
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

        // Set implementation storage.
        installerEndpoint.setImplementationStorage(message_, number_, target_, flag_, tokenA_, tokenB_);

        /**
         * | Name                                         | Type    | Slot                            | Offset | Bytes |
         * |----------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationStorage.implementationStorage0 | address | IMPLEMENTATION_STORAGE_SLOT + 0 | 0      | 32    |
         */
        vm.record();
        dispatcher.getImplementationStorage0();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(IMPLEMENTATION_STORAGE_SLOT) + 0);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(current, message_);

        /**
         * | Name                                         | Type    | Slot                            | Offset | Bytes |
         * |----------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationStorage.implementationStorage1 | address | IMPLEMENTATION_STORAGE_SLOT + 1 | 0      | 32    |
         */
        vm.record();
        dispatcher.getImplementationStorage1();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(IMPLEMENTATION_STORAGE_SLOT) + 1);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(uint256(current), number_);

        /**
         * | Name                                         | Type    | Slot                            | Offset | Bytes |
         * |----------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationStorage.implementationStorage2 | address | IMPLEMENTATION_STORAGE_SLOT + 2 | 0      | 20    |
         */
        vm.record();
        dispatcher.getImplementationStorage2();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(IMPLEMENTATION_STORAGE_SLOT) + 2);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), target_);

        /**
         * | Name                                         | Type    | Slot                            | Offset | Bytes |
         * |----------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationStorage.implementationStorage3 | address | IMPLEMENTATION_STORAGE_SLOT + 3 | 0      | 20    |
         */
        vm.record();
        dispatcher.getImplementationStorage3();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(IMPLEMENTATION_STORAGE_SLOT) + 3);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(address(uint160(uint256(current))), target_);

        /**
         * | Name                                         | Type    | Slot                            | Offset | Bytes |
         * |----------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationStorage.implementationStorage4 | address | IMPLEMENTATION_STORAGE_SLOT + 3 | 0      | 1     |
         */
        vm.record();
        dispatcher.getImplementationStorage4();
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq(uint256(reads[0]), uint256(IMPLEMENTATION_STORAGE_SLOT) + 3);
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(uint8(uint256(current) >> 160), _castBoolToUInt8(flag_));

        /**
         * | Name                                         | Type    | Slot                            | Offset | Bytes |
         * |----------------------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationStorage.implementationStorage5 | address | IMPLEMENTATION_STORAGE_SLOT + 4 | 0      | 32    |
         */
        vm.record();
        dispatcher.getImplementationStorage5(target_);
        (reads, ) = vm.accesses(address(dispatcher));
        assertEq((reads[0]), keccak256(abi.encode(target_, uint256(IMPLEMENTATION_STORAGE_SLOT) + 4)));
        current = vm.load(address(dispatcher), bytes32(reads[0]));
        assertEq(uint256(current), number_);

        /**
         * | Name                         | Type    | Slot                            | Offset | Bytes |
         * |------------------------------|---------|---------------------------------|--------|-------|
         * | ImplementationStorage.tokens | address | IMPLEMENTATION_STORAGE_SLOT + 5 | 0      | 32    |
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
