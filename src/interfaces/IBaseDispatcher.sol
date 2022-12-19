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

    error InvalidName();

    error InvalidOwner();

    error InvalidInstallerModule();

    error MessageTooShort();

    // ======
    // Events
    // ======

    event NameChanged(address indexed user_, string name_);

    event OwnershipTransferred(
        address indexed user_,
        address indexed newOwner_
    );
}

/**
 * @title BaseDispatcher Interface
 */
interface IBaseDispatcher is IBase, TBaseDispatcher {
    function dispatch() external payable;

    function moduleIdToImplementation(
        uint32 moduleId_
    ) external view returns (address);

    function moduleIdToProxy(uint32 moduleId_) external view returns (address);

    function name() external view returns (string memory);

    function proxyAddressToTrustRelation(
        address proxyAddress_
    ) external view returns (TrustRelation memory);
}
