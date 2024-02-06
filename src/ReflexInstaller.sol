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
 * The `Installer` manages the ownership of the Reflex layer and the registration of modules.
 * The owner has the ability to add modules and upgrade existing modules.
 * The transferral of ownership is a two-step process, where the new owner must accept the ownership transfer.
 * The `Installer` is also a module itself with an endpoint and can be upgraded.
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
        return _REFLEX_STORAGE().owner;
    }

    /**
     * @inheritdoc IReflexInstaller
     */
    function pendingOwner() public view virtual returns (address) {
        return _REFLEX_STORAGE().pendingOwner;
    }

    // ====================
    // Permissioned methods
    // ====================

    /**
     * @inheritdoc IReflexInstaller
     */
    function transferOwnership(address newOwner_) public virtual onlyOwner nonReentrant {
        if (newOwner_ == address(0)) revert ZeroAddress();

        _REFLEX_STORAGE().pendingOwner = newOwner_;

        emit OwnershipTransferStarted(_REFLEX_STORAGE().owner, newOwner_);
    }

    /**
     * @inheritdoc IReflexInstaller
     */
    function acceptOwnership() public virtual nonReentrant {
        address newOwner = _unpackMessageSender();

        if (newOwner != _REFLEX_STORAGE().pendingOwner) revert Unauthorized();

        delete _REFLEX_STORAGE().pendingOwner;

        address previousOwner = _REFLEX_STORAGE().owner;
        _REFLEX_STORAGE().owner = newOwner;

        emit OwnershipTransferred(previousOwner, newOwner);
    }

    /**
     * @inheritdoc IReflexInstaller
     */
    function renounceOwnership() public virtual onlyOwner nonReentrant {
        address newOwner = address(0);

        delete _REFLEX_STORAGE().pendingOwner;

        address previousOwner = _REFLEX_STORAGE().owner;
        _REFLEX_STORAGE().owner = newOwner;

        emit OwnershipTransferred(previousOwner, newOwner);
    }

    /**
     * @inheritdoc IReflexInstaller
     */
    function addModules(address[] calldata moduleImplementations_) public virtual onlyOwner nonReentrant {
        uint256 moduleImplementationsLength = moduleImplementations_.length;

        for (uint256 i = 0; i < moduleImplementationsLength; ) {
            address moduleImplementation_ = moduleImplementations_[i];

            IReflexModule.ModuleSettings memory moduleSettings_ = IReflexModule(moduleImplementation_).moduleSettings();

            uint32 moduleId_ = moduleSettings_.moduleId;

            // Verify that the module to add does not exist and is yet to be registered.
            if (_REFLEX_STORAGE().modules[moduleId_] != address(0)) revert ModuleAlreadyRegistered();

            // Call pre-registration hook.
            _beforeModuleRegistration(moduleSettings_, moduleImplementation_);

            // Register the module implementation in the module mapping.
            // This is done for all module types.
            _REFLEX_STORAGE().modules[moduleId_] = moduleImplementation_;

            // Create and register the endpoint for the module and register in the endpoint mapping.
            // This is only done for single-module endpoints.
            if (moduleSettings_.moduleType == _MODULE_TYPE_SINGLE_ENDPOINT)
                _createEndpoint(moduleId_, moduleSettings_.moduleType, moduleImplementation_);

            emit ModuleAdded(moduleId_, moduleImplementation_);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @inheritdoc IReflexInstaller
     */
    function upgradeModules(address[] calldata moduleImplementations_) public virtual onlyOwner nonReentrant {
        uint256 moduleImplementationsLength = moduleImplementations_.length;

        for (uint256 i = 0; i < moduleImplementationsLength; ) {
            address moduleImplementation_ = moduleImplementations_[i];

            IReflexModule.ModuleSettings memory moduleSettings_ = IReflexModule(moduleImplementation_).moduleSettings();

            uint32 moduleId_ = moduleSettings_.moduleId;

            // Verify that the module exists and is registered.
            if (_REFLEX_STORAGE().modules[moduleId_] == address(0)) revert ModuleNotRegistered();

            // Verify that the next module type is the same as the current module type.
            if (moduleSettings_.moduleType != IReflexModule(_REFLEX_STORAGE().modules[moduleId_]).moduleType())
                revert ModuleTypeInvalid();

            // Call pre-registration hook.
            _beforeModuleRegistration(moduleSettings_, moduleImplementation_);

            // Update the module implementation of the module in the modules mapping.
            _REFLEX_STORAGE().modules[moduleId_] = moduleImplementation_;

            // Update the module implementation of the module in the endpoint mapping.
            if (moduleSettings_.moduleType == _MODULE_TYPE_SINGLE_ENDPOINT)
                _REFLEX_STORAGE()
                    .relations[_REFLEX_STORAGE().endpoints[moduleId_]]
                    .moduleImplementation = moduleImplementation_;

            emit ModuleUpgraded(moduleId_, moduleImplementation_);

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
     * @param moduleImplementation_ Module implementation.
     */
    function _beforeModuleRegistration(
        IReflexModule.ModuleSettings memory moduleSettings_,
        address moduleImplementation_
    ) internal virtual {}
}
