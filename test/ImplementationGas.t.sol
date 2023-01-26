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

    // =====
    // Tests
    // =====

    // 13494 - 8333 = 5161
    // 8333 - 5462  = 2871
    // -------------------
    //                8032

    //   [13494] ImplementationHotPathTest::testGasProxyGetEmpty()
    //     ├─ [8333] ReflexProxy::getEmpty() [staticcall]
    //     │   ├─ [5462] MockImplementationDispatcher::dispatch()
    //     │   │   ├─ [232] MockImplementationGasModule::getEmpty() [delegatecall]
    //     │   │   │   └─ ← ()
    //     │   │   └─ ← ()
    //     │   └─ ← ()
    //     └─ ← ()

    function testGasProxyGetEmpty() external view {
        singleModuleProxy.getEmpty();
    }

    // 10446 - 7572 = 2874
    // 7572 - 2339  = 5233
    // -------------------
    //                8107

    //   [15589] ImplementationHotPathTest::testGasProxyGetValue()
    //     ├─ [10446] ReflexProxy::getImplementationState0() [staticcall]
    //     │   ├─ [7572] MockImplementationDispatcher::dispatch()
    //     │   │   ├─ [2339] MockImplementationGasModule::getImplementationState0() [delegatecall]
    //     │   │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000000
    //     │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000000
    //     │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000000
    //     └─ ← ()

    function testGasProxySetValue() external {
        singleModuleProxy.setImplementationState0("foo");
    }

    // 30487 - 27613 = 2874
    // 27613 - 22380 = 5233
    // --------------------
    //                 8107

    //   [35655] ImplementationHotPathTest::testGasProxySetValue()
    //     ├─ [30487] ReflexProxy::setImplementationState0(0x666f6f0000000000000000000000000000000000000000000000000000000000)
    //     │   ├─ [27613] MockImplementationDispatcher::dispatch()
    //     │   │   ├─ [22380] MockImplementationGasModule::setImplementationState0(0x666f6f0000000000000000000000000000000000000000000000000000000000) [delegatecall]
    //     │   │   │   └─ ← ()
    //     │   │   └─ ← ()
    //     │   └─ ← ()
    //     └─ ← ()

    function testGasProxyGetValue() external view {
        singleModuleProxy.getImplementationState0();
    }
}
