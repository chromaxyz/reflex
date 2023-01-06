// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseInstaller} from "../interfaces/IBaseInstaller.sol";

// Sources
import {BaseModule} from "../BaseModule.sol";

// Upon adding / upgrading / removing check
// Optionally add a versioning system

/**
 * @title Base Installer
 * @dev Upgradeable.
 */
abstract contract BaseInstaller is IBaseInstaller, BaseModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
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
            // TODO: evaluate if it makes sense to optimize the reads here
            // SEE: https://github.com/Chroma-Org/Reflex/tree/feature/packed-module-id

            address moduleAddress = moduleAddresses_[i];
            uint32 moduleId_ = BaseModule(moduleAddress).moduleId();

            if (_modules[moduleId_] != address(0))
                revert ModuleExistent(moduleId_);

            uint16 moduleType_ = BaseModule(moduleAddress).moduleType();
            uint16 moduleVersion_ = BaseModule(moduleAddress).moduleVersion();
            bool moduleUpgradeable_ = BaseModule(moduleAddress)
                .moduleUpgradeable();
            bool moduleRemoveable_ = BaseModule(moduleAddress)
                .moduleRemoveable();

            _modules[moduleId_] = moduleAddress;

            if (moduleType_ == _MODULE_TYPE_SINGLE_PROXY) {
                address proxyAddress = _createProxy(moduleId_, moduleType_);
                _trusts[proxyAddress].moduleImplementation = moduleAddress;
                _trusts[proxyAddress].moduleUpgradeable = moduleUpgradeable_;
                _trusts[proxyAddress].moduleRemoveable = moduleRemoveable_;
            }

            emit ModuleAdded(moduleId_, moduleAddress, moduleVersion_);

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
            uint32 moduleId_ = BaseModule(moduleAddress).moduleId();
            uint16 moduleType_ = BaseModule(moduleAddress).moduleType();
            uint16 moduleVersion_ = BaseModule(moduleAddress).moduleVersion();
            bool moduleUpgradeable_ = BaseModule(moduleAddress)
                .moduleUpgradeable();

            if (_modules[moduleId_] == address(0))
                revert ModuleNonexistent(moduleId_);

            if (!moduleUpgradeable_) revert ModuleNotUpgradeable(moduleId_);
            if (
                moduleVersion_ <=
                BaseModule(_modules[moduleId_]).moduleVersion()
            ) revert ModuleInvalidVersion(moduleId_);

            _modules[moduleId_] = moduleAddress;

            if (moduleType_ == _MODULE_TYPE_SINGLE_PROXY) {
                address proxyAddress = _createProxy(moduleId_, moduleType_);
                _trusts[proxyAddress].moduleImplementation = moduleAddress;
            }

            emit ModuleUpgraded(moduleId_, moduleAddress, moduleVersion_);

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
        // TODO: do not allow user to uninstall `Installer`
        // TODO: should the framework include a built-in whitelist?

        for (uint256 i = 0; i < moduleAddresses_.length; ) {
            address moduleAddress = moduleAddresses_[i];
            uint32 moduleId_ = BaseModule(moduleAddress).moduleId();
            uint16 moduleType_ = BaseModule(moduleAddress).moduleType();
            uint16 moduleVersion_ = BaseModule(moduleAddress).moduleVersion();
            bool moduleRemoveable_ = BaseModule(moduleAddress)
                .moduleRemoveable();

            if (_modules[moduleId_] == address(0))
                revert ModuleNonexistent(moduleId_);

            if (!moduleRemoveable_) revert ModuleNotRemoveable(moduleId_);

            if (moduleType_ == _MODULE_TYPE_SINGLE_PROXY) {
                address proxyAddress = _createProxy(moduleId_, moduleType_);
                delete _trusts[proxyAddress];
            }

            if (
                moduleType_ == _MODULE_TYPE_SINGLE_PROXY ||
                moduleType_ == _MODULE_TYPE_MULTI_PROXY
            ) delete _proxies[moduleId_];

            delete _modules[moduleId_];

            emit ModuleRemoved(moduleId_, moduleAddress, moduleVersion_);

            unchecked {
                ++i;
            }
        }
    }
}
