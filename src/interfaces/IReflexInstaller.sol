// SPDX-License-Identifier: AGPL-3.0-only
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

    error ModuleExistent(uint256 moduleId_);

    error ModuleInvalidVersion(uint256 moduleId_);

    error ModuleNonexistent(uint256 moduleId_);

    error ModuleNotUpgradeable(uint256 moduleId_);

    error ZeroAddress();

    // ======
    // Events
    // ======

    event ModuleAdded(uint256 indexed moduleId_, address indexed moduleImplementation_, uint256 indexed moduleVersion_);

    event ModuleUpgraded(
        uint256 indexed moduleId_,
        address indexed moduleImplementation_,
        uint256 indexed moduleVersion_
    );

    event OwnershipTransferStarted(address indexed previousOwner_, address indexed newOwner_);

    event OwnershipTransferred(address indexed previousOwner_, address indexed newOwner_);
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

    function transferOwnership(address newOwner_) external;

    function upgradeModules(address[] memory moduleAddresses_) external;
}
