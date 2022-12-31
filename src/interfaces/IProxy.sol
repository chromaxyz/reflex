// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @title Proxy Test Interface
 */
interface TProxy {

}

/**
 * @title Proxy Interface
 */
interface IProxy is TProxy {
    function implementation() external view returns (address);
}
