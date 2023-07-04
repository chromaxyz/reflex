// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Sources
import {ReflexDispatcher} from "../../src/ReflexDispatcher.sol";

// Fixtures
import {MockHarness} from "../fixtures/MockHarness.sol";

// Mocks
import {MockReflexEndpoint} from "./MockReflexEndpoint.sol";

/**
 * @title Mock Reflex Dispatcher
 */
contract MockReflexDispatcher is MockHarness, ReflexDispatcher {
    // =========
    // Constants
    // =========

    /**
     * @dev `bytes32(uint256(keccak256("_GET_DISPATCHER_ENDPOINT_CREATION_CODE_COUNTER_SLOT")) - 1)`
     */
    bytes32 internal constant _GET_DISPATCHER_ENDPOINT_CREATION_CODE_COUNTER_SLOT =
        0x76001c65d940acd2be5e8ba1ba08132fef4f00537e2320367f9558f00eec3bde;

    // ===========
    // Constructor
    // ===========

    constructor(address owner_, address installerModule_) ReflexDispatcher(owner_, installerModule_) {}

    // ==========
    // Test stubs
    // ==========

    function setModuleToImplementation(uint32 moduleId_, address moduleImplementation_) public {
        _REFLEX_STORAGE().modules[moduleId_] = moduleImplementation_;
    }

    function getDispatcherEndpointCreationCodeCounter() public view returns (uint256 n_) {
        n_ = _getCounter(_GET_DISPATCHER_ENDPOINT_CREATION_CODE_COUNTER_SLOT);
    }

    // =========
    // Overrides
    // =========

    function _getEndpointCreationCode(
        uint32 moduleId_
    ) internal virtual override returns (bytes memory endpointCreationCode_) {
        _increaseCounter(_GET_DISPATCHER_ENDPOINT_CREATION_CODE_COUNTER_SLOT);

        // Force coverage to flag this branch as covered.
        return super._getEndpointCreationCode(moduleId_);
    }

    // =========
    // Utilities
    // =========

    function _getCounter(bytes32 slot_) internal view returns (uint256 n_) {
        assembly ("memory-safe") {
            n_ := sload(slot_)
        }
    }

    function _increaseCounter(bytes32 slot_) internal {
        assembly ("memory-safe") {
            sstore(slot_, add(sload(slot_), 1))
        }
    }
}
