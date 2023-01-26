// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBase, TReflexBase} from "./IReflexBase.sol";

/**
 * @title Reflex Dispatcher Test Interface
 */
interface TReflexDispatcher is TReflexBase {
    // ======
    // Errors
    // ======

    error CallerNotTrusted();

    error InvalidOwner();

    error InvalidModuleAddress();

    error MessageTooShort();

    // ======
    // Events
    // ======

    event ModuleAdded(uint256 indexed moduleId_, address indexed moduleImplementation_, uint256 indexed moduleVersion_);

    event OwnershipTransferred(address indexed user_, address indexed newOwner_);
}

/**
 * @title Reflex Dispatcher Interface
 */
interface IReflexDispatcher is IReflexBase, TReflexDispatcher {
    // =======
    // Methods
    // =======

    function moduleIdToModuleImplementation(uint256 moduleId_) external view returns (address);

    function moduleIdToProxy(uint256 moduleId_) external view returns (address);

    function dispatch() external;
}
