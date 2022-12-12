// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Sources
import {BaseModule} from "../../src/BaseModule.sol";

/**
 * @title Mock Module V1
 */
contract MockModuleV1 is BaseModule {
    constructor(
        uint32 _moduleId,
        uint16 _moduleVersion
    ) BaseModule(_moduleId, _moduleVersion) {}
}

/**
 * @title Mock Module V2
 */
contract MockModuleV2 is BaseModule {
    constructor(
        uint32 _moduleId,
        uint16 _moduleVersion
    ) BaseModule(_moduleId, _moduleVersion) {}
}

/**
 * @title Mock Module Nonexistent
 */
contract MockModuleNonexistent is BaseModule {
    constructor(
        uint32 _moduleId,
        uint16 _moduleVersion
    ) BaseModule(_moduleId, _moduleVersion) {}
}

/**
 * @title Mock Module Multi Proxy
 */
contract MockModuleMultiProxy is BaseModule {
    constructor(
        uint32 _moduleId,
        uint16 _moduleVersion
    ) BaseModule(_moduleId, _moduleVersion) {}
}
