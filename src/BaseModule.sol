// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseModule} from "./interfaces/IBaseModule.sol";

// Sources
import {Base} from "./Base.sol";

/**
 * @title Base Module
 * @dev Execution takes place within the Dispatcher's storage context.
 * @dev Upgradeable.
 */
abstract contract BaseModule is IBaseModule, Base {
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

    // =========
    // Modifiers
    // =========

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() virtual {
        address messageSender = _unpackMessageSender();

        if (messageSender != _owner) revert Unauthorized();

        _;
    }

    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) {
        if (moduleSettings_.moduleId == 0) revert InvalidModuleId();
        if (moduleSettings_.moduleType == 0 || moduleSettings_.moduleType > _MODULE_TYPE_INTERNAL)
            revert InvalidModuleType();
        if (moduleSettings_.moduleVersion == 0) revert InvalidModuleVersion();

        _moduleId = moduleSettings_.moduleId;
        _moduleType = moduleSettings_.moduleType;
        _moduleVersion = moduleSettings_.moduleVersion;
        _moduleUpgradeable = moduleSettings_.moduleUpgradeable;
        _moduleRemoveable = moduleSettings_.moduleRemoveable;
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
