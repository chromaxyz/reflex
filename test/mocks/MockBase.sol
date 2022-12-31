// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Internals
import {Base} from "../../src/internals/Base.sol";

/**
 * @title Mock Base
 */
contract MockBase is Base {
    // ===========
    // Constructor
    // ===========

    constructor() Base() {}

    // ==========
    // Test stubs
    // ==========

    function createProxy(
        uint32 moduleId_,
        uint16 moduleType_
    ) public returns (address) {
        return _createProxy(moduleId_, moduleType_);
    }

    function callInternalModule(
        uint32 moduleId_,
        bytes memory input_
    ) public returns (bytes memory) {
        return _callInternalModule(moduleId_, input_);
    }

    function unpackMessageSender() public pure returns (address) {
        return _unpackMessageSender();
    }

    function unpackProxyAddress() public pure returns (address) {
        return _unpackProxyAddress();
    }

    function revertBytes(bytes memory errorMessage_) public pure {
        return _revertBytes(errorMessage_);
    }
}
