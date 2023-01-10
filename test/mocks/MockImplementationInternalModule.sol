// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseModule} from "../../src/BaseModule.sol";

// Implementations
import {ImplementationState} from "../implementations/ImplementationState.sol";

/**
 * @title Mock Implementation Internal Module
 */
contract MockImplementationInternalModule is BaseModule, ImplementationState {
    // ===========
    // Constructor
    // ===========

    constructor(
        uint32 moduleId_,
        uint16 moduleType_,
        uint16 moduleVersion_
    ) BaseModule(moduleId_, moduleType_, moduleVersion_) {}

    // ==========
    // Test stubs
    // ==========

    function getImplementationState1() public view returns (uint256) {
        return _implementationState1;
    }

    function setImplementationState1(uint256 number_) public {
        _implementationState1 = number_;
    }
}
