// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "../../src/interfaces/IReflexModule.sol";

// Sources
import {ReflexBase} from "../../src/ReflexBase.sol";
import {ReflexInstaller} from "../../src/ReflexInstaller.sol";

// Fixtures
import {MockHarness} from "../fixtures/MockHarness.sol";

// Mocks
import {MockReflexModule} from "./MockReflexModule.sol";

/**
 * @title Mock Reflex Installer
 */
contract MockReflexInstaller is MockHarness, ReflexInstaller, MockReflexModule {
    // =======
    // Storage
    // =======

    /**
     * @dev `bytes32(uint256(keccak256("_BEFORE_MODULE_REGISTRATION_COUNTER_SLOT")) - 1)`
     */
    bytes32 internal constant _BEFORE_MODULE_REGISTRATION_COUNTER_SLOT =
        0xc82728fbf88d85985c7f4b166fd4d8f3cb0195675e8a793d2788ed1d7b80c621;

    /**
     * @dev `bytes32(uint256(keccak256("_GET_ENDPOINT_CREATION_CODE_COUNTER_SLOT")) - 1)`
     */
    bytes32 internal constant _GET_ENDPOINT_CREATION_CODE_COUNTER_SLOT =
        0xf8b59a32e9704d69f615f3a37ed658787f1810f89b57ba1e8fae0a749ff9b3d9;

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

    function getEndpointCreationCodeCounter() public view returns (uint256 n_) {
        n_ = _getCounter(_GET_ENDPOINT_CREATION_CODE_COUNTER_SLOT);
    }

    function _getEndpointCreationCode(
        uint32 moduleId_
    ) internal virtual override(ReflexBase, MockReflexModule) returns (bytes memory) {
        _increaseCounter(_GET_ENDPOINT_CREATION_CODE_COUNTER_SLOT);

        // Force coverage to flag this branch as covered.
        return super._getEndpointCreationCode(moduleId_);
    }
}
