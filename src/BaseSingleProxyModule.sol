// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Internals
import {BaseModule} from "./internals/BaseModule.sol";

/**
 * @title Base Single Proxy Module
 * @dev Inherits storage, does not maintain its own.
 * @dev Upgradeable.
 */
abstract contract BaseSingleProxyModule is BaseModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleConfiguration_ Module configuration.
     */
    constructor(
        ModuleConfiguration memory moduleConfiguration_
    )
        BaseModule(
            ModuleSettings({
                moduleId: moduleConfiguration_.moduleId,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: moduleConfiguration_.moduleVersion,
                moduleUpgradeable: moduleConfiguration_.moduleUpgradeable,
                moduleRemoveable: moduleConfiguration_.moduleRemoveable
            })
        )
    {}
}
