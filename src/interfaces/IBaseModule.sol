// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBase, IBase} from "./IBase.sol";

/**
 * @title Base Installer Test Interface
 */
interface TBaseModule is TBase {
    // ======
    // Errors
    // ======

    error FailedToLog();

    error InvalidModuleVersion();

    error Unauthorized();
}

/**
 * @title Base Module Interface
 */
interface IBaseModule is IBase, TBaseModule {
    // =======
    // Structs
    // =======

    /**
     * @notice Module settings.
     */
    struct ModuleSettings {
        /**
         * @notice Module id.
         */
        uint32 moduleId;
        /**
         * @notice Module type.
         */
        uint16 moduleType;
        /**
         * @notice Module version.
         */
        uint16 moduleVersion;
        /**
         * @notice Whether the module is upgradeable.
         */
        bool moduleUpgradeable;
        /**
         * @notice Whether the module is removeable.
         */
        bool moduleRemoveable;
    }

    // =======
    // Methods
    // =======

    function moduleId() external view returns (uint32);

    function moduleType() external view returns (uint16);

    function moduleVersion() external view returns (uint16);

    function moduleUpgradeable() external view returns (bool);

    function moduleRemoveable() external view returns (bool);
}
