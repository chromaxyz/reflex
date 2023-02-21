// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexInstaller} from "./interfaces/IReflexInstaller.sol";
import {IReflexModule} from "./interfaces/IReflexModule.sol";

// Sources
import {ReflexModule} from "./ReflexModule.sol";

/**
 * @title Reflex Installer
 *
 * @dev Execution takes place within the Dispatcher's storage context.
 * @dev Upgradeable, extendable.
 */
abstract contract ReflexInstaller is IReflexInstaller, ReflexModule {
    // ============
    // View methods
    // ============

    /**
     * @notice Returns the address of the owner.
     * @return address Owner address.
     */
    function owner() external view virtual returns (address) {
        return _owner;
    }

    /**
     * @notice Returns the address of the pending owner.
     * @return address Pending owner address.
     */
    function pendingOwner() external view virtual returns (address) {
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
     * - Cannot be re-entered.
     */
    function transferOwnership(address newOwner_) external virtual onlyOwner nonReentrant {
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
     * - Cannot be re-entered.
     */
    function acceptOwnership() external virtual nonReentrant {
        address newOwner = _unpackMessageSender();

        if (newOwner != _pendingOwner) revert Unauthorized();

        delete _pendingOwner;

        address previousOwner = _owner;
        _owner = newOwner;

        emit OwnershipTransferred(previousOwner, newOwner);
    }

    /**
     * @notice Renounce ownership.
     *
     * Requirements:
     *
     * - The caller must be the owner.
     * - Cannot be re-entered.
     *
     * NOTE: Renouncing ownership will leave Reflex without an owner,
     * thereby removing any functionality that is only available to the owner.
     * It will not be possible to call methods with the `onlyOwner` modifier anymore.
     */
    function renounceOwnership() external virtual onlyOwner nonReentrant {
        address newOwner = address(0);

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
    function addModules(address[] calldata moduleAddresses_) external virtual onlyOwner nonReentrant {
        uint256 moduleAddressLength = moduleAddresses_.length;

        for (uint256 i = 0; i < moduleAddressLength; ) {
            address moduleAddress = moduleAddresses_[i];

            IReflexModule.ModuleSettings memory moduleSettings_ = IReflexModule(moduleAddress).moduleSettings();

            // Verify that the module to add does not exist and is yet to be registered.
            if (_modules[moduleSettings_.moduleId] != address(0)) revert ModuleExistent(moduleSettings_.moduleId);

            // Register the module.
            _modules[moduleSettings_.moduleId] = moduleAddress;

            // Create and register the endpoint for the module.
            if (moduleSettings_.moduleType == _MODULE_TYPE_SINGLE_ENDPOINT)
                _createEndpoint(moduleSettings_.moduleId, moduleSettings_.moduleType, moduleAddress);

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
    function upgradeModules(address[] calldata moduleAddresses_) external virtual onlyOwner nonReentrant {
        uint256 moduleAddressLength = moduleAddresses_.length;

        for (uint256 i = 0; i < moduleAddressLength; ) {
            address moduleAddress = moduleAddresses_[i];

            IReflexModule.ModuleSettings memory moduleSettings_ = IReflexModule(moduleAddress).moduleSettings();

            // Verify that the module to upgrade exists and is registered.
            if (_modules[moduleSettings_.moduleId] == address(0)) revert ModuleNonexistent(moduleSettings_.moduleId);

            // Verify that current module allows for upgrades.
            if (!IReflexModule(_modules[moduleSettings_.moduleId]).moduleUpgradeable())
                revert ModuleNotUpgradeable(moduleSettings_.moduleId);

            // Verify that the next module version is greater than the current module version.
            if (moduleSettings_.moduleVersion <= IReflexModule(_modules[moduleSettings_.moduleId]).moduleVersion())
                revert ModuleInvalidVersion(moduleSettings_.moduleId);

            // Verify that the next module type is the same as the current module type.
            if (moduleSettings_.moduleType != IReflexModule(_modules[moduleSettings_.moduleId]).moduleType())
                revert ModuleInvalidType(moduleSettings_.moduleId);

            // Register the module.
            _modules[moduleSettings_.moduleId] = moduleAddress;

            // Update the module implementation of the module endpoint.
            if (moduleSettings_.moduleType == _MODULE_TYPE_SINGLE_ENDPOINT)
                _relations[_endpoints[moduleSettings_.moduleId]].moduleImplementation = moduleAddress;

            emit ModuleUpgraded(moduleSettings_.moduleId, moduleAddress, moduleSettings_.moduleVersion);

            unchecked {
                ++i;
            }
        }
    }
}
