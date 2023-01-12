// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseDispatcher} from "./interfaces/IBaseDispatcher.sol";
import {IBaseInstaller} from "./interfaces/IBaseInstaller.sol";

// Internals
import {Base} from "./internals/Base.sol";

/**
 * @title Base Dispatcher
 * @dev Non-upgradeable.
 */
abstract contract BaseDispatcher is IBaseDispatcher, Base {
    // ===========
    // Constructor
    // ===========

    /**
     * @param owner_ Protocol owner.
     * @param installerModule_ Installer module address.
     */
    constructor(address owner_, address installerModule_) {
        _reentrancyLock = _REENTRANCY_LOCK_UNLOCKED;

        if (owner_ == address(0)) revert InvalidOwner();
        if (installerModule_ == address(0)) revert InvalidInstallerModuleAddress();
        if (IBaseInstaller(installerModule_).moduleId() != _MODULE_ID_INSTALLER) revert InvalidInstallerModuleId();

        _owner = owner_;

        // Register `Installer` module.
        _modules[_MODULE_ID_INSTALLER] = installerModule_;
        address installerProxy = _createProxy(_MODULE_ID_INSTALLER, _MODULE_TYPE_SINGLE_PROXY);
        _trusts[installerProxy].moduleImplementation = installerModule_;

        emit OwnershipTransferred(address(0), owner_);
        emit ModuleAdded(_MODULE_ID_INSTALLER, installerModule_, IBaseInstaller(installerModule_).moduleVersion());
    }

    // ==============
    // View functions
    // ==============

    /**
     * @notice Returns the module implementation address by module id.
     * @param moduleId_ Module id.
     * @return address Module implementation address.
     */
    function moduleIdToImplementation(uint32 moduleId_) external view virtual override returns (address) {
        return _modules[moduleId_];
    }

    /**
     * @notice Returns the proxy address by module id.
     * @param moduleId_ Module id.
     * @return address Proxy address.
     */
    function moduleIdToProxy(uint32 moduleId_) external view virtual override returns (address) {
        return _proxies[moduleId_];
    }

    /**
     * @notice Returns the module id by proxy address.
     * @param proxyAddress_ Proxy address.
     * @return uint32 Module id.
     */
    function proxyToModuleId(address proxyAddress_) external view virtual override returns (uint32) {
        return _trusts[proxyAddress_].moduleId;
    }

    /**
     * @notice Returns the module implementation by proxy address.
     * @param proxyAddress_ Proxy address.
     * @return address Module implementation.
     */
    function proxyToModuleImplementation(address proxyAddress_) external view virtual override returns (address) {
        return _trusts[proxyAddress_].moduleImplementation;
    }

    /**
     * @notice Returns the trust relation by proxy address.
     * @param proxyAddress_ Proxy address.
     * @return TrustRelation Trust relation.
     */
    function proxyAddressToTrustRelation(
        address proxyAddress_
    ) external view virtual override returns (TrustRelation memory) {
        return _trusts[proxyAddress_];
    }

    // ==================
    // Fallback functions
    // ==================

    /**
     * @notice Dispatch function to module.
     */
    function dispatch() external virtual override {
        uint32 moduleId = _trusts[msg.sender].moduleId;
        address moduleImplementation = _trusts[msg.sender].moduleImplementation;

        if (moduleId == 0) revert CallerNotTrusted();

        if (moduleImplementation == address(0)) moduleImplementation = _modules[moduleId];

        uint256 messageDataLength = msg.data.length;

        // Message length >= (4 + 4 + 20)
        // 4 bytes for the dispatch() selector.
        // 4 bytes for selector used to call the proxy.
        // 20 bytes for the trailing msg.sender.
        if (messageDataLength < 28) revert MessageTooShort();

        // [dispatch() selector (4 bytes)][calldata (N bytes)][msg.sender (20 bytes)]
        assembly {
            // Remove `dispatch` selector.
            let payloadSize := sub(calldatasize(), 0x04)
            // Copy msg.data into memory, starting at position `4`.
            calldatacopy(0x00, 0x04, payloadSize)
            // Append proxy address.
            mstore(payloadSize, shl(0x60, caller()))

            // Calldata: [original calldata (N bytes)][original msg.sender (20 bytes)][proxy address (20 bytes)]
            let result := delegatecall(
                gas(),
                moduleImplementation,
                0,
                // 0x14 is the length of an address, 20 bytes, in hex.
                add(payloadSize, 0x14),
                0,
                0
            )

            // Copy the returned data into memory, starting at position `0`.
            returndatacopy(0x00, 0x00, returndatasize())

            switch result
            case 0 {
                // If result is 0, revert.
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
}
