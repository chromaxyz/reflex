// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseInstaller} from "../interfaces/IBaseInstaller.sol";

// Sources
import {BaseModule} from "../BaseModule.sol";

/**
 * @title Base Installer
 * @dev Upgradeable
 */
abstract contract BaseInstaller is IBaseInstaller, BaseModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleType_ Module type.
     * @param moduleVersion_ Module version.
     */
    constructor(
        uint16 moduleType_,
        uint16 moduleVersion_
    ) BaseModule(_MODULE_ID_INSTALLER, moduleType_, moduleVersion_) {}

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
            uint32 moduleId_ = BaseModule(moduleAddress).moduleId();
            uint16 moduleVersion_ = BaseModule(moduleAddress).moduleVersion();

            _modules[moduleId_] = moduleAddress;

            if (moduleId_ <= _EXTERNAL_SINGLE_PROXY_DELIMITER) {
                address proxyAddress = _createProxy(moduleId_);
                _trusts[proxyAddress].moduleImplementation = moduleAddress;
            }

            emit ModuleAdded(moduleId_, moduleAddress, moduleVersion_);

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
            uint32 moduleId_ = BaseModule(moduleAddress).moduleId();
            uint16 moduleVersion_ = BaseModule(moduleAddress).moduleVersion();

            if (_modules[moduleId_] == address(0)) revert ModuleNonexistent();

            _modules[moduleId_] = moduleAddress;

            if (moduleId_ <= _EXTERNAL_SINGLE_PROXY_DELIMITER) {
                address proxyAddress = _createProxy(moduleId_);
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
            uint32 moduleId_ = BaseModule(moduleAddress).moduleId();
            uint16 moduleVersion_ = BaseModule(moduleAddress).moduleVersion();

            if (_modules[moduleId_] == address(0)) revert ModuleNonexistent();

            if (moduleId_ <= _EXTERNAL_SINGLE_PROXY_DELIMITER) {
                address proxyAddress = _createProxy(moduleId_);
                delete _trusts[proxyAddress];
            }

            if (moduleId_ <= _EXTERNAL_MULTI_PROXY_DELIMITER)
                delete _proxies[moduleId_];

            delete _modules[moduleId_];

            emit ModuleRemoved(moduleId_, moduleAddress, moduleVersion_);

            unchecked {
                ++i;
            }
        }
    }
}
