// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

/**
 * @title Proxy
 * @dev Proxies are non-upgradeable stub contracts that have two jobs:
 * - Forward method calls from external users to the dispatcher.
 * - Receive method calls from the dispatcher and log events as instructed
 * @dev Execution takes place within the dispatcher storage context, not the proxy's.
 * @dev Non-upgradeable
 */
contract Proxy {
    // =======
    // Storage
    // =======

    address internal immutable _deployer;

    // ===========
    // Constructor
    // ===========

    constructor() payable {
        _deployer = msg.sender;
    }

    // ================
    // Public functions
    // ================

    // TODO: add test for log emittance (log0, log1, log2, log3, log4, test edge case)

    // solhint-disable-next-line no-complex-fallback
    fallback() external payable {
        address deployer_ = _deployer;

        // If the caller is the deployer, instead of re-enter - issue a log message.
        if (msg.sender == deployer_) {
            // Calldata: [number of topics as uint8 (1 byte)][topic #i (32 bytes)]{0,4}[extra log data (N bytes)]
            assembly {
                // We take full control of memory in this inline assembly block because it will not return to
                // Solidity code. We overwrite the Solidity scratch pad at memory position 0.
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
                    log0(0x20, sub(calldatasize(), 0x01))
                }
                case 1 {
                    // 1 Topic
                    // log1(memory[offset:offset+len], topic0)
                    log1(0x40, sub(calldatasize(), 0x21), mload(0x20))
                }
                case 2 {
                    // 2 Topics
                    // log2(memory[offset:offset+len], topic0, topic1)
                    log2(
                        0x60,
                        sub(calldatasize(), 0x41),
                        mload(0x20),
                        mload(0x40)
                    )
                }
                case 3 {
                    // 3 Topics
                    // log3(memory[offset:offset+len], topic0, topic1, topic2)
                    log3(
                        0x80,
                        sub(calldatasize(), 0x61),
                        mload(0x20),
                        mload(0x40),
                        mload(0x60)
                    )
                }
                case 4 {
                    // 4 Topics
                    // log4(memory[offset:offset+len], topic0, topic1, topic2, topic3)
                    log4(
                        0xA0,
                        sub(calldatasize(), 0x81),
                        mload(0x20),
                        mload(0x40),
                        mload(0x60),
                        mload(0x80)
                    )
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
            // Calldata: [calldata (N bytes)]
            assembly {
                // TODO: optimize using fallback, potentially just use 24, not 28

                // We take full control of memory in this inline assembly block because it will not return to Solidity code.
                // We overwrite the Solidity scratch pad at memory position 0 with the `dispatch()` function signature,
                // occuping the first 4 bytes.
                mstore(
                    0,
                    0xe9c4a3ac00000000000000000000000000000000000000000000000000000000
                )

                // Copy msg.data into memory, starting at position `4`.
                calldatacopy(0x04, 0, calldatasize())

                // We store the address of the `msg.sender` at location `4 + calldatasize()`.
                mstore(add(0x04, calldatasize()), shl(0x60, caller()))

                // Call so that execution happens within the main context.
                // Out and outsize are 0 because we don't know the size yet.
                // Calldata: [dispatch() selector (4 bytes)][calldata (N bytes)][msg.sender (20 bytes)]
                let result := call(
                    gas(),
                    deployer_,
                    0,
                    0,
                    // 0x18 is the length of the selector + an address, 24 bytes, in hex.
                    add(0x18, calldatasize()),
                    0,
                    0
                )

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
