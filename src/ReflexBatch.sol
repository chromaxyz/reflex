// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBatch} from "./interfaces/IReflexBatch.sol";
import {IReflexModule} from "./interfaces/IReflexModule.sol";

// Sources
import {ReflexModule} from "./ReflexModule.sol";

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
     * @notice Perform a `staticcall` to an arbitrary address with an arbitrary payload.
     * @param contractAddress Address of the contract to call.
     * @param payload Encoded call payload.
     * @return result Encoded return data.
     * @dev Intended to be used in static-called batches, to e.g. provide detailed information about the impacts of the simulated operation.
     */
    function performStaticCall(address contractAddress, bytes memory payload) external view returns (bytes memory) {
        (bool success, bytes memory result) = contractAddress.staticcall(payload);

        if (!success) _revertBytes(result);

        assembly {
            return(add(32, result), mload(result))
        }
    }

    /**
     * @notice Perform a batch call to interact with multiple modules in a single transaction.
     * @param items List of
     */
    function performBatchCall(BatchItem[] calldata items, bool simulate) external virtual {
        // TODO: remove simulation mode?
        // TODO: make note that if using this method you don't pay for the call overhead (proxy -> dispatcher -> module) but only for (module -> module)
        // this is possible due to the shared state layout and authorizing happening on the call ot performBatchCall.

        address messageSender = _unpackMessageSender();

        BatchItemResponse[] memory simulation;

        if (simulate) simulation = new BatchItemResponse[](items.length);

        for (uint256 i = 0; i < items.length; ) {
            BatchItem calldata item = items[i];

            address proxyAddress = item.proxyAddress;

            uint32 moduleId_ = _relations[proxyAddress].moduleId;

            if (moduleId_ == 0) revert InvalidModuleId();

            uint16 moduleType_ = _relations[proxyAddress].moduleType;

            if (moduleType_ == _MODULE_TYPE_INTERNAL) revert InvalidModuleType();

            address moduleImplementation_ = _relations[proxyAddress].moduleImplementation;

            if (moduleImplementation_ == address(0)) moduleImplementation_ = _modules[moduleId_];

            if (moduleImplementation_ == address(0)) revert ModuleNonexistent(moduleId_);

            // TODO: optimize this to lower memory expansion cost?

            (bool success, bytes memory result) = moduleImplementation_.delegatecall(
                abi.encodePacked(item.data, uint160(messageSender), uint160(proxyAddress))
            );

            if (simulate) {
                simulation[i] = BatchItemResponse({success: success, result: result});
            } else if (!(success || item.allowError)) {
                _revertBytes(result);
            }

            unchecked {
                ++i;
            }
        }

        if (simulate) revert BatchSimulation(simulation);
    }
}
