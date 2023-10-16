// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

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

    uint32 internal constant _MODULE_ID_SINGLE = 100;
    uint32 internal constant _MODULE_ID_MULTI_AB = 101;
    uint32 internal constant _MODULE_ID_MULTI_CD = 102;
    uint32 internal constant _MODULE_ID_INTERNAL = 103;

    string internal constant _MODULE_NAME_MULTI_A = "TOKEN A";
    string internal constant _MODULE_SYMBOL_MULTI_A = "TKNA";
    uint8 internal constant _MODULE_DECIMALS_MULTI_A = 18;

    string internal constant _MODULE_NAME_MULTI_B = "TOKEN B";
    string internal constant _MODULE_SYMBOL_MULTI_B = "TKNB";
    uint8 internal constant _MODULE_DECIMALS_MULTI_B = 6;

    string internal constant _MODULE_NAME_MULTI_C = "TOKEN C";
    string internal constant _MODULE_SYMBOL_MULTI_C = "TKNC";
    uint8 internal constant _MODULE_DECIMALS_MULTI_C = 18;

    string internal constant _MODULE_NAME_MULTI_D = "TOKEN D";
    string internal constant _MODULE_SYMBOL_MULTI_D = "TKND";
    uint8 internal constant _MODULE_DECIMALS_MULTI_D = 6;

    // =======
    // Storage
    // =======

    ExternalTarget public externalTarget;

    MockReflexBatch public batch;
    MockReflexBatch public batchEndpoint;

    MockImplementationERC20Hub public singleModule;
    MockImplementationERC20Hub public singleModuleEndpoint;

    MockImplementationERC20 public multiModuleAB; // A <> B
    MockImplementationERC20 public multiModuleEndpointA;
    MockImplementationERC20 public multiModuleEndpointB;

    MockImplementationERC20 public multiModuleCD; // C <> D
    MockImplementationERC20 public multiModuleEndpointC;
    MockImplementationERC20 public multiModuleEndpointD;

    MockImplementationModule public internalModule;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        externalTarget = new ExternalTarget();

        batch = new MockReflexBatch(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_BATCH, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        singleModule = new MockImplementationERC20Hub(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_SINGLE, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        multiModuleAB = new MockImplementationERC20(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_MULTI_AB, moduleType: _MODULE_TYPE_MULTI_ENDPOINT})
        );

        internalModule = new MockImplementationModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_INTERNAL, moduleType: _MODULE_TYPE_INTERNAL})
        );

        address[] memory moduleAddresses = new address[](4);
        moduleAddresses[0] = address(batch);
        moduleAddresses[1] = address(singleModule);
        moduleAddresses[2] = address(multiModuleAB);
        moduleAddresses[3] = address(internalModule);
        installerEndpoint.addModules(moduleAddresses);

        batchEndpoint = MockReflexBatch(dispatcher.getEndpoint(_MODULE_ID_BATCH));

        singleModuleEndpoint = MockImplementationERC20Hub(dispatcher.getEndpoint(_MODULE_ID_SINGLE));

        multiModuleEndpointA = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_ID_MULTI_AB,
                _MODULE_TYPE_MULTI_ENDPOINT,
                _MODULE_NAME_MULTI_A,
                _MODULE_SYMBOL_MULTI_A,
                _MODULE_DECIMALS_MULTI_A
            )
        );

        multiModuleEndpointB = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_ID_MULTI_AB,
                _MODULE_TYPE_MULTI_ENDPOINT,
                _MODULE_NAME_MULTI_B,
                _MODULE_SYMBOL_MULTI_B,
                _MODULE_DECIMALS_MULTI_B
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
        responses[0] = IReflexBatch.BatchActionResponse({success: true, result: abi.encode(amount_)});
        responses[1] = IReflexBatch.BatchActionResponse({success: true, result: ""});

        vm.expectRevert(abi.encodeWithSelector(IReflexBatch.BatchSimulation.selector, responses));
        batchEndpoint.simulateBatchCall(actions);

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

    function testFuzzSimulateBatchCall(
        address target_,
        uint256 amountA_,
        uint256 amountB_,
        bytes32 message_
    ) external withHooksExpected(1) withExternalTarget(amountA_) {
        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](9);

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
            endpointAddress: address(multiModuleEndpointA),
            callData: abi.encodeCall(MockImplementationERC20.mint, (_brutalize(target_), amountA_))
        });

        actions[3] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpointA),
            callData: abi.encodeCall(ImplementationERC20.balanceOf, (_brutalize(target_)))
        });

        actions[4] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpointB),
            callData: abi.encodeCall(MockImplementationERC20.mint, (_brutalize(target_), amountB_))
        });

        actions[5] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpointB),
            callData: abi.encodeCall(ImplementationERC20.balanceOf, (_brutalize(target_)))
        });

        actions[6] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackMessageSender, ())
        });

        actions[7] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(MockReflexModule.unpackEndpointAddress, ())
        });

        actions[8] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(batchEndpoint),
            callData: abi.encodeCall(
                batchEndpoint.performStaticCall,
                (address(externalTarget), abi.encodeCall(ExternalTarget.getNumber, ()))
            )
        });

        IReflexBatch.BatchActionResponse[] memory responses = new IReflexBatch.BatchActionResponse[](9);
        responses[0] = IReflexBatch.BatchActionResponse({success: true, result: ""});
        responses[1] = IReflexBatch.BatchActionResponse({success: true, result: abi.encode(message_)});
        responses[2] = IReflexBatch.BatchActionResponse({success: true, result: ""});
        responses[3] = IReflexBatch.BatchActionResponse({success: true, result: abi.encode(amountA_)});
        responses[4] = IReflexBatch.BatchActionResponse({success: true, result: ""});
        responses[5] = IReflexBatch.BatchActionResponse({success: true, result: abi.encode(amountB_)});
        responses[6] = IReflexBatch.BatchActionResponse({success: true, result: abi.encode(address(this))});
        responses[7] = IReflexBatch.BatchActionResponse({
            success: true,
            result: abi.encode(address(singleModuleEndpoint))
        });
        responses[8] = IReflexBatch.BatchActionResponse({success: true, result: abi.encode(amountA_)});

        vm.expectRevert(abi.encodeWithSelector(IReflexBatch.BatchSimulation.selector, responses));
        batchEndpoint.simulateBatchCall(actions);

        assertEq(multiModuleEndpointA.balanceOf(_brutalize(target_)), 0);
        assertEq(multiModuleEndpointB.balanceOf(_brutalize(target_)), 0);

        batchEndpoint.performBatchCall(actions);

        assertEq(multiModuleEndpointA.balanceOf(_brutalize(target_)), amountA_);
        assertEq(multiModuleEndpointB.balanceOf(_brutalize(target_)), amountB_);
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
            endpointAddress: address(multiModuleEndpointA),
            callData: abi.encodeCall(MockImplementationERC20.mint, (_brutalize(target_), amount_))
        });

        actions[3] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpointA),
            callData: abi.encodeCall(ImplementationERC20.balanceOf, (_brutalize(target_)))
        });

        actions[4] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpointA),
            callData: abi.encodeCall(MockReflexModule.unpackMessageSender, ())
        });

        actions[5] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(multiModuleEndpointA),
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

        assertEq(multiModuleEndpointA.balanceOf(_brutalize(target_)), 0);

        batchEndpoint.performBatchCall(actions);

        assertEq(multiModuleEndpointA.balanceOf(_brutalize(target_)), amount_);
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
            endpointAddress: address(multiModuleEndpointA),
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

        vm.expectRevert(IReflexModule.ModuleIdInvalid.selector);
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

        vm.expectRevert(IReflexModule.ModuleIdInvalid.selector);
        batchEndpoint.performBatchCall(actions);
    }

    function testUnitRevertPerformBatchCallNotRegisteredMultiModule() external withHooksExpected(1) {
        multiModuleEndpointC = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_ID_MULTI_CD,
                _MODULE_TYPE_MULTI_ENDPOINT,
                _MODULE_NAME_MULTI_C,
                _MODULE_SYMBOL_MULTI_C,
                _MODULE_DECIMALS_MULTI_C
            )
        );

        multiModuleEndpointD = MockImplementationERC20(
            singleModuleEndpoint.addERC20(
                _MODULE_ID_MULTI_CD,
                _MODULE_TYPE_MULTI_ENDPOINT,
                _MODULE_NAME_MULTI_D,
                _MODULE_SYMBOL_MULTI_D,
                _MODULE_DECIMALS_MULTI_D
            )
        );

        IReflexBatch.BatchAction[] memory actions = new IReflexBatch.BatchAction[](2);

        actions[0] = IReflexBatch.BatchAction({
            allowFailure: false,
            endpointAddress: address(singleModuleEndpoint),
            callData: abi.encodeCall(ImplementationState.setImplementationState0, (bytes32("777")))
        });

        actions[1] = IReflexBatch.BatchAction({
            allowFailure: true,
            endpointAddress: address(multiModuleEndpointC),
            callData: abi.encodeCall(ImplementationState.getImplementationState0, ())
        });

        // Expect that an unregistered multi-module implementation throws an error.
        vm.expectRevert(IReflexBatch.ModuleNotRegistered.selector);
        batchEndpoint.performBatchCall(actions);

        multiModuleCD = new MockImplementationERC20(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_MULTI_CD, moduleType: _MODULE_TYPE_MULTI_ENDPOINT})
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(multiModuleCD);
        installerEndpoint.addModules(moduleAddresses);

        // Expect that once registered the multi-module doesn't throw an error.
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
