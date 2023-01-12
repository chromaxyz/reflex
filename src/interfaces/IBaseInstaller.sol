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

    error ZeroAddress();

    error ModuleInvalidVersion(uint32 moduleId_);

    error ModuleExistent(uint32 moduleId_);

    error ModuleNonexistent(uint32 moduleId_);

    error ModuleNotUpgradeable(uint32 moduleId_);

    error ModuleNotRemoveable(uint32 moduleId_);

    // ======
    // Events
    // ======

    event ModuleAllowlisted(
        uint32 indexed moduleId_,
        address indexed moduleImplementation_,
        uint16 indexed moduleVersion_
    );

    event ModuleDenylisted(
        uint32 indexed moduleId_,
        address indexed moduleImplementation_,
        uint16 indexed moduleVersion_
    );

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

    event OwnershipTransferred(
        address indexed user_,
        address indexed newOwner_
    );

    event OwnershipTransferStarted(
        address indexed previousOwner_,
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
}
