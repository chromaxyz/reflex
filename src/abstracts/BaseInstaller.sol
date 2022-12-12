// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Abstracts
import {BaseModule} from "./BaseModule.sol";

// Interfaces
import {IBaseInstaller} from "../interfaces/IBaseInstaller.sol";

/**
 * @title Base Installer
 * @dev Upgradeable
 */
abstract contract BaseInstaller is IBaseInstaller, BaseModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleVersion_ Module version.
     */
    constructor(
        uint16 moduleVersion_
    ) BaseModule(_MODULE_ID_INSTALLER, moduleVersion_) {}

    // ==============
    // View functions
    // ==============

    /**
     * @notice Returns the address of the owner.
     */
    function owner() external view virtual returns (address) {
        return _owner;
    }

    /**
     * @notice Returns the address of the pending owner.
     */
    function pendingOwner() external view virtual returns (address) {
        return _pendingOwner;
    }

    // ======================
    // Permissioned functions
    // ======================

    /**
     * @notice Transfer ownership in two steps.
     * @param newOwner New pending owner.
     *
     * Requirements:
     *
     * - The caller must be the current owner.
     */
    function transferOwnership(address newOwner) external virtual onlyOwner {
        if (newOwner == address(0)) revert ZeroAddress();

        _pendingOwner = newOwner;

        emit OwnershipTransferStarted(_owner, newOwner);
    }

    /**
     * @notice Accept ownership.
     *
     * Requirements:
     *
     * - The caller must be the pending owner.
     */
    function acceptOwnership() external virtual {
        address newOwner = _unpackMessageSender();

        if (newOwner != _pendingOwner) revert Unauthorized();

        delete _pendingOwner;

        address previousOwner = _owner;
        _owner = newOwner;

        emit OwnershipTransferred(previousOwner, newOwner);
    }

    /**
     * @notice Add modules.
     * @param moduleAddresses List of modules to add.
     *
     * Requirements:
     *
     * - The caller must be the current owner.
     */
    function addModules(
        address[] memory moduleAddresses
    ) external virtual onlyOwner {
        for (uint256 i = 0; i < moduleAddresses.length; ) {
            address moduleAddress = moduleAddresses[i];
            uint32 newModuleId = BaseModule(moduleAddress).moduleId();
            uint16 newModuleVersion = BaseModule(moduleAddress).moduleVersion();

            _modules[newModuleId] = moduleAddress;

            if (newModuleId <= _EXTERNAL_SINGLE_PROXY_DELIMITER) {
                address proxyAddress = _createProxy(newModuleId);
                _trusts[proxyAddress].moduleImplementation = moduleAddress;
            }

            emit ModuleAdded(newModuleId, moduleAddress, newModuleVersion);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Upgrade modules
     * @param moduleAddresses List of modules to upgrade.
     *
     * Requirements:
     *
     * - The caller must be the current owner.
     */
    function upgradeModules(
        address[] memory moduleAddresses
    ) external virtual onlyOwner {
        for (uint256 i = 0; i < moduleAddresses.length; ) {
            address moduleAddress = moduleAddresses[i];
            uint32 existingModuleId = BaseModule(moduleAddress).moduleId();
            uint16 existingModuleVersion = BaseModule(moduleAddress)
                .moduleVersion();

            if (_modules[existingModuleId] == address(0))
                revert ModuleNonexistent();

            _modules[existingModuleId] = moduleAddress;

            if (existingModuleId <= _EXTERNAL_SINGLE_PROXY_DELIMITER) {
                address proxyAddress = _createProxy(existingModuleId);
                _trusts[proxyAddress].moduleImplementation = moduleAddress;
            }

            emit ModuleUpgraded(
                existingModuleId,
                moduleAddress,
                existingModuleVersion
            );

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Remove modules
     * @param moduleAddresses List of modules to remove.
     *
     * Requirements:
     *
     * - The caller must be the current owner.
     */
    function removeModules(
        address[] memory moduleAddresses
    ) external virtual onlyOwner {
        for (uint256 i = 0; i < moduleAddresses.length; ) {
            address moduleAddress = moduleAddresses[i];
            uint32 existingModuleId = BaseModule(moduleAddress).moduleId();
            uint16 existingModuleVersion = BaseModule(moduleAddress)
                .moduleVersion();

            if (_modules[existingModuleId] == address(0))
                revert ModuleNonexistent();

            if (existingModuleId <= _EXTERNAL_SINGLE_PROXY_DELIMITER) {
                address proxyAddress = _createProxy(existingModuleId);
                delete _trusts[proxyAddress];
            }

            if (existingModuleId <= _EXTERNAL_MULTI_PROXY_DELIMITER)
                delete _proxies[existingModuleId];

            delete _modules[existingModuleId];

            emit ModuleRemoved(
                existingModuleId,
                moduleAddress,
                existingModuleVersion
            );

            unchecked {
                ++i;
            }
        }
    }
}
