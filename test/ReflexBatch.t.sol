// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
import {IERC20} from "forge-std/interfaces/IERC20.sol";

// Interfaces
import {IReflexBatch} from "../src/periphery/interfaces/IReflexBatch.sol";
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Fixtures
import {ReflexFixture} from "./fixtures/ReflexFixture.sol";

// Mocks
import {ImplementationERC20} from "./mocks/abstracts/ImplementationERC20.sol";
import {ImplementationState} from "./mocks/abstracts/ImplementationState.sol";
import {MockImplementationERC20} from "./mocks/MockImplementationERC20.sol";
import {MockImplementationERC20Hub} from "./mocks/MockImplementationERC20Hub.sol";
import {MockImplementationModule} from "./mocks/MockImplementationModule.sol";
import {MockReflexBatch} from "./mocks/MockReflexBatch.sol";
import {MockReflexModule} from "./mocks/MockReflexModule.sol";

/**
 * @title Reflex Batch Test
 */
contract ReflexBatchTest is ReflexFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_BATCH = 2;
    uint16 internal constant _MODULE_TYPE_BATCH = _MODULE_TYPE_SINGLE_ENDPOINT;
    uint16 internal constant _MODULE_VERSION_BATCH = 1;
    bool internal constant _MODULE_UPGRADEABLE_BATCH = true;

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

    ExternalTarget public externalTarget;

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

        externalTarget = new ExternalTarget();

        batch = new MockReflexBatch(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_BATCH,
                moduleType: _MODULE_TYPE_BATCH,
                moduleVersion: _MODULE_VERSION_BATCH,
                moduleUpgradeable: _MODULE_UPGRADEABLE_BATCH
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

        batchEndpoint = MockReflexBatch(dispatcher.getEndpoint(_MODULE_ID_BATCH));

        singleModuleEndpoint = MockImplementationERC20Hub(dispatcher.getEndpoint(_MODULE_SINGLE_ID));

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

    function testFuzzStaticCall(uint256 amount_) external withHooksExpected(1) withExternalTarget(amount_) {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(batchEndpoint),
            callData: abi.encodeCall(
                batchEndpoint.performStaticCall,
                (address(externalTarget), abi.encodeCall(ExternalTarget.getNumber, ()))
            )
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: true,
            endpointAddress: address(batchEndpoint),
            callData: abi.encodeCall(batchEndpoint.performStaticCall, (address(0), ""))
        });

        IReflexBatch.BatchActionResponse[] memory responses = new IReflexBatch.BatchActionResponse[](2);
        responses[0] = IReflexBatch.BatchActionResponse({success: true, returnData: abi.encode(amount_)});
        responses[1] = IReflexBatch.BatchActionResponse({
            success: false,
            returnData: abi.encodeWithSelector(IReflexModule.ZeroAddress.selector)
        });

        vm.expectRevert(abi.encodeWithSelector(IReflexBatch.BatchSimulation.selector, responses));
        batchEndpoint.simulateBatchCallRevert(actions);

        batchEndpoint.performBatchCall(actions);
    }

    function testUnitRevertStaticCall() external withHooksExpected(0) {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](1);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(batchEndpoint),
            callData: abi.encodeCall(
                batchEndpoint.performStaticCall,
                (address(externalTarget), abi.encodeCall(ExternalTarget.getRevertStaticCall, ()))
            )
        });

        vm.expectRevert(ExternalTarget.KnownViewError.selector);
        batchEndpoint.performBatchCall(actions);
    }

    function testFuzzSimulateBatchCallRevert(
        address target_,
        uint256 amount_,
        bytes32 message_
    ) external withHooksExpected(1) withExternalTarget(amount_) {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](7);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.setImplementationState0, (message_))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.getImplementationState0, ())
        });

        actions[2] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockImplementationERC20.mint, (_brutalize(target_), amount_))
        });

        actions[3] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(ImplementationERC20.balanceOf, (_brutalize(target_)))
        });

        actions[4] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackMessageSender, ())
        });

        actions[5] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackEndpointAddress, ())
        });

        actions[6] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(batchEndpoint),
            callData: abi.encodeCall(
                batchEndpoint.performStaticCall,
                (address(externalTarget), abi.encodeCall(ExternalTarget.getNumber, ()))
            )
        });

        IReflexBatch.BatchActionResponse[] memory responses = new IReflexBatch.BatchActionResponse[](7);
        responses[0] = IReflexBatch.BatchActionResponse({success: true, returnData: ""});
        responses[1] = IReflexBatch.BatchActionResponse({success: true, returnData: abi.encode(message_)});
        responses[2] = IReflexBatch.BatchActionResponse({success: true, returnData: ""});
        responses[3] = IReflexBatch.BatchActionResponse({success: true, returnData: abi.encode(amount_)});
        responses[4] = IReflexBatch.BatchActionResponse({success: true, returnData: abi.encode(address(this))});
        responses[5] = IReflexBatch.BatchActionResponse({
            success: true,
            returnData: abi.encode(address(singleModuleEndpoint))
        });
        responses[6] = IReflexBatch.BatchActionResponse({success: true, returnData: abi.encode(amount_)});

        vm.expectRevert(abi.encodeWithSelector(IReflexBatch.BatchSimulation.selector, responses));
        batchEndpoint.simulateBatchCallRevert(actions);

        assertEq(multiModuleEndpoint.balanceOf(_brutalize(target_)), 0);

        batchEndpoint.performBatchCall(actions);

        assertEq(multiModuleEndpoint.balanceOf(_brutalize(target_)), amount_);
    }

    function testFuzzSimulateBatchCallReturn(
        address target_,
        uint256 amount_,
        bytes32 message_
    ) external withHooksExpected(1) withExternalTarget(amount_) {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](7);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.setImplementationState0, (message_))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.getImplementationState0, ())
        });

        actions[2] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockImplementationERC20.mint, (_brutalize(target_), amount_))
        });

        actions[3] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(ImplementationERC20.balanceOf, (_brutalize(target_)))
        });

        actions[4] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackMessageSender, ())
        });

        actions[5] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackEndpointAddress, ())
        });

        actions[6] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(batchEndpoint),
            callData: abi.encodeCall(
                batchEndpoint.performStaticCall,
                (address(externalTarget), abi.encodeCall(ExternalTarget.getNumber, ()))
            )
        });

        IReflexBatch.BatchActionResponse[] memory responses = batchEndpoint.simulateBatchCallReturn(actions);

        assertEq(responses[0].success, true);
        assertEq(responses[0].returnData, "");

        assertEq(responses[1].success, true);
        assertEq(responses[1].returnData, abi.encode(message_));

        assertEq(responses[2].success, true);
        assertEq(responses[2].returnData, "");

        assertEq(responses[3].success, true);
        assertEq(responses[3].returnData, abi.encode(amount_));

        assertEq(responses[4].success, true);
        assertEq(responses[4].returnData, abi.encode(address(this)));

        assertEq(responses[5].success, true);
        assertEq(responses[5].returnData, abi.encode(address(singleModuleEndpoint)));

        assertEq(responses[6].success, true);
        assertEq(responses[6].returnData, abi.encode(amount_));

        assertEq(multiModuleEndpoint.balanceOf(_brutalize(target_)), 0);

        batchEndpoint.performBatchCall(actions);

        assertEq(multiModuleEndpoint.balanceOf(_brutalize(target_)), amount_);
    }

    function testUnitRevertInvalidBatchActionConfiguration() external withHooksExpected(0) {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](1);

        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleIdInvalid.selector, 0));
        batchEndpoint.simulateBatchCallReturn(actions);
    }

    function testUnitRevertBatchSimulationFailed() external withHooksExpected(0) {
        dispatcher.setModuleToImplementation(batch.moduleId(), address(0));

        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](1);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.getImplementationState0, ())
        });

        vm.expectRevert(IReflexBatch.BatchSimulationFailed.selector);
        batchEndpoint.simulateBatchCallReturn(actions);
    }

    function testFuzzPerformBatchCall(
        address target_,
        uint256 amount_,
        bytes32 message_
    ) external withHooksExpected(1) withExternalTarget(amount_) {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](7);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.setImplementationState0, (message_))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.getImplementationState0, ())
        });

        actions[2] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockImplementationERC20.mint, (_brutalize(target_), amount_))
        });

        actions[3] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(ImplementationERC20.balanceOf, (_brutalize(target_)))
        });

        actions[4] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackMessageSender, ())
        });

        actions[5] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackEndpointAddress, ())
        });

        actions[6] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(batchEndpoint),
            callData: abi.encodeCall(
                batchEndpoint.performStaticCall,
                (address(externalTarget), abi.encodeCall(ExternalTarget.getNumber, ()))
            )
        });

        assertEq(multiModuleEndpoint.balanceOf(_brutalize(target_)), 0);

        batchEndpoint.performBatchCall(actions);

        assertEq(multiModuleEndpoint.balanceOf(_brutalize(target_)), amount_);
    }

    function testFuzzPerformBatchCallAllowFailure(
        address target_,
        uint256 amount_,
        bytes32 message_
    ) external withHooksExpected(1) {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](3);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.setImplementationState0, (message_))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: true,
            endpointAddress: address(batchEndpoint),
            callData: abi.encodeCall(ImplementationState.getImplementationState0, ())
        });

        actions[2] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpoint),
            callData: abi.encodeCall(MockImplementationERC20.mint, (_brutalize(target_), amount_))
        });

        batchEndpoint.performBatchCall(actions);
    }

    function testUnitRevertPerformBatchCallFailure() external withHooksExpected(0) {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.setImplementationState0, (bytes32("777")))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(batchEndpoint),
            callData: abi.encodeCall(ImplementationState.getImplementationState0, ())
        });

        vm.expectRevert(IReflexModule.EmptyError.selector);
        batchEndpoint.performBatchCall(actions);
    }

    function testUnitRevertPerformBatchCallInvalidModuleId() external withHooksExpected(0) {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.setImplementationState0, (bytes32("777")))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: true,
            endpointAddress: address(0),
            callData: abi.encodeCall(ImplementationState.getImplementationState0, ())
        });

        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleIdInvalid.selector, 0));
        batchEndpoint.performBatchCall(actions);
    }

    function testUnitRevertPerformBatchCallInternalModule() external withHooksExpected(0) {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.setImplementationState0, (bytes32("777")))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: true,
            endpointAddress: address(internalModule),
            callData: abi.encodeCall(ImplementationState.getImplementationState0, ())
        });

        vm.expectRevert(abi.encodeWithSelector(IReflexModule.ModuleIdInvalid.selector, 0));
        batchEndpoint.performBatchCall(actions);
    }

    function testUnitRevertPerformBatchCallNotRegisteredMultiModule() external withHooksExpected(0) {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.setImplementationState0, (bytes32("777")))
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
            callData: abi.encodeCall(ImplementationState.getImplementationState0, ())
        });

        vm.expectRevert(abi.encodeWithSelector(IReflexBatch.ModuleNotRegistered.selector, _MODULE_MULTI_ID_B));
        batchEndpoint.performBatchCall(actions);
    }

    // =========
    // Utilities
    // =========

    modifier withHooksExpected(uint256 batchCallCounter_) {
        assertEq(batchEndpoint.beforeBatchCallCounter(), 0);
        assertEq(batchEndpoint.afterBatchCallCounter(), 0);

        _;

        assertEq(batchEndpoint.beforeBatchCallCounter(), batchCallCounter_);
        assertEq(batchEndpoint.afterBatchCallCounter(), batchCallCounter_);
    }

    modifier withExternalTarget(uint256 number_) {
        externalTarget.setNumber(number_);

        _;

        assertEq(externalTarget.getNumber(), number_);
    }
}

// =========
// Utilities
// =========

/**
 * @title External Target
 */
contract ExternalTarget {
    // ======
    // Errors
    // ======

    error KnownViewError();

    // =======
    // Storage
    // =======

    uint256 internal _number;

    // ==========
    // Test stubs
    // ==========

    function getRevertStaticCall() external pure {
        revert KnownViewError();
    }

    function getNumber() external view returns (uint256) {
        return _number;
    }

    function setNumber(uint256 number_) external {
        _number = number_;
    }
}
