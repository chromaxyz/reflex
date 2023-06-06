// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "./interfaces/IReflexModule.sol";

// Sources
import {ReflexBase} from "./ReflexBase.sol";

/**
 * @title Reflex Module
 *
 * @dev Execution takes place within the Dispatcher's storage context.
 * @dev Upgradeable, extendable.
 */
abstract contract ReflexModule is IReflexModule, ReflexBase {
    // ==========
    // Immutables
    // ==========

    /**
     * @dev Module id.
     */
    uint32 internal immutable _moduleId;

    /**
     * @dev Module type.
     */
    uint16 internal immutable _moduleType;

    /**
     * @dev Module version.
     */
    uint32 internal immutable _moduleVersion;

    /**
     * @dev Whether the module is upgradeable.
     */
    bool internal immutable _moduleUpgradeable;

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
        if (moduleSettings_.moduleId == 0) revert ModuleIdInvalid();
        if (moduleSettings_.moduleType == 0 || moduleSettings_.moduleType > _MODULE_TYPE_INTERNAL)
            revert ModuleTypeInvalid();
        if (moduleSettings_.moduleVersion == 0) revert ModuleVersionInvalid();

        _moduleId = moduleSettings_.moduleId;
        _moduleType = moduleSettings_.moduleType;
        _moduleVersion = moduleSettings_.moduleVersion;
        _moduleUpgradeable = moduleSettings_.moduleUpgradeable;
    }

    // ============
    // View methods
    // ============

    /**
     * @inheritdoc IReflexModule
     */
    function moduleId() public view virtual returns (uint32) {
        return _moduleId;
    }

    /**
     * @inheritdoc IReflexModule
     */
    function moduleType() public view virtual returns (uint16) {
        return _moduleType;
    }

    /**
     * @inheritdoc IReflexModule
     */
    function moduleVersion() public view virtual returns (uint32) {
        return _moduleVersion;
    }

    /**
     * @inheritdoc IReflexModule
     */
    function moduleUpgradeable() public view virtual returns (bool) {
        return _moduleUpgradeable;
    }

    /**
     * @inheritdoc IReflexModule
     */
    function moduleSettings() public view virtual returns (ModuleSettings memory) {
        return
            ModuleSettings({
                moduleId: _moduleId,
                moduleType: _moduleType,
                moduleVersion: _moduleVersion,
                moduleUpgradeable: _moduleUpgradeable
            });
    }
}
