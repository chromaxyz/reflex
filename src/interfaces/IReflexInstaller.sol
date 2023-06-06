// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule, TReflexModule} from "./IReflexModule.sol";

/**
 * @title Reflex Installer Test Interface
 */
interface TReflexInstaller is TReflexModule {
    // ======
    // Errors
    // ======

    error EndpointInvalid();

    error ModuleExistent(uint32 moduleId);

    error ModuleInvalidVersion(uint32 moduleId);

    error ModuleInvalidType(uint32 moduleId);

    error ModuleNonexistent(uint32 moduleId);

    error ModuleNotUpgradeable(uint32 moduleId);

    error ZeroAddress();

    // ======
    // Events
    // ======

    event ModuleAdded(uint32 indexed moduleId, address indexed moduleImplementation, uint32 indexed moduleVersion);

    event ModuleUpgraded(uint32 indexed moduleId, address indexed moduleImplementation, uint32 indexed moduleVersion);

    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
}

/**
 * @title Reflex Installer Interface
 */
interface IReflexInstaller is IReflexModule, TReflexInstaller {
    // =======
    // Methods
    // =======

    function acceptOwnership() external;

    function addModules(address[] memory moduleAddresses_) external;

    function owner() external view returns (address);

    function pendingOwner() external view returns (address);

    function renounceOwnership() external;

    function transferOwnership(address newOwner_) external;

    function upgradeModules(address[] memory moduleAddresses_) external;
}
