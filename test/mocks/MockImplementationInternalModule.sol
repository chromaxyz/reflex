// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Implementations
import {ImplementationState} from "../implementations/ImplementationState.sol";

// Mocks
import {MockBaseModule} from "../mocks/MockBaseModule.sol";

/**
 * @title Mock Implementation Internal Module
 */
contract MockImplementationInternalModule is MockBaseModule, ImplementationState {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleConfiguration_ Module configuration.
     */
    constructor(ModuleConfiguration memory moduleConfiguration_) MockBaseModule(moduleConfiguration_) {}

    // ==========
    // Test stubs
    // ==========

    function getImplementationState1() public view returns (uint256) {
        return _implementationState1;
    }

    function setImplementationState1(uint256 number_) external {
        _implementationState1 = number_;
    }
}
