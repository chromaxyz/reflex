// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationGasModule} from "./mocks/MockImplementationGasModule.sol";

/**
 * @title Implementation Gas Test
 */
contract ImplementationGasTest is ImplementationFixture {
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

    // 2871 + 5230 = 8101

    //   [13405] ImplementationGasTest::testGasProxyGetEmpty()
    //     ├─ [8244] ReflexProxy::getEmpty() [staticcall]
    //     │   ├─ [5373] MockImplementationDispatcher::dispatch()
    //     │   │   ├─ [143] MockImplementationGasModule::getEmpty() [delegatecall]
    //     │   │   │   └─ ← ()
    //     │   │   └─ ← ()
    //     │   └─ ← ()
    //     └─ ← ()

    function testGasProxyGetEmpty() external view {
        singleModuleProxy.getEmpty();
    }

    // 2874 + 5233 = 8107

    //   [35609] ImplementationGasTest::testGasProxySetValue()
    //     ├─ [30441] ReflexProxy::setImplementationState0(0x666f6f0000000000000000000000000000000000000000000000000000000000)
    //     │   ├─ [27567] MockImplementationDispatcher::dispatch()
    //     │   │   ├─ [22334] MockImplementationGasModule::setImplementationState0(0x666f6f0000000000000000000000000000000000000000000000000000000000) [delegatecall]
    //     │   │   │   └─ ← ()
    //     │   │   └─ ← ()
    //     │   └─ ← ()
    //     └─ ← ()

    function testGasProxySetValue() external {
        singleModuleProxy.setImplementationState0("foo");
    }

    // 2874 + 5233 = 8107

    //   [15543] ImplementationGasTest::testGasProxyGetValue()
    //     ├─ [10400] ReflexProxy::getImplementationState0() [staticcall]
    //     │   ├─ [7526] MockImplementationDispatcher::dispatch()
    //     │   │   ├─ [2293] MockImplementationGasModule::getImplementationState0() [delegatecall]
    //     │   │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000000
    //     │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000000
    //     │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000000
    //     └─ ← ()

    function testGasProxyGetValue() external view {
        singleModuleProxy.getImplementationState0();
    }
}
