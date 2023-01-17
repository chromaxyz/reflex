// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseDispatcher} from "../../src/BaseDispatcher.sol";

/**
 * @title Mock Base Dispatcher
 */
contract MockBaseDispatcher is BaseDispatcher {
    // ===========
    // Constructor
    // ===========

    /**
     * @param owner_ Protocol owner.
     * @param installerModuleImplementation_ Installer module implementation address.
     * @param proxyImplementation_ Proxy implementation address.
     */
    constructor(
        address owner_,
        address installerModuleImplementation_,
        address proxyImplementation_
    ) BaseDispatcher(owner_, installerModuleImplementation_, proxyImplementation_) {}
}
