// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBase, IBase} from "./IBase.sol";

/**
 * @title Base Dispatcher Test Interface
 */
interface TBaseDispatcher is TBase {
    // ======
    // Errors
    // ======

    error CallerNotTrusted();

    error InvalidOwner();

    error InvalidInstallerModuleAddress();

    error InvalidInstallerModuleId();

    error MessageTooShort();

    // ======
    // Events
    // ======

    event ModuleAdded(
        uint32 indexed moduleId_,
        address indexed moduleImplementation_,
        uint16 indexed moduleVersion_
    );

    event OwnershipTransferred(
        address indexed user_,
        address indexed newOwner_
    );
}

/**
 * @title Base Dispatcher Interface
 */
interface IBaseDispatcher is IBase, TBaseDispatcher {
    // =======
    // Methods
    // =======

    function moduleIdToImplementation(
        uint32 moduleId_
    ) external view returns (address);

    function moduleIdToProxy(uint32 moduleId_) external view returns (address);

    function proxyToModuleId(
        address proxyAddress_
    ) external view returns (uint32);

    function proxyToModuleImplementation(
        address proxyAddress_
    ) external view returns (address);

    function proxyAddressToTrustRelation(
        address proxyAddress_
    ) external view returns (TrustRelation memory);

    function dispatch() external;
}
