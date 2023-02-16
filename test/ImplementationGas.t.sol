// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBatch} from "../src/periphery/interfaces/IReflexBatch.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationGasModule} from "./mocks/MockImplementationGasModule.sol";
import {MockReflexBatch} from "./mocks/MockReflexBatch.sol";

/**
 * @title Implementation Gas Test
 */
contract ImplementationGasTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_BATCH = 2;

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION = 1;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE = true;

    // =======
    // Storage
    // =======

    MockReflexBatch public batch;
    MockReflexBatch public batchProxy;

    MockImplementationGasModule public singleModule;
    MockImplementationGasModule public singleModuleProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        batch = new MockReflexBatch(
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
        installerProxy.addModules(moduleAddresses);

        batchProxy = MockReflexBatch(dispatcher.moduleIdToProxy(_MODULE_ID_BATCH));
        singleModuleProxy = MockImplementationGasModule(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID));
    }

    // =====
    // Tests
    // =====

    function testGasProxyGetEmpty() external view {
        // Cold: 8065 gas (8208-143)
        //
        //   [15043] ImplementationGasTest::testGasProxyGetEmpty()
        //     ├─ [8208] ReflexProxy::getEmpty() [staticcall]
        //     │   ├─ [5352] MockImplementationDispatcher::getEmpty()
        //     │   │   ├─ [143] MockImplementationGasModule::getEmpty() [delegatecall]
        //     │   │   │   └─ ← ()
        //     │   │   └─ ← ()
        //     │   └─ ← ()

        singleModuleProxy.getEmpty();

        // Hot: 1065 gas (1208-143)
        //
        //     ├─ [1208] ReflexProxy::getEmpty() [staticcall]
        //     │   ├─ [852] MockImplementationDispatcher::getEmpty()
        //     │   │   ├─ [143] MockImplementationGasModule::getEmpty() [delegatecall]
        //     │   │   │   └─ ← ()
        //     │   │   └─ ← ()
        //     │   └─ ← ()
        //     └─ ← ()

        singleModuleProxy.getEmpty();
    }

    function testGasProxySetValue() external {
        // Cold: 8071 gas (10580-2509)
        //
        //   [20554] ImplementationGasTest::testGasProxySetValue()
        //     ├─ [10580] ReflexProxy::setNumber(1)
        //     │   ├─ [7721] MockImplementationDispatcher::setNumber(1)
        //     │   │   ├─ [2509] MockImplementationGasModule::setNumber(1) [delegatecall]
        //     │   │   │   └─ ← ()
        //     │   │   └─ ← ()
        //     │   └─ ← ()

        singleModuleProxy.setNumber(1);

        // Hot: 1071 gas (4380-3309)
        //
        //     ├─ [4380] ReflexProxy::setNumber(2)
        //     │   ├─ [4021] MockImplementationDispatcher::setNumber(2)
        //     │   │   ├─ [3309] MockImplementationGasModule::setNumber(2) [delegatecall]
        //     │   │   │   └─ ← ()
        //     │   │   └─ ← ()
        //     │   └─ ← ()
        //     └─ ← ()

        singleModuleProxy.setNumber(2);
    }

    function testGasProxyGetValue() external view {
        // Cold: 8069 gas (10424-2355)
        //
        //   [17577] ImplementationGasTest::testGasProxyGetValue()
        //     ├─ [10424] ReflexProxy::getNumber() [staticcall]
        //     │   ├─ [7565] MockImplementationDispatcher::getNumber()
        //     │   │   ├─ [2355] MockImplementationGasModule::getNumber() [delegatecall]
        //     │   │   │   └─ ← 1
        //     │   │   └─ ← 1
        //     │   └─ ← 1

        singleModuleProxy.getNumber();

        // Hot: 1069 gas (1424-355)
        //
        //     ├─ [1424] ReflexProxy::getNumber() [staticcall]
        //     │   ├─ [1065] MockImplementationDispatcher::getNumber()
        //     │   │   ├─ [355] MockImplementationGasModule::getNumber() [delegatecall]
        //     │   │   │   └─ ← 1
        //     │   │   └─ ← 1
        //     │   └─ ← 1
        //     └─ ← ()

        singleModuleProxy.getNumber();
    }

    function testGasBatchCall() external {
        // Cold: 19179 gas (21688-2509)
        //
        // ├─ [21688] ReflexProxy::performBatchCall([(0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x18559e190000000000000000000000000000000000000000000000000000000000000001), (0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0xf2c9ecd8), (0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x44733ae1)])
        // │   ├─ [18708] MockImplementationDispatcher::performBatchCall([(0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x18559e190000000000000000000000000000000000000000000000000000000000000001), (0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0xf2c9ecd8), (0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x44733ae1)])
        // │   │   ├─ [13375] MockReflexBatch::performBatchCall([(0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x18559e190000000000000000000000000000000000000000000000000000000000000001), (0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0xf2c9ecd8), (0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x44733ae1)]) [delegatecall]
        // │   │   │   ├─ [2509] MockImplementationGasModule::setNumber(1) [delegatecall]
        // │   │   │   │   └─ ← ()
        // │   │   │   ├─ [355] MockImplementationGasModule::getNumber() [delegatecall]
        // │   │   │   │   └─ ← 1
        // │   │   │   ├─ [143] MockImplementationGasModule::getEmpty() [delegatecall]
        // │   │   │   │   └─ ← ()
        // │   │   │   └─ ← ()
        // │   │   └─ ← ()
        // │   └─ ← ()

        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](3);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            proxyAddress: address(singleModuleProxy),
            callData: abi.encodeCall(MockImplementationGasModule.setNumber, (1))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            proxyAddress: address(singleModuleProxy),
            callData: abi.encodeCall(MockImplementationGasModule.getNumber, ())
        });

        actions[2] = IReflexBatch.BatchAction({
            allowFailure: false,
            proxyAddress: address(singleModuleProxy),
            callData: abi.encodeCall(MockImplementationGasModule.getEmpty, ())
        });

        batchProxy.performBatchCall(actions);

        // Hot: 7679 gas (8188-509)
        //
        // ├─ [8188] ReflexProxy::performBatchCall([(0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x18559e190000000000000000000000000000000000000000000000000000000000000001), (0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0xf2c9ecd8), (0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x44733ae1)])
        // │   ├─ [7708] MockImplementationDispatcher::performBatchCall([(0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x18559e190000000000000000000000000000000000000000000000000000000000000001), (0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0xf2c9ecd8), (0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x44733ae1)])
        // │   │   ├─ [6875] MockReflexBatch::performBatchCall([(0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x18559e190000000000000000000000000000000000000000000000000000000000000001), (0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0xf2c9ecd8), (0x3C8Ca53ee5661D29d3d3C0732689a4b86947EAF0, false, 0x44733ae1)]) [delegatecall]
        // │   │   │   ├─ [509] MockImplementationGasModule::setNumber(1) [delegatecall]
        // │   │   │   │   └─ ← ()
        // │   │   │   ├─ [355] MockImplementationGasModule::getNumber() [delegatecall]
        // │   │   │   │   └─ ← 1
        // │   │   │   ├─ [143] MockImplementationGasModule::getEmpty() [delegatecall]
        // │   │   │   │   └─ ← ()
        // │   │   │   └─ ← ()
        // │   │   └─ ← ()
        // │   └─ ← ()
        // └─ ← ()

        batchProxy.performBatchCall(actions);
    }
}
