// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseModule} from "./interfaces/IBaseModule.sol";

// Sources
import {Base} from "./Base.sol";

/**
 * @title Base Module
 * @dev Upgradeable
 */
abstract contract BaseModule is IBaseModule, Base {
    // =======
    // Storage
    // =======

    /**
     * @notice Module id.
     */
    uint32 private immutable _moduleId;

    /**
     * @notice Module version.
     */
    uint16 private immutable _moduleVersion;

    /**
     * @notice Module type.
     */
    uint8 private immutable _moduleType;

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
     * @param moduleId_ Module id.
     * @param moduleVersion_ Module version.
     * @param moduleType_ Module type.
     */
    constructor(uint32 moduleId_, uint16 moduleVersion_, uint8 moduleType_) {
        if (moduleId_ == 0) revert InvalidModuleId();
        if (moduleVersion_ == 0) revert InvalidModuleVersion();
        if (moduleType_ == 0) revert InvalidModuleType();

        _moduleId = moduleId_;
        _moduleVersion = moduleVersion_;
        _moduleType = moduleType_;
    }

    // ==============
    // View functions
    // ==============

    /**
     * @notice Get module id.
     * @return Module id.
     */
    function moduleId() external view virtual override returns (uint32) {
        return _moduleId;
    }

    /**
     * @notice Get module version.
     * @return Module version.
     */
    function moduleVersion() external view virtual override returns (uint16) {
        return _moduleVersion;
    }

    /**
     * @notice Get module type.
     * @return Module type.
     */
    function moduleType() external view virtual override returns (uint8) {
        return _moduleType;
    }
}
