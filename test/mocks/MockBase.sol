// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {Base} from "../../src/Base.sol";

/**
 * @title Mock Base
 */
contract MockBase is Base {
    constructor() Base() {}

    function createProxy(
        uint32 moduleId_,
        uint16 moduleType_
    ) public returns (address) {
        return _createProxy(moduleId_, moduleType_);
    }

    function unpackMessageSender() public pure returns (address) {
        return _unpackMessageSender();
    }

    function unpackParameters() public pure returns (address, address) {
        return _unpackParameters();
    }
}
