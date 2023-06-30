// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexState} from "./IReflexState.sol";

/**
 * @title Reflex Module Interface
 */
interface IReflexModule is IReflexState {
    // ======
    // Errors
    // ======

    /**
     * @notice Thrown when error message is empty.
     */
    error EmptyError();

    /**
     * @notice Thrown when endpoint creation code reverts upon creation.
     */
    error EndpointInvalid();

    /**
     * @notice Thrown when the module id is invalid.
     */
    error ModuleIdInvalid(uint32 moduleId);

    /**
     * @notice Thrown when the module type is invalid.
     */
    error ModuleTypeInvalid(uint16 moduleType);

    /**
     * @notice Thrown when an attempt is made to re-enter the protected method.
     */
    error ReadOnlyReentrancy();

    /**
     * @notice Thrown when an attempt is made to re-enter the protected method.
     */
    error Reentrancy();

    /**
     * @notice Thrown when the module version is invalid.
     */
    error ModuleVersionInvalid(uint32 moduleVersion);

    /**
     * @notice Thrown when an unauthorized user attempts to perform an action.
     */
    error Unauthorized();

    /**
     * @notice Thrown when an address passed is address(0) and therefore invalid.
     */
    error ZeroAddress();

    // ======
    // Events
    // ======

    /**
     * @notice Emitted when an endpoint is created.
     * @param moduleId Module id.
     * @param endpointAddress The address of the created endpoint.
     */
    event EndpointCreated(uint32 indexed moduleId, address indexed endpointAddress);

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
