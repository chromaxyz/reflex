// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseProxy} from "../../src/BaseProxy.sol";

/**
 * @title Implementation Proxy
 */
contract ImplementationProxy is BaseProxy {
    // ===========
    // Constructor
    // ===========

    constructor(uint32 moduleId_) BaseProxy(moduleId_) {}
}
