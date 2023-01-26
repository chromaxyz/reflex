// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationGasModule} from "./mocks/MockImplementationGasModule.sol";

/**
 * @title Implementation Hot Path Test
 */
contract ImplementationHotPathTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION = 1;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE = true;

    // =======
    // Storage
    // =======

    MockImplementationGasModule public singleModule;
    MockImplementationGasModule public singleModuleProxy;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModule = new MockImplementationGasModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE
            })
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(singleModule);
        installerProxy.addModules(moduleAddresses);

        singleModuleProxy = MockImplementationGasModule(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID));
    }

    // ImplementationHotPathTest:testGasProxyEmpty() (gas: 13449)
    // ImplementationHotPathTest:testGasProxyGet() (gas: 15633)
    // ImplementationHotPathTest:testGasProxySet() (gas: 35678)

    // =====
    // Tests
    // =====

    //  [13449] ImplementationHotPathTest::testGasProxyEmpty()
    //    ├─ [8310] ReflexProxy::empty() [staticcall]
    //    │   ├─ [5439] MockImplementationDispatcher::dispatch()
    //    │   │   ├─ [209] MockImplementationGasModule::empty() [delegatecall]
    //    │   │   │   └─ ← ()
    //    │   │   └─ ← ()
    //    │   └─ ← ()
    //    └─ ← ()

    // 5230 + 2871 = 8101

    function testGasProxyEmpty() external view {
        singleModuleProxy.empty();
    }

    // 5233 + 2874 = 8107

    //  [35678] ImplementationHotPathTest::testGasProxySet()
    //    ├─ [30531] ReflexProxy::setImplementationState0(0x666f6f0000000000000000000000000000000000000000000000000000000000)
    //    │   ├─ [27657] MockImplementationDispatcher::dispatch()
    //    │   │   ├─ [22424] MockImplementationGasModule::setImplementationState0(0x666f6f0000000000000000000000000000000000000000000000000000000000) [delegatecall]
    //    │   │   │   └─ ← ()
    //    │   │   └─ ← ()
    //    │   └─ ← ()
    //    └─ ← ()

    function testGasProxySet() external {
        singleModuleProxy.setImplementationState0("foo");
    }

    // 5233 + 2874 = 8107

    //  [15633] ImplementationHotPathTest::testGasProxyGet()
    //    ├─ [10446] ReflexProxy::getImplementationState0() [staticcall]
    //    │   ├─ [7572] MockImplementationDispatcher::dispatch()
    //    │   │   ├─ [2339] MockImplementationGasModule::getImplementationState0() [delegatecall]
    //    │   │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000000
    //    │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000000
    //    │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000000
    //    └─ ← ()

    function testGasProxyGet() external view {
        singleModuleProxy.getImplementationState0();
    }
}
