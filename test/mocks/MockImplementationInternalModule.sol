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

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(
        ModuleSettings memory moduleSettings_
    ) BaseModule(moduleSettings_) {}

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
