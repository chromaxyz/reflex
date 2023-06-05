// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "../../src/interfaces/IReflexModule.sol";

// Sources
import {ReflexBase} from "../../src/ReflexBase.sol";
import {ReflexInstaller} from "../../src/ReflexInstaller.sol";
import {ReflexModule} from "../../src/ReflexModule.sol";

// Mocks
import {MockReflexBase} from "./MockReflexBase.sol";
import {MockReflexModule} from "./MockReflexModule.sol";

/**
 * @title Mock Reflex Installer
 */
contract MockReflexInstaller is ReflexInstaller, MockReflexModule {
    // =======
    // Storage
    // =======

    /**
     * @dev `bytes32(uint256(keccak256("before.module.registration.counter")) - 1))`
     */
    bytes32 internal constant _BEFORE_MODULE_REGISTRATION_COUNTER_SLOT =
        0x1b727d455ca13074852c4008c1e770610a44626677660029eca1c6d393a06641;

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

    function beforeModuleRegistrationCounter() public view returns (uint256 n_) {
        n_ = _getCounter(_BEFORE_MODULE_REGISTRATION_COUNTER_SLOT);
    }

    function _beforeModuleRegistration(IReflexModule.ModuleSettings memory x_, address y_) internal override {
        _increaseCounter(_BEFORE_MODULE_REGISTRATION_COUNTER_SLOT);

        // Force coverage to flag this branch as covered.
        super._beforeModuleRegistration(x_, y_);
    }

    // ============
    // Overrides
    // ============

    function _beforeEndpointCreation(
        uint32 moduleId_
    ) internal pure virtual override(ReflexBase, MockReflexModule) returns (bytes memory) {
        return super._beforeEndpointCreation(moduleId_);
    }
}
