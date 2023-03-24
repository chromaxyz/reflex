// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexModule} from "../../src/ReflexModule.sol";

// Mocks
import {ImplementationState} from "./abstracts/ImplementationState.sol";

/**
 * @title Mock Implementation Gas Module
 */
contract MockImplementationGasModule is ReflexModule, ImplementationState {
    // =======
    // Storage
    // =======

    /**
     * @dev `bytes32(uint256(keccak256("number")) - 1))`
     */
    bytes32 internal constant _NUMBER_SLOT = 0xf648814c67221440671fd7c2de979db4020a9320fb7985ff79ca8e7dced277f7;

    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) ReflexModule(moduleSettings_) {}

    // ==========
    // Test stubs
    // ==========

    function getEmpty() external view {}

    function setNumber(uint8 number_) external {
        assembly ("memory-safe") {
            sstore(_NUMBER_SLOT, number_)
        }
    }

    function getNumber() external view returns (uint8 n_) {
        assembly ("memory-safe") {
            n_ := sload(_NUMBER_SLOT)
        }
    }
}
