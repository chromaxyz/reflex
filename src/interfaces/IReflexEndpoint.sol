// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

/**
 * @title Reflex Endpoint Interface
 */
interface IReflexEndpoint {
    // ======
    // Errors
    // ======

    /**
     * @notice Thrown when the module id is invalid.
     */
    error ModuleIdInvalid();

    // =======
    // Methods
    // =======

    /**
     * @notice Returns implementation address by resolving through the `Dispatcher`.
     * @dev To prevent selector clashing avoid using the `implementation()` selector inside of modules.
     * @return address Implementation address or zero address if unresolved.
     */
    function implementation() external view returns (address);

    /**
     * @dev Sentinel DELEGATECALL opcode to nudge Etherscan to classify this as a proxy.
     * @dev Function selector clashing is mitigated by falling through to the fallback.
     */
    function sentinel() external;
}
