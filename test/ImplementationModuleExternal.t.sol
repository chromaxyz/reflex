// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseModule} from "../src/interfaces/IBaseModule.sol";
import {IBaseExternalModule} from "../src/interfaces/IBaseExternalModule.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockBaseModule} from "./mocks/MockBaseModule.sol";
import {MockImplementationExternalModule} from "./mocks/MockImplementationExternalModule.sol";

/**
 * @title Implementation Module External Test
 */
contract ImplementationModuleExternalTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION = 1;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE = true;
    bool internal constant _MODULE_SINGLE_REMOVEABLE = true;

    uint32 internal constant _MODULE_EXTERNAL_ID = 101;
    uint16 internal constant _MODULE_EXTERNAL_TYPE = _MODULE_TYPE_EXTERNAL;
    uint16 internal constant _MODULE_EXTERNAL_VERSION_V1 = 1;
    uint16 internal constant _MODULE_EXTERNAL_VERSION_V2 = 2;
    bool internal constant _MODULE_EXTERNAL_UPGRADEABLE_V1 = true;
    bool internal constant _MODULE_EXTERNAL_UPGRADEABLE_V2 = false;
    bool internal constant _MODULE_EXTERNAL_REMOVEABLE_V1 = true;
    bool internal constant _MODULE_EXTERNAL_REMOVEABLE_V2 = false;

    // =======
    // Storage
    // =======

    MockBaseModule public singleModule;
    MockBaseModule public singleModuleProxy;

    MockImplementationExternalModule public externalModule;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModule = new MockBaseModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE,
                moduleRemoveable: _MODULE_SINGLE_REMOVEABLE
            })
        );

        externalModule = new MockImplementationExternalModule(
            IBaseExternalModule.ModuleSettings({
                moduleId: _MODULE_EXTERNAL_ID,
                moduleType: _MODULE_EXTERNAL_TYPE,
                moduleVersion: _MODULE_EXTERNAL_VERSION_V1,
                moduleUpgradeable: _MODULE_EXTERNAL_UPGRADEABLE_V1,
                moduleRemoveable: _MODULE_EXTERNAL_REMOVEABLE_V1
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModule);
        moduleAddresses[1] = address(externalModule);
        installerProxy.addModules(moduleAddresses);

        singleModuleProxy = MockBaseModule(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID));
    }

    // =====
    // Tests
    // =====

    function testModuleIdToImplementation() external {
        assertEq(dispatcher.moduleIdToModuleImplementation(_MODULE_EXTERNAL_ID), address(externalModule));
    }

    function testModuleIdToProxy() external {
        assertEq(dispatcher.moduleIdToProxy(_MODULE_EXTERNAL_ID), address(0));
    }

    function testModuleSettings() external {
        _testModuleConfiguration(
            singleModule,
            _MODULE_SINGLE_ID,
            _MODULE_SINGLE_TYPE,
            _MODULE_SINGLE_VERSION,
            _MODULE_SINGLE_UPGRADEABLE,
            _MODULE_SINGLE_REMOVEABLE
        );

        _testModuleConfiguration(
            MockBaseModule(address(externalModule)),
            _MODULE_EXTERNAL_ID,
            _MODULE_EXTERNAL_TYPE,
            _MODULE_EXTERNAL_VERSION_V1,
            _MODULE_EXTERNAL_UPGRADEABLE_V1,
            _MODULE_EXTERNAL_REMOVEABLE_V1
        );
    }

    // TODO: add tests

    function testCallExternalModule(uint256 number_) external {
        uint256 value = abi.decode(
            singleModuleProxy.callExternalModule(
                _MODULE_EXTERNAL_ID,
                abi.encodeWithSignature("getImplementationState1()")
            ),
            (uint256)
        );

        assertEq(value, 0);

        singleModuleProxy.callExternalModule(
            _MODULE_EXTERNAL_ID,
            abi.encodeWithSignature("setImplementationState1(uint256)", number_)
        );

        value = abi.decode(
            singleModuleProxy.callExternalModule(
                _MODULE_EXTERNAL_ID,
                abi.encodeWithSignature("getImplementationState1()")
            ),
            (uint256)
        );

        assertEq(value, number_);

        value = abi.decode(
            singleModuleProxy.callStaticExternalModule(
                _MODULE_EXTERNAL_ID,
                abi.encodeWithSignature("getImplementationState1()")
            ),
            (uint256)
        );

        assertEq(value, number_);
    }

    function testRevertInvalidCallExternalModule() external {
        vm.expectRevert();
        singleModuleProxy.callExternalModule(
            _MODULE_EXTERNAL_ID,
            abi.encodeWithSignature("getImplementationState777()")
        );
    }

    function testUpgradeExternalModule() external {
        _testModuleConfiguration(
            MockBaseModule(address(externalModule)),
            _MODULE_EXTERNAL_ID,
            _MODULE_EXTERNAL_TYPE,
            _MODULE_EXTERNAL_VERSION_V1,
            _MODULE_EXTERNAL_UPGRADEABLE_V1,
            _MODULE_EXTERNAL_REMOVEABLE_V1
        );

        externalModule = new MockImplementationExternalModule(
            IBaseExternalModule.ModuleSettings({
                moduleId: _MODULE_EXTERNAL_ID,
                moduleType: _MODULE_EXTERNAL_TYPE,
                moduleVersion: _MODULE_EXTERNAL_VERSION_V2,
                moduleUpgradeable: _MODULE_EXTERNAL_UPGRADEABLE_V2,
                moduleRemoveable: _MODULE_EXTERNAL_REMOVEABLE_V2
            })
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(externalModule);
        installerProxy.upgradeModules(moduleAddresses);

        _testModuleConfiguration(
            MockBaseModule(address(externalModule)),
            _MODULE_EXTERNAL_ID,
            _MODULE_EXTERNAL_TYPE,
            _MODULE_EXTERNAL_VERSION_V2,
            _MODULE_EXTERNAL_UPGRADEABLE_V2,
            _MODULE_EXTERNAL_REMOVEABLE_V2
        );
    }

    function testRemoveExternalModule() external {
        _testModuleConfiguration(
            MockBaseModule(address(externalModule)),
            _MODULE_EXTERNAL_ID,
            _MODULE_EXTERNAL_TYPE,
            _MODULE_EXTERNAL_VERSION_V1,
            _MODULE_EXTERNAL_UPGRADEABLE_V1,
            _MODULE_EXTERNAL_REMOVEABLE_V1
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(externalModule);
        installerProxy.removeModules(moduleAddresses);

        externalModule = MockImplementationExternalModule(
            dispatcher.moduleIdToModuleImplementation(_MODULE_EXTERNAL_ID)
        );

        assertEq(address(externalModule), address(0));
    }
}
