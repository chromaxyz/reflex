// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "./IReflexModule.sol";

/**
 * @title Reflex Installer Interface
 */
interface IReflexInstaller is IReflexModule {
    // ======
    // Errors
    // ======

    /**
     * @notice Thrown when the module already has been registered.
     */
    error ModuleExistent(uint32 moduleId);

    /**
     * @notice Thrown when the module has not been registered yet.
     */
    error ModuleNonexistent(uint32 moduleId);

    /**
     * @notice Thrown when the module is attempted to be upgraded but is not upgradeable.
     */
    error ModuleNotUpgradeable(uint32 moduleId);

    // ======
    // Events
    // ======

    /**
     * @notice Emitted when a module is added.
     * @param moduleId Module id.
     * @param moduleImplementation Module implementation.
     * @param moduleVersion Module version.
     */
    event ModuleAdded(uint32 indexed moduleId, address indexed moduleImplementation, uint32 moduleVersion);

    /**
     * @notice Emitted when a module is upgraded.
     * @param moduleId Module id.
     * @param moduleImplementation Module implementation.
     * @param moduleVersion Module version.
     */
    event ModuleUpgraded(uint32 indexed moduleId, address indexed moduleImplementation, uint32 moduleVersion);

    /**
     * @notice Emitted when the ownership transfer process is started.
     * @param previousOwner The previous owner who triggered the change.
     * @param newOwner The new owner who was granted the ownership.
     */
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    /**
     * @notice Emitted when the ownership is transferred.
     * @param previousOwner The previous owner who triggered the change.
     * @param newOwner The new owner who was granted the ownership.
     */
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // =======
    // Methods
    // =======

    /**
     * @notice Returns the address of the owner.
     * @return address Owner address.
     */
    function owner() external view returns (address);

    /**
     * @notice Returns the address of the pending owner.
     * @return address Pending owner address.
     */
    function pendingOwner() external view returns (address);

    /**
     * @notice Transfer ownership in two steps.
     * @param newOwner_ New pending owner.
     *
     * Requirements:
     *
     * - The caller must be the current owner.
     * - Cannot be re-entered.
     */
    function transferOwnership(address newOwner_) external;

    /**
     * @notice Accept ownership.
     *
     * Requirements:
     *
     * - The caller must be the pending owner.
     * - Cannot be re-entered.
     */
    function acceptOwnership() external;

    /**
     * @notice Renounce ownership.
     *
     * Requirements:
     *
     * - The caller must be the owner.
     * - Cannot be re-entered.
     *
     * NOTE: Renouncing ownership will leave Reflex without an owner,
     * thereby removing any functionality that is only available to the owner.
     * It will not be possible to call methods with the `onlyOwner` modifier anymore.
     */
    function renounceOwnership() external;

    /**
     * @notice Add modules.
     * @param moduleAddresses_ List of modules to add.
     *
     * Requirements:
     *
     * - The caller must be the current owner.
     * - Cannot be re-entered.
     */
    function addModules(address[] memory moduleAddresses_) external;

    /**
     * @notice Upgrade modules
     * @param moduleAddresses_ List of modules to upgrade.
     *
     * Requirements:
     *
     * - The caller must be the current owner.
     * - Cannot be re-entered.
     */
    function upgradeModules(address[] memory moduleAddresses_) external;
}
