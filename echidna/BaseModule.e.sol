// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseConstants} from "../src/BaseConstants.sol";

// Mocks
import {MockBaseModule} from "../test/mocks/MockBaseModule.sol";

contract BaseModuleEchidnaTest is BaseConstants {
    MockBaseModule private _module;

    uint32 private _moduleId;
    uint16 private _moduleType;
    uint16 private _moduleVersion;

    constructor() {
        _moduleId = 2;
        _moduleType = _MODULE_TYPE_SINGLE_PROXY;
        _moduleVersion = 1;

        _module = new MockBaseModule(_moduleId, _moduleType, _moduleVersion);
    }

    function echidna_ModuleIdImmutable() external view returns (bool) {
        return _module.moduleId() == _moduleId;
    }

    function echidna_ModuleVersionImmutable() external view returns (bool) {
        return _module.moduleVersion() == _moduleVersion;
    }

    function echidna_ModuleTypeImmutable() external view returns (bool) {
        return _module.moduleType() == _moduleType;
    }
}
