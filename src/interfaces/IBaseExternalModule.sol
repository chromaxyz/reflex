// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @title Base External Module Test Interface
 */
interface TBaseExternalModule {
    // ======
    // Errors
    // ======

    error InvalidModuleId();

    error InvalidModuleType();

    error InvalidModuleVersion();
}

/**
 * @title Base External Module Interface
 */
interface IBaseExternalModule is TBaseExternalModule {
    // =======
    // Structs
    // =======

    /**
     * @notice Module settings.
     * @dev Packed slot: 4 + 2 + 4 + 1 + 1 = 12 bytes out of 32 bytes.
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
        uint32 moduleVersion;
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

    function moduleRemoveable() external view returns (bool);

    function moduleSettings() external view returns (ModuleSettings memory);

    function moduleType() external view returns (uint16);

    function moduleUpgradeable() external view returns (bool);

    function moduleVersion() external view returns (uint32);
}