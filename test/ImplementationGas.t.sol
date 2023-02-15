// SPDX-License-Identifier: GPL-3.0-or-later
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

    function testGasProxyGetEmpty() external view {
        // 8208 - 143 = 8065
        //
        //   [13369] ImplementationGasTest::testGasProxyGetEmpty()
        //     ├─ [8208] ReflexProxy::getEmpty() [staticcall]
        //     │   ├─ [5352] MockImplementationDispatcher::getEmpty()
        //     │   │   ├─ [143] MockImplementationGasModule::getEmpty() [delegatecall]
        //     │   │   │   └─ ← ()
        //     │   │   └─ ← ()
        //     │   └─ ← ()
        //     └─ ← ()

        singleModuleProxy.getEmpty();
    }

    function testGasProxySetValue() external {
        // 10580 - 2509 = 8071
        //
        //   [15726] ImplementationGasTest::testGasProxySetValue()
        //     ├─ [10580] ReflexProxy::setNumber(1)
        //     │   ├─ [7721] MockImplementationDispatcher::setNumber(1)
        //     │   │   ├─ [2509] MockImplementationGasModule::setNumber(1) [delegatecall]
        //     │   │   │   └─ ← ()
        //     │   │   └─ ← ()
        //     │   └─ ← ()
        //     └─ ← ()

        singleModuleProxy.setNumber(1);
    }

    function testGasProxyGetValue() external view {
        // 10424 - 2355 = 8069
        //
        //   [15646] ImplementationGasTest::testGasProxyGetValue()
        //     ├─ [10424] ReflexProxy::getNumber() [staticcall]
        //     │   ├─ [7565] MockImplementationDispatcher::getNumber()
        //     │   │   ├─ [2355] MockImplementationGasModule::getNumber() [delegatecall]
        //     │   │   │   └─ ← 1
        //     │   │   └─ ← 1
        //     │   └─ ← 1
        //     └─ ← ()

        singleModuleProxy.getNumber();
    }
}
