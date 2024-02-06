// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexEndpoint} from "./interfaces/IReflexEndpoint.sol";

/**
 * @title Reflex Endpoint
 *
 * @dev Execution takes place within the Dispatcher's storage context, not the endpoints'.
 * @dev Non-upgradeable, extendable.
 */
contract ReflexEndpoint is IReflexEndpoint {
    // ==========
    // Immutables
    // ==========

    /**
     * @notice Address of the `Dispatcher`, the deployer of this contract.
     */
    address public immutable DISPATCHER;

    // ===========
    // Constructor
    // ===========

    constructor() {
        // Register the deployer to perform logic on calls originating from the deployer.
        DISPATCHER = msg.sender;
    }

    // ================
    // Fallback methods
    // ================

    /**
     * @dev Forward call to `Dispatcher` if the caller is not the deployer.
     * If the caller is the deployer, issue a log message in the `Endpoint` context.
     */
    // solhint-disable-next-line payable-fallback, no-complex-fallback
    fallback() external virtual {
        // It is not possible to access immutable variables from the assembly block.
        address dispatcher = DISPATCHER;

        // If the caller is the deployer, instead of re-enter - issue a log message.
        if (msg.sender == dispatcher) {
            // We take full control of memory because it will not return to Solidity code.
            // Calldata: [number of topics as uint8 (1 byte)][topic #i (32 bytes)]{0,4}[extra log data (N bytes)]
            assembly {
                // Overwrite the first 32 bytes with 0 at memory position `0` to
                // prevent any unintended data corruption or leakage.
                mstore(0x00, 0x00)

                // Copy all transaction data into memory starting at location `31`.
                calldatacopy(0x1F, 0x00, calldatasize())

                // Since the number of topics only occupy 1 byte of the calldata, we store the calldata starting at
                // location `31` so the number of topics is stored in the first 32 byte chuck of memory and we can
                // leverage `mload` to get the corresponding number.
                switch mload(0x00)
                case 0 {
                    // 0 Topics
                    // log0(memory[offset:offset+len])
                    log0(0x20, sub(calldatasize(), 1))
                }
                case 1 {
                    // 1 Topic
                    // log1(memory[offset:offset+len], topic0)
                    log1(0x40, sub(calldatasize(), 33), mload(0x20))
                }
                case 2 {
                    // 2 Topics
                    // log2(memory[offset:offset+len], topic0, topic1)
                    log2(0x60, sub(calldatasize(), 65), mload(0x20), mload(0x40))
                }
                case 3 {
                    // 3 Topics
                    // log3(memory[offset:offset+len], topic0, topic1, topic2)
                    log3(0x80, sub(calldatasize(), 97), mload(0x20), mload(0x40), mload(0x60))
                }
                case 4 {
                    // 4 Topics
                    // log4(memory[offset:offset+len], topic0, topic1, topic2, topic3)
                    log4(0xA0, sub(calldatasize(), 129), mload(0x20), mload(0x40), mload(0x60), mload(0x80))
                }
                // The EVM doesn't support more than 4 topics, so in case the number of topics is not within the
                // range {0..4} something probably went wrong and we should revert.
                default {
                    revert(0, 0)
                }

                // Return 0
                return(0, 0)
            }
        } else {
            // We take full control of memory because it will not return to Solidity code.
            // Calldata: [calldata (N bytes)]
            assembly {
                // Copy msg.data into memory, starting at position `0`.
                calldatacopy(0x00, 0x00, calldatasize())

                // Append `msg.sender` with leading 12 bytes of padding removed to copied `msg.data` in memory.
                mstore(calldatasize(), shl(96, caller()))

                // Call so that execution happens within the `Dispatcher` context.
                // Out and outsize are 0 because we don't know the size yet.
                // Calldata: [calldata (N bytes)][msg.sender (20 bytes)]
                let result := call(gas(), dispatcher, 0, 0, add(calldatasize(), 20), 0, 0)

                // Copy the returned data into memory, starting at position `0`.
                returndatacopy(0x00, 0x00, returndatasize())

                switch result
                case 0 {
                    // If result is 0, revert.
                    revert(0, returndatasize())
                }
                default {
                    return(0, returndatasize())
                }
            }
        }
    }
}
