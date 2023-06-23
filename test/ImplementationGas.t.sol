// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBatch} from "../src/periphery/interfaces/IReflexBatch.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationGasModule} from "./mocks/MockImplementationGasModule.sol";
import {MockImplementationGasBatch} from "./mocks/MockImplementationGasBatch.sol";

/**
 * @title Implementation Gas Test
 */
contract ImplementationGasTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_BATCH = 2;

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_ENDPOINT;
    uint16 internal constant _MODULE_SINGLE_VERSION = 1;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE = true;

    // =======
    // Storage
    // =======

    MockImplementationGasBatch public batch;
    MockImplementationGasBatch public batchEndpoint;

    MockImplementationGasModule public singleModule;
    MockImplementationGasModule public singleModuleEndpoint;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        batch = new MockImplementationGasBatch(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_BATCH,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE
            })
        );

        singleModule = new MockImplementationGasModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(batch);
        moduleAddresses[1] = address(singleModule);
        installerEndpoint.addModules(moduleAddresses);

        batchEndpoint = MockImplementationGasBatch(dispatcher.moduleIdToEndpoint(_MODULE_ID_BATCH));
        singleModuleEndpoint = MockImplementationGasModule(dispatcher.moduleIdToEndpoint(_MODULE_SINGLE_ID));
    }

    // =====
    // Tests
    // =====

    /* solhint-disable max-line-length */

    function testGasEndpointGetEmpty() external view {
        // Cold: 8116 gas (8259-143)
        //
        //   [15168] ImplementationGasTest::testGasEndpointGetEmpty()
        //     ├─ [8259] ReflexEndpoint::getEmpty() [staticcall]
        //     │   ├─ [5496] MockImplementationDispatcher::getEmpty()
        //     │   │   ├─ [143] MockImplementationGasModule::getEmpty() [delegatecall]
        //     │   │   │   └─ ← ()
        //     │   │   └─ ← ()
        //     │   └─ ← ()

        singleModuleEndpoint.getEmpty();

        // Hot: 1116 gas (1259-143)
        //
        //     ├─ [1259] ReflexEndpoint::getEmpty() [staticcall]
        //     │   ├─ [996] MockImplementationDispatcher::getEmpty()
        //     │   │   ├─ [143] MockImplementationGasModule::getEmpty() [delegatecall]
        //     │   │   │   └─ ← ()
        //     │   │   └─ ← ()
        //     │   └─ ← ()
        //     └─ ← ()

        singleModuleEndpoint.getEmpty();
    }

    function testGasEndpointSetValue() external {
        // Cold: 8122 gas (30469-22347)
        //
        //   [37555] ImplementationGasTest::testGasEndpointSetValue()
        //     ├─ [30469] ReflexEndpoint::setNumber(1)
        //     │   ├─ [27703] MockImplementationDispatcher::setNumber(1)
        //     │   │   ├─ [22347] MockImplementationGasModule::setNumber(1) [delegatecall]
        //     │   │   │   └─ ← ()
        //     │   │   └─ ← ()
        //     │   └─ ← ()

        singleModuleEndpoint.setNumber(1);

        // Hot: 1122 gas (1469-347)
        //
        //     ├─ [1469] ReflexEndpoint::setNumber(2)
        //     │   ├─ [1203] MockImplementationDispatcher::setNumber(2)
        //     │   │   ├─ [347] MockImplementationGasModule::setNumber(2) [delegatecall]
        //     │   │   │   └─ ← ()
        //     │   │   └─ ← ()
        //     │   └─ ← ()
        //     └─ ← ()

        singleModuleEndpoint.setNumber(2);
    }

    function testGasEndpointGetValue() external view {
        // Cold: 8120 gas (10475-2355)
        //
        //   [17700] ImplementationGasTest::testGasEndpointGetValue()
        //     ├─ [10475] ReflexEndpoint::getNumber() [staticcall]
        //     │   ├─ [7709] MockImplementationDispatcher::getNumber()
        //     │   │   ├─ [2355] MockImplementationGasModule::getNumber() [delegatecall]
        //     │   │   │   └─ ← 1
        //     │   │   └─ ← 1
        //     │   └─ ← 1

        singleModuleEndpoint.getNumber();

        // Hot: 1120 gas (1475-355)
        //
        //     ├─ [1475] ReflexEndpoint::getNumber() [staticcall]
        //     │   ├─ [1209] MockImplementationDispatcher::getNumber()
        //     │   │   ├─ [355] MockImplementationGasModule::getNumber() [delegatecall]
        //     │   │   │   └─ ← 1
        //     │   │   └─ ← 1
        //     │   └─ ← 1
        //     └─ ← ()

        singleModuleEndpoint.getNumber();
    }

    function testGasBatchCall() external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](1);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockImplementationGasModule.getEmpty, ())
        });

        // Cold: 15073 gas (15216-143)
        //
        // ├─ [15216] ReflexEndpoint::performBatchCall([(0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x44733ae1)])
        // │   ├─ [12408] MockImplementationDispatcher::performBatchCall([(0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x44733ae1)])
        // │   │   ├─ [7010] MockImplementationGasBatch::performBatchCall([(0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x44733ae1)]) [delegatecall]
        // │   │   │   ├─ [143] MockImplementationGasModule::getEmpty() [delegatecall]
        // │   │   │   │   └─ ← ()
        // │   │   │   └─ ← ()
        // │   │   └─ ← ()
        // │   └─ ← ()

        batchEndpoint.performBatchCall(actions);

        // Hot: 3573 gas (3716-143)
        //
        // ├─ [3716] ReflexEndpoint::performBatchCall([(0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x44733ae1)])
        // │   ├─ [3408] MockImplementationDispatcher::performBatchCall([(0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x44733ae1)])
        // │   │   ├─ [2510] MockImplementationGasBatch::performBatchCall([(0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x44733ae1)]) [delegatecall]
        // │   │   │   ├─ [143] MockImplementationGasModule::getEmpty() [delegatecall]
        // │   │   │   │   └─ ← ()
        // │   │   │   └─ ← ()
        // │   │   └─ ← ()
        // │   └─ ← ()
        // └─ ← ()

        batchEndpoint.performBatchCall(actions);
    }

    /* solhint-enable max-line-length */
}
