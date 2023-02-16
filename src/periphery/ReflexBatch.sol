// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBatch} from "./interfaces/IReflexBatch.sol";
import {IReflexModule} from "../interfaces/IReflexModule.sol";

// Sources
import {ReflexModule} from "../ReflexModule.sol";

/**
 * @title Reflex Batch
 *
 * @dev Execution takes place within the Dispatcher's storage context.
 * @dev Upgradeable, extendable.
 */
abstract contract ReflexBatch is IReflexBatch, ReflexModule {
    // ==============
    // Public methods
    // ==============

    /**
     * @notice Perform a batch call to interact with multiple modules in a single transaction.
     * @param actions List of
     */
    function performBatchCall(BatchAction[] calldata actions, bool simulate) external virtual reentrancyAllowed {
        // TODO: remove simulation mode?
        // TODO: inline proxy address?
        // TODO: optimize encodePacked?

        address messageSender = _unpackMessageSender();

        BatchActionResponse[] memory simulation;

        if (simulate) simulation = new BatchActionResponse[](actions.length);

        for (uint256 i = 0; i < actions.length; ) {
            BatchAction calldata action = actions[i];

            address proxyAddress = action.proxyAddress;

            uint32 moduleId_ = _relations[proxyAddress].moduleId;

            if (moduleId_ == 0) revert InvalidModuleId();

            if (_relations[proxyAddress].moduleType == _MODULE_TYPE_INTERNAL) revert InvalidModuleType();

            address moduleImplementation_ = _relations[proxyAddress].moduleImplementation;

            if (moduleImplementation_ == address(0)) moduleImplementation_ = _modules[moduleId_];

            if (moduleImplementation_ == address(0)) revert ModuleNonexistent(moduleId_);

            (bool success, bytes memory result) = moduleImplementation_.delegatecall(
                abi.encodePacked(action.data, uint160(messageSender), uint160(proxyAddress))
            );

            if (simulate) {
                simulation[i] = BatchActionResponse({success: success, result: result});
            } else if (!(success || action.allowError)) {
                _revertBytes(result);
            }

            unchecked {
                ++i;
            }
        }

        if (simulate) revert BatchSimulation(simulation);
    }
}
