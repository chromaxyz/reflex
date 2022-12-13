// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBase, IBase} from "./IBase.sol";

/**
 * @title Base Installer Test Interface
 */
interface TBaseModule is TBase {
    // ======
    // Errors
    // ======

    error InvalidModuleVersion();

    error InvalidModuleType();

    error Unauthorized();
}

/**
 * @title Base Module Interface
 */
interface IBaseModule is IBase, TBaseModule {
    function moduleId() external view returns (uint32);

    function moduleVersion() external view returns (uint16);

    function moduleType() external view returns (uint8);
}
