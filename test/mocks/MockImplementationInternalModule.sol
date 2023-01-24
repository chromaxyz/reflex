// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Mocks
import {ImplementationState} from "./abstracts/ImplementationState.sol";
import {MockReflexModule} from "../mocks/MockReflexModule.sol";

/**
 * @title Mock Implementation Internal Module
 */
contract MockImplementationInternalModule is MockReflexModule, ImplementationState {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockReflexModule(moduleSettings_) {}

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
