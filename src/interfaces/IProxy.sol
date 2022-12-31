// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @title Proxy Test Interface
 */
interface TProxy {
    // ======
    // Events
    // ======

    event Upgraded(address indexed implementation);
}

/**
 * @title Proxy Interface
 */
interface IProxy is TProxy {
    function setImplementation(address implementation_) external;
}
