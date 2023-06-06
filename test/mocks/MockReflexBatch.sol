// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexBase} from "../../src/ReflexBase.sol";
import {ReflexBatch} from "../../src/periphery/ReflexBatch.sol";

// Mocks
import {MockReflexModule} from "./MockReflexModule.sol";

/**
 * @title Mock Reflex Batch
 */
contract MockReflexBatch is ReflexBatch, MockReflexModule {
    // =======
    // Storage
    // =======

    /**
     * @dev `bytes32(uint256(keccak256("before.batch.call.counter")) - 1))`
     */
    bytes32 internal constant _BEFORE_BATCH_CALL_COUNTER_SLOT =
        0x3c5e0ffea8513071715642321743602785a5c6c585e0f916891665f4ca4543eb;

    /**
     * @dev `bytes32(uint256(keccak256("after.batch.call.counter")) - 1))`
     */
    bytes32 internal constant _AFTER_BATCH_CALL_COUNTER_SLOT =
        0x204a962903d57234ad549571efe3fcf39c3904b5cb380e97ec4f91a693441f7b;

    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) MockReflexModule(moduleSettings_) {}

    // ==========
    // Test stubs
    // ==========

    function beforeBatchCallCounter() public view returns (uint256 n_) {
        n_ = _getCounter(_BEFORE_BATCH_CALL_COUNTER_SLOT);
    }

    function afterBatchCallCounter() public view returns (uint256 n_) {
        n_ = _getCounter(_AFTER_BATCH_CALL_COUNTER_SLOT);
    }

    function _beforeBatchCall(address x_) internal override {
        _increaseCounter(_BEFORE_BATCH_CALL_COUNTER_SLOT);

        // Force coverage to flag this branch as covered.
        super._beforeBatchCall(x_);
    }

    function _afterBatchCall(address x_) internal override {
        _increaseCounter(_AFTER_BATCH_CALL_COUNTER_SLOT);

        // Force coverage to flag this branch as covered.
        super._afterBatchCall(x_);
    }

    // =========
    // Overrides
    // =========

    function _getEndpointCreationCode(
        uint32 moduleId_
    ) internal virtual override(ReflexBase, MockReflexModule) returns (bytes memory) {
        return super._getEndpointCreationCode(moduleId_);
    }
}
