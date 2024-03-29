// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexStorage} from "./IReflexStorage.sol";

/**
 * @title Reflex Dispatcher Interface
 */
interface IReflexDispatcher is IReflexStorage {
    // ======
    // Errors
    // ======

    /**
     * @notice Thrown when an unregistered and untrusted user or endpoint calls the `Dispatcher` directly.
     */
    error CallerNotTrusted();

    /**
     * @notice Thrown when a message doesn't have the correct formatting and is therefore too short.
     */
    error MessageTooShort();

    /**
     * @notice Thrown when the module id is invalid.
     */
    error ModuleIdInvalid();

    /**
     * @notice Thrown when the module has not been registered yet.
     */
    error ModuleNotRegistered();

    /**
     * @notice Thrown when the module type is invalid.
     */
    error ModuleTypeInvalid();

    /**
     * @notice Thrown when an address passed is address(0) and therefore invalid.
     */
    error ZeroAddress();

    // ======
    // Events
    // ======

    /**
     * @notice Emitted when an endpoint is created.
     * @param moduleId Module id.
     * @param endpointAddress The address of the created endpoint.
     */
    event EndpointCreated(uint32 indexed moduleId, address indexed endpointAddress);

    /**
     * @notice Emitted when a module is added.
     * @param moduleId Module id.
     * @param moduleImplementation Module implementation.
     */
    event ModuleAdded(uint32 indexed moduleId, address indexed moduleImplementation);

    /**
     * @notice Emitted when the ownership is transferred.
     * @param previousOwner The previous owner who triggered the change.
     * @param newOwner The new owner who was granted the ownership.
     */
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // =======
    // Methods
    // =======

    /**
     * @notice Returns the module implementation address by module id.
     * @param moduleId_ Module id.
     * @return address Module implementation address.
     */
    function getModuleImplementation(uint32 moduleId_) external view returns (address);

    /**
     * @notice Returns the endpoint address by module id.
     * @param moduleId_ Module id.
     * @return address Endpoint address.
     */
    function getEndpoint(uint32 moduleId_) external view returns (address);

    /**
     * @notice Returns the trust relation by endpoint address.
     * @param endpoint_ Endpoint address.
     * @return TrustRelation Trust relation.
     */
    function getTrustRelation(address endpoint_) external view returns (TrustRelation memory);
}
