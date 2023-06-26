// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBatch} from "../src/periphery/interfaces/IReflexBatch.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Sources
import {ReflexBatch} from "../src/periphery/ReflexBatch.sol";
import {ReflexBase} from "../src/ReflexBase.sol";
import {ReflexConstants} from "../src/ReflexConstants.sol";
import {ReflexModule} from "../src/ReflexModule.sol";

// Mocks
import {ImplementationState} from "./mocks/abstracts/ImplementationState.sol";
import {MockImplementationDispatcher} from "./mocks/MockImplementationDispatcher.sol";
import {MockImplementationInstaller} from "./mocks/MockImplementationInstaller.sol";

/**
 * @title Gas Benchmark Test
 */
contract GasBenchmarkTest is ReflexConstants {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_SINGLE_ID = 2;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_ENDPOINT;
    uint16 internal constant _MODULE_SINGLE_VERSION = 1;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE = true;

    uint32 internal constant _MODULE_ID_BATCH = 3;

    // =======
    // Storage
    // =======

    MockImplementationDispatcher public dispatcher;

    MockImplementationInstaller public installer;
    MockImplementationInstaller public installerEndpoint;

    MockImplementationGasModule public singleModule;
    MockImplementationGasModule public singleModuleEndpoint;

    MockImplementationGasBatch public batch;
    MockImplementationGasBatch public batchEndpoint;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        installer = new MockImplementationInstaller(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_ENDPOINT,
                moduleVersion: 1,
                moduleUpgradeable: true
            })
        );
        dispatcher = new MockImplementationDispatcher(address(this), address(installer));
        installerEndpoint = MockImplementationInstaller(dispatcher.getEndpoint(_MODULE_ID_INSTALLER));

        singleModule = new MockImplementationGasModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE
            })
        );

        batch = new MockImplementationGasBatch(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_BATCH,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModule);
        moduleAddresses[1] = address(batch);
        installerEndpoint.addModules(moduleAddresses);

        singleModuleEndpoint = MockImplementationGasModule(dispatcher.getEndpoint(_MODULE_SINGLE_ID));
        batchEndpoint = MockImplementationGasBatch(dispatcher.getEndpoint(_MODULE_ID_BATCH));
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

/**
 * @title Mock Implementation Gas Module
 */
contract MockImplementationGasModule is ReflexModule, ImplementationState {
    // =======
    // Storage
    // =======

    /**
     * @dev `bytes32(uint256(keccak256("_NUMBER_SLOT")) - 1)`
     */
    bytes32 internal constant _NUMBER_SLOT = 0x74df73f62091511be85a1d4aa85b90a3b3ce25fdca122468743a9a4661137bb7;

    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) ReflexModule(moduleSettings_) {}

    // ==========
    // Test stubs
    // ==========

    function getEmpty() external view {}

    function setNumber(uint8 number_) external {
        assembly ("memory-safe") {
            sstore(_NUMBER_SLOT, number_)
        }
    }

    function getNumber() external view returns (uint8 n_) {
        assembly ("memory-safe") {
            n_ := sload(_NUMBER_SLOT)
        }
    }
}

/**
 * @title Mock Implementation Gas Batch
 */
contract MockImplementationGasBatch is ReflexBatch, MockImplementationGasModule {
    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockImplementationGasModule(moduleSettings_) {}
}
