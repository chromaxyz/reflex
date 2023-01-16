// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseExternalModule} from "./interfaces/IBaseExternalModule.sol";

// Sources
import {BaseConstants} from "./BaseConstants.sol";

/**
 * @title Base External Module
 * @dev Does not inherit storage, maintains its own.
 * @dev Upgradeable.
 */
abstract contract BaseExternalModule is IBaseExternalModule, BaseConstants {
    // ==========
    // Immutables
    // ==========

    /**
     * @notice Module id.
     */
    uint32 internal immutable _moduleId;

    /**
     * @notice Module type.
     */
    uint16 internal immutable _moduleType;

    /**
     * @notice Module version.
     */
    uint32 internal immutable _moduleVersion;

    /**
     * @notice Whether the module is upgradeable.
     */
    bool private immutable _moduleUpgradeable;

    /**
     * @notice Whether the module is removeable.
     */
    bool private immutable _moduleRemoveable;

    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleConfiguration_ Module configuration.
     */
    constructor(ModuleConfiguration memory moduleConfiguration_) {
        if (moduleConfiguration_.moduleId == 0) revert InvalidModuleId();
        if (moduleConfiguration_.moduleVersion == 0) revert InvalidModuleVersion();

        _moduleId = moduleConfiguration_.moduleId;
        _moduleType = _MODULE_TYPE_EXTERNAL;
        _moduleVersion = moduleConfiguration_.moduleVersion;
        _moduleUpgradeable = moduleConfiguration_.moduleUpgradeable;
        _moduleRemoveable = moduleConfiguration_.moduleRemoveable;
    }

    // ============
    // View methods
    // ============

    /**
     * @notice Get module id.
     * @return uint32 Module id.
     */
    function moduleId() external view virtual override returns (uint32) {
        return _moduleId;
    }

    /**
     * @notice Get module type.
     * @return uint16 Module type.
     */
    function moduleType() external view virtual override returns (uint16) {
        return _moduleType;
    }

    /**
     * @notice Get module version.
     * @return uint32 Module version.
     */
    function moduleVersion() external view virtual override returns (uint32) {
        return _moduleVersion;
    }

    /**
     * @notice Get whether module is upgradeable.
     * @return bool Whether module is upgradeable.
     */
    function moduleUpgradeable() external view virtual override returns (bool) {
        return _moduleUpgradeable;
    }

    /**
     * @notice Get whether module is removeable.
     * @return bool Whether module is removeable.
     */
    function moduleRemoveable() external view virtual override returns (bool) {
        return _moduleUpgradeable;
    }

    /**
     * @notice Get the module settings.
     * @return ModuleSettings Module settings.
     */
    function moduleSettings() external view virtual override returns (ModuleSettings memory) {
        return
            ModuleSettings({
                moduleId: _moduleId,
                moduleType: _moduleType,
                moduleVersion: _moduleVersion,
                moduleUpgradeable: _moduleUpgradeable,
                moduleRemoveable: _moduleRemoveable
            });
    }
}
