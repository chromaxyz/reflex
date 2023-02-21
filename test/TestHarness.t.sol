// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Fixtures
import {TestHarness} from "./fixtures/TestHarness.sol";

/**
 * @title Test Harness Test
 */
contract TestHarnessTest is TestHarness {
    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();
    }

    // =====
    // Tests
    // =====

    function testBrutalizeMemory() public brutalizeMemory {
        bytes32 scratchSpace1;
        bytes32 scratchSpace2;
        bytes32 freeMem1;
        bytes32 freeMem2;

        assembly {
            scratchSpace1 := mload(0)
            scratchSpace2 := mload(32)
            freeMem1 := mload(mload(0x40))
            freeMem2 := mload(add(mload(0x40), 32))
        }

        assertGt(uint256(freeMem1), 0);
        assertGt(uint256(freeMem2), 0);
        assertGt(uint256(scratchSpace1), 0);
        assertGt(uint256(scratchSpace2), 0);
    }

    function testBrutalizeMemoryWith() public brutalizeMemoryWith("FEEDFACECAFEBEEFFEEDFACECAFEBEEF") {
        bytes32 scratchSpace1;
        bytes32 scratchSpace2;
        bytes32 freeMem1;
        bytes32 freeMem2;

        assembly {
            scratchSpace1 := mload(0)
            scratchSpace2 := mload(32)
            freeMem1 := mload(mload(0x40))
            freeMem2 := mload(add(mload(0x40), 32))
        }

        assertGt(uint256(freeMem1), 0);
        assertGt(uint256(freeMem2), 0);
        assertGt(uint256(scratchSpace1), 0);
        assertGt(uint256(scratchSpace2), 0);
    }
}
