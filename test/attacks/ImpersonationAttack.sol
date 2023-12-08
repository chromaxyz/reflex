// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexDispatcher} from "../../src/interfaces/IReflexDispatcher.sol";
import {IReflexModule} from "../../src/interfaces/IReflexModule.sol";
import {IReflexBatch} from "../../src/periphery/interfaces/IReflexBatch.sol";

/**
 * @title Impersonation Attack
 * @dev Test contract to simulate an impersonation attack.
 * https://blog.openzeppelin.com/arbitrary-address-spoofing-vulnerability-erc2771context-multicall-public-disclosure
 */
contract ImpersonationAttack {
    // ======
    // Errors
    // ======

    error ImpersonationAttackFailed();

    // =======
    // Storage
    // =======

    IReflexDispatcher public dispatcher;
    IReflexBatch public batchEndpoint;
    IReflexModule public singleModuleEndpoint;

    // ===========
    // Constructor
    // ===========

    constructor(IReflexDispatcher dispatcher_, IReflexBatch batchEndpoint_, IReflexModule singleModuleEndpoint_) {
        dispatcher = dispatcher_;
        batchEndpoint = batchEndpoint_;
        singleModuleEndpoint = singleModuleEndpoint_;
    }

    // ==========
    // Test stubs
    // ==========

    function attackRecursiveBatch() external {
        // Relies on a combination of batch execution and control over the address of the message sender.
        // batchEndpoint.performBatchCall(actions_);
        // Can this become malicious if the batch endpoint is called recursively?
        // Considering the `performBatchCall` can be called recursively.
        // IReflexBatch.BatchAction[] memory innerActions = new IReflexBatch.BatchAction[](1);
        // innerActions[0] = IReflexBatch.BatchAction({
        //     allowFailure: false,
        //     endpointAddress: address(singleModuleEndpoint),
        //     callData: abi.encodeCall(ImplementationState.setImplementationState0, (message_))
        // });
        // IReflexBatch.BatchAction[] memory outerActions = new IReflexBatch.BatchAction[](1);
        // outerActions[0] = IReflexBatch.BatchAction({
        //     allowFailure: false,
        //     endpointAddress: address(batchEndpoint),
        //     callData: abi.encodeCall(batchEndpoint.performBatchCall, (innerActions))
        // });
    }

    // function performBatchCall(BatchAction[] calldata actions_) public virtual reentrancyAllowed {
    //     address messageSender = _unpackMessageSender();
    //     uint256 actionsLength = actions_.length;

    //     _beforeBatchCall(messageSender);

    //     for (uint256 i = 0; i < actionsLength; ) {
    //         BatchAction calldata action = actions_[i];

    //         (bool success, bytes memory result) = _performBatchAction(action, messageSender);

    //         if (!(success || action.allowFailure)) _revertBytes(result);

    //         unchecked {
    //             ++i;
    //         }
    //     }

    //     _afterBatchCall(messageSender);
    // }

    // /**
    //  * @inheritdoc IReflexBatch
    //  */
    // function simulateBatchCall(BatchAction[] calldata actions_) public virtual reentrancyAllowed {
    //     address messageSender = _unpackMessageSender();
    //     uint256 actionsLength = actions_.length;

    //     _beforeBatchCall(messageSender);

    //     BatchActionResponse[] memory simulation = new BatchActionResponse[](actions_.length);

    //     for (uint256 i = 0; i < actionsLength; ) {
    //         BatchAction calldata action = actions_[i];

    //         (bool success, bytes memory result) = _performBatchAction(action, messageSender);

    //         simulation[i] = BatchActionResponse({success: success, result: result});

    //         unchecked {
    //             ++i;
    //         }
    //     }

    //     revert BatchSimulation(simulation);
    // }
}
