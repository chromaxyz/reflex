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

    error ModuleNonexistent();

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

    event NameChanged(address indexed user_, string name_);

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
 * @title BaseInstaller Interface
 */
interface IBaseInstaller is IBaseModule, TBaseInstaller {

}
