// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBase} from "./IReflexBase.sol";

/**
 * @title Reflex Module Interface
 */
interface IReflexModule is IReflexBase {
    // ======
    // Errors
    // ======

    /**
     * @notice Thrown when the module version is invalid.
     */
    error ModuleVersionInvalid();

    /**
     * @notice Thrown when an unauthorized user attempts to perform an action.
     */
    error Unauthorized();

    /**
     * @notice Thrown when an address passed is address(0) and therefore invalid.
     */
    error ZeroAddress();

    // =======
    // Structs
    // =======

    /**
     * @notice Module settings.
     *
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
    }

    // =======
    // Methods
    // =======

    /**
     * @notice Get module id.
     * @return uint32 Module id.
     */
    function moduleId() external view returns (uint32);

    /**
     * @notice Get module type.
     * @return uint16 Module type.
     */
    function moduleType() external view returns (uint16);

    /**
     * @notice Get module type.
     * @return uint16 Module type.
     */
    function moduleVersion() external view returns (uint32);

    /**
     * @notice Get whether module is upgradeable.
     * @return bool Whether module is upgradeable.
     */
    function moduleUpgradeable() external view returns (bool);

    /**
     * @notice Get the module settings.
     * @return ModuleSettings Module settings.
     */
    function moduleSettings() external view returns (ModuleSettings memory);
}
