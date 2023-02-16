// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBatch, TReflexBatch} from "../src/periphery/interfaces/IReflexBatch.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {MockImplementationERC20} from "./mocks/MockImplementationERC20.sol";
import {MockImplementationERC20Hub} from "./mocks/MockImplementationERC20Hub.sol";
import {MockImplementationModule} from "./mocks/MockImplementationModule.sol";
import {MockReflexBatch} from "./mocks/MockReflexBatch.sol";

/**
 * @title Reflex Batch Test
 */
contract ReflexBatchTest is TReflexBatch, ReflexFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_BATCH = 2;

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_PROXY;
    uint16 internal constant _MODULE_SINGLE_VERSION = 1;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE = true;

    uint32 internal constant _MODULE_MULTI_ID = 101;
    uint16 internal constant _MODULE_MULTI_TYPE = _MODULE_TYPE_MULTI_PROXY;
    uint16 internal constant _MODULE_MULTI_VERSION = 1;
    bool internal constant _MODULE_MULTI_UPGRADEABLE = true;

    string internal constant _MODULE_MULTI_NAME = "TOKEN A";
    string internal constant _MODULE_MULTI_SYMBOL = "TKNA";
    uint8 internal constant _MODULE_MULTI_DECIMALS = 18;

    uint32 internal constant _MODULE_INTERNAL_ID = 102;
    uint16 internal constant _MODULE_INTERNAL_TYPE = _MODULE_TYPE_INTERNAL;
    uint16 internal constant _MODULE_INTERNAL_VERSION = 1;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE = true;

    // =======
    // Storage
    // =======

    MockImplementationERC20Hub public singleModule;
    MockImplementationERC20Hub public singleModuleProxy;

    MockImplementationERC20 public multiModule;
    MockImplementationERC20 public multiModuleProxy;

    MockImplementationModule public internalModule;

    MockReflexBatch public batch;
    MockReflexBatch public batchProxy;

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

        singleModule = new MockImplementationERC20Hub(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_SINGLE_ID,
                moduleType: _MODULE_SINGLE_TYPE,
                moduleVersion: _MODULE_SINGLE_VERSION,
                moduleUpgradeable: _MODULE_SINGLE_UPGRADEABLE
            })
        );

        multiModule = new MockImplementationERC20(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_MULTI_ID,
                moduleType: _MODULE_MULTI_TYPE,
                moduleVersion: _MODULE_MULTI_VERSION,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE
            })
        );

        internalModule = new MockImplementationModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_INTERNAL_ID,
                moduleType: _MODULE_INTERNAL_TYPE,
                moduleVersion: _MODULE_INTERNAL_VERSION,
                moduleUpgradeable: _MODULE_INTERNAL_UPGRADEABLE
            })
        );

        address[] memory moduleAddresses = new address[](4);
        moduleAddresses[0] = address(batch);
        moduleAddresses[1] = address(singleModule);
        moduleAddresses[2] = address(multiModule);
        moduleAddresses[3] = address(internalModule);

        installerProxy.addModules(moduleAddresses);

        batchProxy = MockReflexBatch(dispatcher.moduleIdToProxy(_MODULE_ID_BATCH));

        singleModuleProxy = MockImplementationERC20Hub(dispatcher.moduleIdToProxy(_MODULE_SINGLE_ID));

        multiModuleProxy = MockImplementationERC20(
            singleModuleProxy.addERC20(
                _MODULE_MULTI_ID,
                _MODULE_MULTI_TYPE,
                _MODULE_MULTI_NAME,
                _MODULE_MULTI_SYMBOL,
                _MODULE_MULTI_DECIMALS
            )
        );
    }

    function testFuzzSimulateBatchCall(bytes32 message_) external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            proxyAddress: address(singleModuleProxy),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (message_))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            proxyAddress: address(singleModuleProxy),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        IReflexBatch.BatchActionResponse[] memory responses = new IReflexBatch.BatchActionResponse[](2);

        responses[0] = IReflexBatch.BatchActionResponse({success: true, returnData: ""});

        responses[1] = IReflexBatch.BatchActionResponse({success: true, returnData: abi.encodePacked(message_)});

        vm.expectRevert(abi.encodeWithSelector(IReflexBatch.BatchSimulation.selector, responses));
        batchProxy.simulateBatchCall(actions);
    }

    function testFuzzPerformBatchCall(bytes32 message_) public {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            proxyAddress: address(singleModuleProxy),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (message_))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            proxyAddress: address(singleModuleProxy),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        batchProxy.performBatchCall(actions);
    }

    function testUnitPerformBatchCallAllowFailure() public {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            proxyAddress: address(singleModuleProxy),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (bytes32("777")))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: true,
            proxyAddress: address(batchProxy),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        batchProxy.performBatchCall(actions);
    }

    function testUnitRevertPerformBatchCallInvalidModuleId() public {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            proxyAddress: address(singleModuleProxy),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (bytes32("777")))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: true,
            proxyAddress: address(0),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        vm.expectRevert(InvalidModuleId.selector);
        batchProxy.performBatchCall(actions);
    }

    function testUnitRevertPerformBatchCallInternalModule() public {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            proxyAddress: address(singleModuleProxy),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (bytes32("777")))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: true,
            proxyAddress: address(internalModule),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        vm.expectRevert(InvalidModuleId.selector);
        batchProxy.performBatchCall(actions);
    }

    // test allow error
    // test all paths
    // test with all module types
}
