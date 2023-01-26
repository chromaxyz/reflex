// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IReflexInstaller} from "./interfaces/IReflexInstaller.sol";
import {IReflexModule} from "./interfaces/IReflexModule.sol";

// Sources
import {ReflexModule} from "./ReflexModule.sol";

/**
 * @title Reflex Installer
 * @dev Execution takes place within the Dispatcher's storage context.
 * @dev Upgradeable, extendable.
 */
abstract contract ReflexInstaller is IReflexInstaller, ReflexModule {
    // ============
    // View methods
    // ============

    /**
     * @notice Returns the address of the owner.
     */
    function owner() external view virtual override returns (address) {
        return _owner;
    }

    /**
     * @notice Returns the address of the pending owner.
     */
    function pendingOwner() external view virtual override returns (address) {
        return _pendingOwner;
    }

    // ====================
    // Permissioned methods
    // ====================

    /**
     * @notice Transfer ownership in two steps.
     * @param newOwner_ New pending owner.
     *
     * Requirements:
     *
     * - The caller must be the current owner.
     */
    function transferOwnership(address newOwner_) external virtual override onlyOwner nonReentrant {
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
    function acceptOwnership() external virtual override nonReentrant {
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
     * - Cannot be re-entered.
     */
    function addModules(address[] memory moduleAddresses_) external virtual override onlyOwner nonReentrant {
        uint256 moduleAddressLength = moduleAddresses_.length;

        for (uint256 i = 0; i < moduleAddressLength; ) {
            address moduleAddress = moduleAddresses_[i];

            IReflexModule.ModuleSettings memory moduleSettings_ = IReflexModule(moduleAddress).moduleSettings();

            if (_modules[moduleSettings_.moduleId] != address(0)) revert ModuleExistent(moduleSettings_.moduleId);

            _modules[moduleSettings_.moduleId] = moduleAddress;

            if (moduleSettings_.moduleType == _MODULE_TYPE_SINGLE_PROXY) {
                address proxyAddress = _createProxy(moduleSettings_.moduleId, moduleSettings_.moduleType);
                _relations[proxyAddress].moduleImplementation = moduleAddress;
            }

            emit ModuleAdded(moduleSettings_.moduleId, moduleAddress, moduleSettings_.moduleVersion);

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
     * - Cannot be re-entered.
     */
    function upgradeModules(address[] memory moduleAddresses_) external virtual override onlyOwner nonReentrant {
        uint256 moduleAddressLength = moduleAddresses_.length;

        for (uint256 i = 0; i < moduleAddressLength; ) {
            address moduleAddress = moduleAddresses_[i];

            // Check against existing module

            IReflexModule.ModuleSettings memory moduleSettings_ = IReflexModule(moduleAddress).moduleSettings();

            // Verify that the module currently exists.
            if (_modules[moduleSettings_.moduleId] == address(0)) revert ModuleNonexistent(moduleSettings_.moduleId);

            // Verify that current module allows for upgrades.
            if (!IReflexModule(_modules[moduleSettings_.moduleId]).moduleUpgradeable())
                revert ModuleNotUpgradeable(moduleSettings_.moduleId);

            // Verify that the next module version is greater than the current module version.
            if (moduleSettings_.moduleVersion <= IReflexModule(_modules[moduleSettings_.moduleId]).moduleVersion())
                revert ModuleInvalidVersion(moduleSettings_.moduleId);

            _modules[moduleSettings_.moduleId] = moduleAddress;

            if (moduleSettings_.moduleType == _MODULE_TYPE_SINGLE_PROXY) {
                address proxyAddress = _createProxy(moduleSettings_.moduleId, moduleSettings_.moduleType);
                _relations[proxyAddress].moduleImplementation = moduleAddress;
            }

            emit ModuleUpgraded(moduleSettings_.moduleId, moduleAddress, moduleSettings_.moduleVersion);

            unchecked {
                ++i;
            }
        }
    }
}
