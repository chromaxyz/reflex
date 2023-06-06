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
     * @inheritdoc IReflexInstaller
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @inheritdoc IReflexInstaller
     */
    function pendingOwner() public view virtual returns (address) {
        return _pendingOwner;
    }

    // ====================
    // Permissioned methods
    // ====================

    /**
     * @inheritdoc IReflexInstaller
     */
    function transferOwnership(address newOwner_) public virtual onlyOwner nonReentrant {
        if (newOwner_ == address(0)) revert ZeroAddress();

        _pendingOwner = newOwner_;

        emit OwnershipTransferStarted(_owner, newOwner_);
    }

    /**
     * @inheritdoc IReflexInstaller
     */
    function acceptOwnership() public virtual nonReentrant {
        address newOwner = _unpackMessageSender();

        if (newOwner != _pendingOwner) revert Unauthorized();

        delete _pendingOwner;

        address previousOwner = _owner;
        _owner = newOwner;

        emit OwnershipTransferred(previousOwner, newOwner);
    }

    /**
     * @inheritdoc IReflexInstaller
     */
    function renounceOwnership() public virtual onlyOwner nonReentrant {
        address newOwner = address(0);

        delete _pendingOwner;

        address previousOwner = _owner;
        _owner = newOwner;

        emit OwnershipTransferred(previousOwner, newOwner);
    }

    /**
     * @inheritdoc IReflexInstaller
     */
    function addModules(address[] calldata moduleAddresses_) public virtual onlyOwner nonReentrant {
        uint256 moduleAddressLength = moduleAddresses_.length;

        for (uint256 i = 0; i < moduleAddressLength; ) {
            address moduleAddress = moduleAddresses_[i];

            IReflexModule.ModuleSettings memory moduleSettings_ = IReflexModule(moduleAddress).moduleSettings();

            // Verify that the module to add does not exist and is yet to be registered.
            if (_modules[moduleSettings_.moduleId] != address(0)) revert ModuleExistent(moduleSettings_.moduleId);

            // Call pre-registration hook.
            _beforeModuleRegistration(moduleSettings_, moduleAddress);

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
     * @inheritdoc IReflexInstaller
     */
    function upgradeModules(address[] calldata moduleAddresses_) public virtual onlyOwner nonReentrant {
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

            // Call pre-registration hook.
            _beforeModuleRegistration(moduleSettings_, moduleAddress);

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

    // ============
    // Hook methods
    // ============

    /**
     * @notice Hook that is called before a module is registered.
     * @param moduleSettings_ Module settings.
     * @param moduleAddress_ Module address.
     */
    function _beforeModuleRegistration(
        IReflexModule.ModuleSettings memory moduleSettings_,
        address moduleAddress_
    ) internal virtual {}
}
