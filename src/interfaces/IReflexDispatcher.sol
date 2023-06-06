// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBase} from "./IReflexBase.sol";

/**
 * @title Reflex Dispatcher Interface
 */
interface IReflexDispatcher is IReflexBase {
    // ======
    // Errors
    // ======

    error CallerNotTrusted();

    error OwnerInvalid();

    error ModuleAddressInvalid();

    error MessageTooShort();

    // ======
    // Events
    // ======

    event ModuleAdded(uint32 indexed moduleId, address indexed moduleImplementation, uint32 indexed moduleVersion);

    event OwnershipTransferred(address indexed user, address indexed newOwner);

    // =======
    // Methods
    // =======

    /**
     * @notice Returns the module implementation address by module id.
     * @param moduleId_ Module id.
     * @return address Module implementation address.
     */
    function moduleIdToModuleImplementation(uint32 moduleId_) external view returns (address);

    /**
     * @notice Returns the endpoint address by module id.
     * @param moduleId_ Module id.
     * @return address Endpoint address.
     */
    function moduleIdToEndpoint(uint32 moduleId_) external view returns (address);
}
