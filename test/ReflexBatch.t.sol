// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBatch, TReflexBatch} from "../src/periphery/interfaces/IReflexBatch.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {ImplementationERC20} from "./mocks/abstracts/ImplementationERC20.sol";
import {MockImplementationERC20} from "./mocks/MockImplementationERC20.sol";
import {MockImplementationERC20Hub} from "./mocks/MockImplementationERC20Hub.sol";
import {MockImplementationModule} from "./mocks/MockImplementationModule.sol";
import {MockReflexBatch} from "./mocks/MockReflexBatch.sol";
import {MockReflexModule} from "./mocks/MockReflexModule.sol";

/**
 * @title Reflex Batch Test
 */
contract ReflexBatchTest is TReflexBatch, ReflexFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_BATCH = 2;

    uint32 internal constant _MODULE_SINGLE_ID = 100;
    uint16 internal constant _MODULE_SINGLE_TYPE = _MODULE_TYPE_SINGLE_ENDPOINT;
    uint16 internal constant _MODULE_SINGLE_VERSION = 1;
    bool internal constant _MODULE_SINGLE_UPGRADEABLE = true;

    uint32 internal constant _MODULE_MULTI_ID_A = 101;
    uint16 internal constant _MODULE_MULTI_TYPE_A = _MODULE_TYPE_MULTI_ENDPOINT;
    uint16 internal constant _MODULE_MULTI_VERSION_A = 1;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_A = true;

    uint32 internal constant _MODULE_MULTI_ID_B = 102;
    uint16 internal constant _MODULE_MULTI_TYPE_B = _MODULE_TYPE_MULTI_ENDPOINT;
    uint16 internal constant _MODULE_MULTI_VERSION_B = 1;
    bool internal constant _MODULE_MULTI_UPGRADEABLE_B = true;

    string internal constant _MODULE_MULTI_NAME_A = "TOKEN A";
    string internal constant _MODULE_MULTI_SYMBOL_A = "TKNA";
    uint8 internal constant _MODULE_MULTI_DECIMALS_A = 18;

    string internal constant _MODULE_MULTI_NAME_B = "TOKEN B";
    string internal constant _MODULE_MULTI_SYMBOL_B = "TKNB";
    uint8 internal constant _MODULE_MULTI_DECIMALS_B = 6;

    uint32 internal constant _MODULE_INTERNAL_ID = 103;
    uint16 internal constant _MODULE_INTERNAL_TYPE = _MODULE_TYPE_INTERNAL;
    uint16 internal constant _MODULE_INTERNAL_VERSION = 1;
    bool internal constant _MODULE_INTERNAL_UPGRADEABLE = true;

    // =======
    // Storage
    // =======

    MockReflexBatch public batch;
    MockReflexBatch public batchEndpoint;

    MockImplementationERC20Hub public singleModule;
    MockImplementationERC20Hub public singleModuleEndpoint;

    MockImplementationERC20 public multiModule;
    MockImplementationERC20 public multiModuleEndpoint;

    MockImplementationModule public internalModule;

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
                moduleId: _MODULE_MULTI_ID_A,
                moduleType: _MODULE_MULTI_TYPE_A,
                moduleVersion: _MODULE_MULTI_VERSION_A,
                moduleUpgradeable: _MODULE_MULTI_UPGRADEABLE_A
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
        installerEndpoint.addModules(moduleAddresses);

        batchEndpoint = MockReflexBatch(dispatcher.moduleIdToEndpoint(_MODULE_ID_BATCH));

        singleModuleEndpoint = MockImplementationERC20Hub(dispatcher.moduleIdToEndpoint(_MODULE_SINGLE_ID));

        multiModuleEndpoint = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_MULTI_ID_A,
                _MODULE_MULTI_TYPE_A,
                _MODULE_MULTI_NAME_A,
                _MODULE_MULTI_SYMBOL_A,
                _MODULE_MULTI_DECIMALS_A
            )
        );
    }

    function testFuzzSimulateBatchCallSingleModule(bytes32 message_) external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](4);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (message_))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        actions[2] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackMessageSender, ())
        });

        actions[3] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackEndpointAddress, ())
        });

        IReflexBatch.BatchActionResponse[] memory responses = new IReflexBatch.BatchActionResponse[](4);
        responses[0] = IReflexBatch.BatchActionResponse({success: true, returnData: ""});
        responses[1] = IReflexBatch.BatchActionResponse({success: true, returnData: abi.encode(message_)});
        responses[2] = IReflexBatch.BatchActionResponse({success: true, returnData: abi.encode(address(this))});
        responses[3] = IReflexBatch.BatchActionResponse({
            success: true,
            returnData: abi.encode(address(singleModuleEndpoint))
        });

        vm.expectRevert(abi.encodeWithSelector(IReflexBatch.BatchSimulation.selector, responses));
        batchEndpoint.simulateBatchCall(actions);
    }

    function testFuzzSimulateBatchCallSingleModuleDecoded(bytes32 message_) external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](4);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (message_))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        actions[2] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackMessageSender, ())
        });

        actions[3] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackEndpointAddress, ())
        });

        IReflexBatch.BatchActionResponse[] memory responses = batchEndpoint.simulateBatchCallDecoded(actions);

        assertEq(responses[0].success, true);
        assertEq(responses[0].returnData, "");

        assertEq(responses[1].success, true);
        assertEq(responses[1].returnData, abi.encode(message_));

        assertEq(responses[2].success, true);
        assertEq(responses[2].returnData, abi.encode(address(this)));

        assertEq(responses[3].success, true);
        assertEq(responses[3].returnData, abi.encode(address(singleModuleEndpoint)));
    }

    function testFuzzSimulateBatchCallMultiModule(address target_, uint256 amount_) external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](4);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockImplementationERC20.mint, (target_, amount_))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(ImplementationERC20.balanceOf, (target_))
        });

        actions[2] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackMessageSender, ())
        });

        actions[3] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackEndpointAddress, ())
        });

        IReflexBatch.BatchActionResponse[] memory responses = new IReflexBatch.BatchActionResponse[](4);
        responses[0] = IReflexBatch.BatchActionResponse({success: true, returnData: ""});
        responses[1] = IReflexBatch.BatchActionResponse({success: true, returnData: abi.encode(amount_)});
        responses[2] = IReflexBatch.BatchActionResponse({success: true, returnData: abi.encode(address(this))});
        responses[3] = IReflexBatch.BatchActionResponse({
            success: true,
            returnData: abi.encode(address(multiModuleEndpoint))
        });

        vm.expectRevert(abi.encodeWithSelector(IReflexBatch.BatchSimulation.selector, responses));
        batchEndpoint.simulateBatchCall(actions);

        assertEq(multiModuleEndpoint.balanceOf(target_), 0);
    }

    function testFuzzSimulateBatchCallMultiModuleDecoded(address target_, uint256 amount_) external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](4);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockImplementationERC20.mint, (target_, amount_))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(ImplementationERC20.balanceOf, (target_))
        });

        actions[2] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackMessageSender, ())
        });

        actions[3] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackEndpointAddress, ())
        });

        IReflexBatch.BatchActionResponse[] memory responses = batchEndpoint.simulateBatchCallDecoded(actions);

        assertEq(responses[0].success, true);
        assertEq(responses[0].returnData, "");

        assertEq(responses[1].success, true);
        assertEq(responses[1].returnData, abi.encode(amount_));

        assertEq(responses[2].success, true);
        assertEq(responses[2].returnData, abi.encode(address(this)));

        assertEq(responses[3].success, true);
        assertEq(responses[3].returnData, abi.encode(address(multiModuleEndpoint)));

        assertEq(multiModuleEndpoint.balanceOf(target_), 0);
    }

    function testFuzzPerformBatchCall(bytes32 message_) external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (message_))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        batchEndpoint.performBatchCall(actions);
    }

    function testFuzzPerformBatchCallAllowFailure(bytes32 message_, address target_, uint256 amount_) external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](3);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (message_))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: true,
            endpointAddress: address(batchEndpoint),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        actions[2] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockImplementationERC20.mint, (target_, amount_))
        });

        batchEndpoint.performBatchCall(actions);
    }

    function testUnitRevertPerformBatchCallFailure() external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (bytes32("777")))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(batchEndpoint),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        vm.expectRevert(EmptyError.selector);
        batchEndpoint.performBatchCall(actions);
    }

    function testUnitRevertPerformBatchCallInvalidModuleId() external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (bytes32("777")))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: true,
            endpointAddress: address(0),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        vm.expectRevert(InvalidModuleId.selector);
        batchEndpoint.performBatchCall(actions);
    }

    function testUnitRevertPerformBatchCallInternalModule() external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (bytes32("777")))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: true,
            endpointAddress: address(internalModule),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        vm.expectRevert(InvalidModuleId.selector);
        batchEndpoint.performBatchCall(actions);
    }

    function testUnitRevertPerformBatchCallNotRegisteredMultiModule() external {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockImplementationModule.setImplementationState0, (bytes32("777")))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: true,
            endpointAddress: address(
                singleModuleEndpoint.addERC20(
                    _MODULE_MULTI_ID_B,
                    _MODULE_MULTI_TYPE_B,
                    _MODULE_MULTI_NAME_B,
                    _MODULE_MULTI_SYMBOL_B,
                    _MODULE_MULTI_DECIMALS_B
                )
            ),
            callData: abi.encodeCall(MockImplementationModule.getImplementationState0, ())
        });

        vm.expectRevert(abi.encodeWithSelector(ModuleNotRegistered.selector, _MODULE_MULTI_ID_B));
        batchEndpoint.performBatchCall(actions);
    }
}
