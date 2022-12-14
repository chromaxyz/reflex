// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseModule} from "./interfaces/IBaseModule.sol";

// Internals
import {Base} from "./internals/Base.sol";

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
     * @notice Module type.
     */
    uint16 private immutable _moduleType;

    /**
     * @notice Module version.
     */
    uint16 private immutable _moduleVersion;

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
     * @param moduleType_ Module type.
     * @param moduleVersion_ Module version.
     */
    constructor(uint32 moduleId_, uint16 moduleType_, uint16 moduleVersion_) {
        if (moduleId_ == 0) revert InvalidModuleId();
        if (moduleType_ == 0 || moduleType_ > 3) revert InvalidModuleType();
        if (moduleVersion_ == 0) revert InvalidModuleVersion();

        _moduleId = moduleId_;
        _moduleType = moduleType_;
        _moduleVersion = moduleVersion_;
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
    function moduleType() external view virtual override returns (uint16) {
        return _moduleType;
    }

    /**
     * @notice Get module version.
     * @return Module version.
     */
    function moduleVersion() external view virtual override returns (uint16) {
        return _moduleVersion;
    }
}
