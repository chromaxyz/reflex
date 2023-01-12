// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseModule, IBaseModule} from "./IBaseModule.sol";

/**
 * @title Base Installer Test Interface
 */
interface TBaseInstaller is TBaseModule {
    // ======
    // Errors
    // ======

    error ModuleExistent(uint32 moduleId_);

    error ModuleInvalidVersion(uint32 moduleId_);

    error ModuleNonexistent(uint32 moduleId_);

    error ModuleNotRemoveable(uint32 moduleId_);

    error ModuleNotUpgradeable(uint32 moduleId_);

    error ZeroAddress();

    // ======
    // Events
    // ======

    event ModuleAdded(
        uint32 indexed moduleId_,
        address indexed moduleImplementation_,
        uint16 indexed moduleVersion_
    );

    event ModuleUpgraded(
        uint32 indexed moduleId_,
        address indexed moduleImplementation_,
        uint16 indexed moduleVersion_
    );

    event ModuleRemoved(
        uint32 indexed moduleId_,
        address indexed moduleImplementation_,
        uint16 indexed moduleVersion_
    );

    event OwnershipTransferStarted(
        address indexed previousOwner_,
        address indexed newOwner_
    );

    event OwnershipTransferred(
        address indexed user_,
        address indexed newOwner_
    );
}

/**
 * @title Base Installer Interface
 */
interface IBaseInstaller is IBaseModule, TBaseInstaller {
    // =======
    // Methods
    // =======

    function acceptOwnership() external;

    function addModules(address[] memory moduleAddresses_) external;

    function owner() external view returns (address);

    function pendingOwner() external view returns (address);

    function removeModules(address[] memory moduleAddresses_) external;

    function transferOwnership(address newOwner_) external;

    function upgradeModules(address[] memory moduleAddresses_) external;
}
