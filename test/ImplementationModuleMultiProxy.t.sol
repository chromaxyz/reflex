// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseModule} from "../src/interfaces/IBaseModule.sol";

// Implementations
import {ImplementationERC20} from "./implementations/abstracts/ImplementationERC20.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationERC20} from "./mocks/MockImplementationERC20.sol";
import {MockImplementationERC20Hub} from "./mocks/MockImplementationERC20Hub.sol";

/**
 * @title Implementation Module Multi Proxy Test
 */
contract ImplementationModuleMultiProxyTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION = 1;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE = true;
    bool internal constant _MODULE_SINGLE_REMOVEABLE = true;

    uint32 internal constant _MODULE_MULTI_ID = 101;
    uint16 internal constant _MODULE_MULTI_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _MODULE_MULTI_VERSION_V1 = 1;
    uint16 internal constant _MODULE_MULTI_VERSION_V2 = 2;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_V2 = false;
    bool internal constant _MODULE_MULTI_REMOVEABLE_V1 = true;
    bool internal constant _MODULE_MULTI_REMOVEABLE_V2 = false;

    string internal constant _MODULE_MULTI_NAME_A = "TOKEN A";
    string internal constant _MODULE_MULTI_SYMBOL_A = "TKNA";
    uint8 internal constant _MODULE_MULTI_DECIMALS_A = 18;

    string internal constant _MODULE_MULTI_NAME_B = "TOKEN B";
    string internal constant _MODULE_MULTI_SYMBOL_B = "TKNB";
    uint8 internal constant _MODULE_MULTI_DECIMALS_B = 6;

    string internal constant _MODULE_MULTI_NAME_C = "TOKEN C";
    string internal constant _MODULE_MULTI_SYMBOL_C = "TKNC";
    uint8 internal constant _MODULE_MULTI_DECIMALS_C = 8;

    // =======
    // Storage
    // =======

    MockImplementationERC20Hub public singleModule;
    MockImplementationERC20Hub public singleModuleProxy;

    MockImplementationERC20 public multiModuleV1;
    MockImplementationERC20 public multiModuleV2;

    MockImplementationERC20 public multiModuleProxyA;
    MockImplementationERC20 public multiModuleProxyB;
    MockImplementationERC20 public multiModuleProxyC;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModule = new MockImplementationERC20Hub(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE,
                moduleRemoveable: _MODULE_SINGLE_REMOVEABLE
            })
        );

        multiModuleV1 = new MockImplementationERC20(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V1,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V1,
                moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V1
            })
        );

        multiModuleV2 = new MockImplementationERC20(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION_V2,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_V2,
                moduleRemoveable: _MODULE_MULTI_REMOVEABLE_V2
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModule);
        moduleAddresses[1] = address(multiModuleV1);
        installerProxy.addModules(moduleAddresses);

        singleModuleProxy = MockImplementationERC20Hub(
            dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID)
        );

        multiModuleProxyA = MockImplementationERC20(
            singleModuleProxy.addERC20(
                _MODULE_MULTI_ID,
                _MODULE_MULTI_TYPE,
                _MODULE_MULTI_NAME_A,
                _MODULE_MULTI_SYMBOL_A,
                _MODULE_MULTI_DECIMALS_A
            )
        );
        multiModuleProxyB = MockImplementationERC20(
            singleModuleProxy.addERC20(
                _MODULE_MULTI_ID,
                _MODULE_MULTI_TYPE,
                _MODULE_MULTI_NAME_B,
                _MODULE_MULTI_SYMBOL_B,
                _MODULE_MULTI_DECIMALS_B
            )
        );
        multiModuleProxyC = MockImplementationERC20(
            singleModuleProxy.addERC20(
                _MODULE_MULTI_ID,
                _MODULE_MULTI_TYPE,
                _MODULE_MULTI_NAME_C,
                _MODULE_MULTI_SYMBOL_C,
                _MODULE_MULTI_DECIMALS_C
            )
        );
    }

    // ==========
    // Invariants
    // ==========

    function invariantMetadata() public {
        assertEq(multiModuleProxyA.name(), _MODULE_MULTI_NAME_A);
        assertEq(multiModuleProxyA.symbol(), _MODULE_MULTI_SYMBOL_A);
        assertEq(multiModuleProxyA.decimals(), _MODULE_MULTI_DECIMALS_A);

        assertEq(multiModuleProxyB.name(), _MODULE_MULTI_NAME_B);
        assertEq(multiModuleProxyB.symbol(), _MODULE_MULTI_SYMBOL_B);
        assertEq(multiModuleProxyB.decimals(), _MODULE_MULTI_DECIMALS_B);

        assertEq(multiModuleProxyC.name(), _MODULE_MULTI_NAME_C);
        assertEq(multiModuleProxyC.symbol(), _MODULE_MULTI_SYMBOL_C);
        assertEq(multiModuleProxyC.decimals(), _MODULE_MULTI_DECIMALS_C);
    }

    // =====
    // Tests
    // =====

    function testModuleSettings() external {
        _testModuleConfiguration(
            multiModuleV1,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1,
            _MODULE_MULTI_REMOVEABLE_V1
        );

        _testModuleConfiguration(
            multiModuleV2,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2,
            _MODULE_MULTI_REMOVEABLE_V2
        );
    }

    function testUpgradeMultiProxySingleImplementation() external {
        _testModuleConfiguration(
            multiModuleProxyA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1,
            _MODULE_MULTI_REMOVEABLE_V1
        );

        _testModuleConfiguration(
            multiModuleProxyB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1,
            _MODULE_MULTI_REMOVEABLE_V1
        );

        _testModuleConfiguration(
            multiModuleProxyC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V1,
            _MODULE_MULTI_UPGRADEABLE_V1,
            _MODULE_MULTI_REMOVEABLE_V1
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleV2);
        installerProxy.upgradeModules(moduleAddresses);

        _testModuleConfiguration(
            multiModuleProxyA,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2,
            _MODULE_MULTI_REMOVEABLE_V2
        );

        _testModuleConfiguration(
            multiModuleProxyB,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2,
            _MODULE_MULTI_REMOVEABLE_V2
        );

        _testModuleConfiguration(
            multiModuleProxyC,
            _MODULE_MULTI_ID,
            _MODULE_MULTI_TYPE,
            _MODULE_MULTI_VERSION_V2,
            _MODULE_MULTI_UPGRADEABLE_V2,
            _MODULE_MULTI_REMOVEABLE_V2
        );
    }

    // =========
    // Utilities
    // =========

    function _testModuleConfiguration(
        IBaseModule module_,
        uint32 moduleId_,
        uint16 moduleType_,
        uint16 moduleVersion_,
        bool moduleUpgradeable_,
        bool moduleRemoveable_
    ) internal {
        IBaseModule.ModuleSettings memory moduleSettings = module_
            .moduleSettings();

        assertEq(moduleSettings.moduleId, moduleId_);
        assertEq(module_.moduleId(), moduleId_);
        assertEq(moduleSettings.moduleType, moduleType_);
        assertEq(module_.moduleType(), moduleType_);
        assertEq(moduleSettings.moduleVersion, moduleVersion_);
        assertEq(module_.moduleVersion(), moduleVersion_);
        assertEq(moduleSettings.moduleUpgradeable, moduleUpgradeable_);
        assertEq(module_.moduleUpgradeable(), moduleUpgradeable_);
        assertEq(moduleSettings.moduleRemoveable, moduleRemoveable_);
        assertEq(module_.moduleRemoveable(), moduleRemoveable_);
    }
}
