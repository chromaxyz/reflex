// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseModule} from "../src/interfaces/IBaseModule.sol";

// Fixtures
import {ImplementationFixture} from "./fixtures/ImplementationFixture.sol";

// Mocks
import {MockBaseModule} from "./mocks/MockBaseModule.sol";
import {MockImplementationInternalModule} from "./mocks/MockImplementationInternalModule.sol";

/**
 * @title Implementation Module Internal Proxy Test
 */
contract ImplementationModuleInternalProxyTest is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION = 1;

    uint32 internal constant _MODULE_INTERNAL_ID = 101;
    uint16 internal constant _MODULE_INTERNAL_TYPE = _MODULE_TYPE_INTERNAL;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V1 = 1;
    uint16 internal constant _MODULE_INTERNAL_VERSION_V2 = 2;

    // =======
    // Storage
    // =======

    MockBaseModule public singleModule;
    MockBaseModule public singleModuleProxy;

    MockImplementationInternalModule public internalModule;

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
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );

        internalModule = new MockImplementationInternalModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION_V1,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModule);
        moduleAddresses[1] = address(internalModule);
        installerProxy.addModules(moduleAddresses);

        singleModuleProxy = MockBaseModule(
            dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID)
        );
    }

    // =====
    // Tests
    // =====

    function testCallInternalModule(uint256 number_) external {
        uint256 value = abi.decode(
            singleModuleProxy.callInternalModule(
                _MODULE_INTERNAL_ID,
                abi.encodeWithSignature("getImplementationState1()")
            ),
            (uint256)
        );

        assertEq(value, 0);

        singleModuleProxy.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("setImplementationState1(uint256)", number_)
        );

        value = abi.decode(
            singleModuleProxy.callInternalModule(
                _MODULE_INTERNAL_ID,
                abi.encodeWithSignature("getImplementationState1()")
            ),
            (uint256)
        );

        assertEq(value, number_);
    }

    function testRevertInvalidCallInternalModule() external {
        vm.expectRevert();
        singleModuleProxy.callInternalModule(
            _MODULE_INTERNAL_ID,
            abi.encodeWithSignature("getImplementationState777()")
        );
    }

    function testUpgradeInternalProxy() external {
        assertEq(internalModule.moduleVersion(), _MODULE_INTERNAL_VERSION_V1);

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(
            new MockImplementationInternalModule(
                IBaseModule.ModuleSettings({
                    moduleId: _MODULE_INTERNAL_ID,
                    moduleType: _MODULE_INTERNAL_TYPE,
                    moduleVersion: _MODULE_INTERNAL_VERSION_V2,
                    moduleUpgradeable: true,
                    moduleRemoveable: true
                })
            )
        );
        installerProxy.upgradeModules(moduleAddresses);

        internalModule = MockImplementationInternalModule(
            dispatcher.moduleIdToImplementation(_MODULE_INTERNAL_ID)
        );

        assertEq(internalModule.moduleVersion(), _MODULE_INTERNAL_VERSION_V2);
    }
}
