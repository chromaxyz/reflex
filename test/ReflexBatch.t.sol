// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {TReflexBatch} from "../src/periphery/interfaces/IReflexBatch.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {MockReflexBatch} from "./mocks/MockReflexBatch.sol";

/**
 * @title Reflex Batch Test
 */
contract ReflexBatchTest is TReflexBatch, ReflexFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_BATCH = 2;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION_V1 = 1;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE_V1 = true;

    // =======
    // Storage
    // =======

    MockReflexBatch public batch;
    MockReflexBatch public batchProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        batch = new MockReflexBatch(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_BATCH,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION_V1,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE_V1
            })
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(batch);

        installerProxy.addModules(moduleAddresses);
        batchProxy = MockReflexBatch(dispatcher.moduleIdToProxy(_MODULE_ID_BATCH));
    }

    function testUnitPerformBatchCall() external {
        // Add scenario
    }
}
