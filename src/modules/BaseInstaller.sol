// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

// Interfaces
import {IBaseInstaller} from "../interfaces/IBaseInstaller.sol";
import {IBaseModule} from "../interfaces/IBaseModule.sol";

// Sources
import {BaseModule} from "../BaseModule.sol";

/**
 * @title Base Installer
 * @dev Upgradeable.
 */
abstract contract BaseInstaller is IBaseInstaller, BaseModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module moduleSettings.
     */
    constructor(
        ModuleSettings memory moduleSettings_
    ) BaseModule(moduleSettings_) {}

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
     * @param newOwner_ New pending owner.
     *
     * Requirements:
     *
     * - The caller must be the current owner.
     */
    function transferOwnership(address newOwner_) external virtual onlyOwner {
        if (newOwner_ == address(0)) revert ZeroAddress();

        _pendingOwner = newOwner_;

        emit OwnershipTransferStarted(_owner, newOwner_);
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
     * @param moduleAddresses_ List of modules to add.
     *
     * Requirements:
     *
     * - The caller must be the current owner.
     */
    function addModules(
        address[] memory moduleAddresses_
    ) external virtual onlyOwner nonReentrant {
        for (uint256 i = 0; i < moduleAddresses_.length; ) {
            address moduleAddress = moduleAddresses_[i];

            IBaseModule.ModuleSettings memory moduleSettings = BaseModule(
                moduleAddress
            ).moduleSettings();

            if (_modules[moduleSettings.moduleId] != address(0))
                revert ModuleExistent(moduleSettings.moduleId);

            _modules[moduleSettings.moduleId] = moduleAddress;

            if (moduleSettings.moduleType == _MODULE_TYPE_SINGLE_PROXY) {
                address proxyAddress = _createProxy(
                    moduleSettings.moduleId,
                    moduleSettings.moduleType
                );
                _trusts[proxyAddress].moduleImplementation = moduleAddress;
            }

            emit ModuleAdded(
                moduleSettings.moduleId,
                moduleAddress,
                moduleSettings.moduleVersion
            );

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Upgrade modules
     * @param moduleAddresses_ List of modules to upgrade.
     *
     * Requirements:
     *
     * - The caller must be the current owner.
     */
    function upgradeModules(
        address[] memory moduleAddresses_
    ) external virtual onlyOwner nonReentrant {
        for (uint256 i = 0; i < moduleAddresses_.length; ) {
            address moduleAddress = moduleAddresses_[i];

            // Check against existing module

            IBaseModule.ModuleSettings memory moduleSettings = BaseModule(
                moduleAddress
            ).moduleSettings();

            // Verify that the module currently exists.
            if (_modules[moduleSettings.moduleId] == address(0))
                revert ModuleNonexistent(moduleSettings.moduleId);

            // Verify that current module allows for upgrades.
            if (
                !IBaseModule(_modules[moduleSettings.moduleId])
                    .moduleUpgradeable()
            ) revert ModuleNotUpgradeable(moduleSettings.moduleId);

            // Verify that the next module version is greater than the current module version.
            if (
                moduleSettings.moduleVersion <=
                IBaseModule(_modules[moduleSettings.moduleId]).moduleVersion()
            ) revert ModuleInvalidVersion(moduleSettings.moduleId);

            _modules[moduleSettings.moduleId] = moduleAddress;

            if (moduleSettings.moduleType == _MODULE_TYPE_SINGLE_PROXY) {
                address proxyAddress = _createProxy(
                    moduleSettings.moduleId,
                    moduleSettings.moduleType
                );
                _trusts[proxyAddress].moduleImplementation = moduleAddress;
            }

            emit ModuleUpgraded(
                moduleSettings.moduleId,
                moduleAddress,
                moduleSettings.moduleVersion
            );

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Remove modules
     * @param moduleAddresses_ List of modules to remove.
     *
     * Requirements:
     *
     * - The caller must be the current owner.
     */
    function removeModules(
        address[] memory moduleAddresses_
    ) external virtual onlyOwner nonReentrant {
        for (uint256 i = 0; i < moduleAddresses_.length; ) {
            address moduleAddress = moduleAddresses_[i];

            IBaseModule.ModuleSettings memory moduleSettings = BaseModule(
                moduleAddress
            ).moduleSettings();

            if (_modules[moduleSettings.moduleId] == address(0))
                revert ModuleNonexistent(moduleSettings.moduleId);

            if (!moduleSettings.moduleRemoveable)
                revert ModuleNotRemoveable(moduleSettings.moduleId);

            if (moduleSettings.moduleType == _MODULE_TYPE_SINGLE_PROXY) {
                address proxyAddress = _createProxy(
                    moduleSettings.moduleId,
                    moduleSettings.moduleType
                );
                delete _trusts[proxyAddress];
            }

            if (
                moduleSettings.moduleType == _MODULE_TYPE_SINGLE_PROXY ||
                moduleSettings.moduleType == _MODULE_TYPE_MULTI_PROXY
            ) delete _proxies[moduleSettings.moduleId];

            delete _modules[moduleSettings.moduleId];

            emit ModuleRemoved(
                moduleSettings.moduleId,
                moduleAddress,
                moduleSettings.moduleVersion
            );

            unchecked {
                ++i;
            }
        }
    }
}
