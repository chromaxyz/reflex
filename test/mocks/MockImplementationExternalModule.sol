// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseExternalModule} from "../../src/BaseExternalModule.sol";

/**
 * @title Mock Implementation External Module
 */
contract MockImplementationExternalModule is BaseExternalModule {
    // =======
    // Storage
    // =======

    /**
     * @notice Implementation state 1.
     * @dev Slot 51 (32 bytes).
     */
    uint256 internal _implementationState1;

    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleConfiguration_ Module configuration.
     */
    constructor(ModuleConfiguration memory moduleConfiguration_) BaseExternalModule(moduleConfiguration_) {}

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
