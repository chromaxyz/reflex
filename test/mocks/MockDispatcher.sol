// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Contracts
import {Dispatcher} from "../../src/abstracts/Dispatcher.sol";

/**
 * @title Mock Dispatcher
 */
contract MockDispatcher is Dispatcher {
    constructor(
        string memory name_,
        address owner_,
        address installerModule_
    ) Dispatcher(name_, owner_, installerModule_) {}
}
