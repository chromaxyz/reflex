// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseDispatcher} from "../../src/BaseDispatcher.sol";

/**
 * @title Mock Base Dispatcher
 */
contract MockBaseDispatcher is BaseDispatcher {
    constructor(
        string memory name_,
        address owner_,
        address installerModule_
    ) BaseDispatcher(name_, owner_, installerModule_) {}
}
