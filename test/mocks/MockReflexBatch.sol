// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexBatch} from "../../src/periphery/ReflexBatch.sol";

// Fixtures
import {MockHarness} from "../fixtures/MockHarness.sol";

// Mocks
import {MockReflexModule} from "./MockReflexModule.sol";

/**
 * @title Mock Reflex Batch
 */
contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {
    // =======
    // Storage
    // =======

    /**
     * @dev `bytes32(uint256(keccak256("_BEFORE_BATCH_CALL_COUNTER_SLOT")) - 1)`
     */
    bytes32 internal constant _BEFORE_BATCH_CALL_COUNTER_SLOT =
        0x1341c5d22aaf5144e19b621a10c11ed727e6c461de3386254a323deb804b3177;

    /**
     * @dev `bytes32(uint256(keccak256("_AFTER_BATCH_CALL_COUNTER_SLOT")) - 1)`
     */
    bytes32 internal constant _AFTER_BATCH_CALL_COUNTER_SLOT =
        0x275df4c7315c3d7a3ff703ad0c15eafa230b4ec1a5793f54ae5d2e4586513a64;

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
}
