// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBaseDispatcher} from "../interfaces/IBaseDispatcher.sol";
import {IProxy} from "../interfaces/IProxy.sol";

/**
 * @title Proxy
 * @dev Proxies are non-upgradeable stub contracts that have two jobs:
 * - Forward method calls from external users to the dispatcher.
 * - Receive method calls from the dispatcher and log events as instructed
 * @dev Execution takes place within the dispatcher storage context, not the proxy's.
 * @dev Non-upgradeable.
 */
contract Proxy is IProxy {
    // =========
    // Constants
    // =========

    /**
     * @dev EIP-1967 compatible storage slot with the admin of the contract.
     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1.
     */
    bytes32 internal constant _ADMIN_SLOT =
        0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
     * @dev EIP-1967 compatible storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1.
     */
    bytes32 internal constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    // ==========
    // Immutables
    // ==========

    /**
     * @dev Deployer address.
     */
    address internal immutable _deployer;

    // =========
    // Modifiers
    // =========

    modifier onlyDeployer() {
        if (msg.sender == _deployer) {
            _;
        } else {
            _fallback();
        }
    }

    // ===========
    // Constructor
    // ===========

    /**
     * @param implementation_ Implementation address.
     */
    constructor(address implementation_) payable {
        _deployer = msg.sender;

        assembly {
            sstore(_IMPLEMENTATION_SLOT, implementation_)
        }

        emit Upgraded(implementation_);
    }

    // ======================
    // Permissioned functions
    // ======================

    /**
     * @dev Allow `_deployer` to set the implementation.
     * The implementation is not used, it exists to simplify integration.
     *
     * @param implementation_ Implementation address.
     */
    function setImplementation(
        address implementation_
    ) external override onlyDeployer {
        // TODO: what are the security implications?

        assembly {
            sstore(_IMPLEMENTATION_SLOT, implementation_)
        }

        emit Upgraded(implementation_);
    }

    function implementation() external view returns (address) {
        return
            IBaseDispatcher(_deployer)
                .proxyAddressToTrustRelation(address(this))
                .moduleImplementation;
    }

    // ==================
    // Fallback functions
    // ==================

    /**
     * @dev Will run if no other function in the contract matches the call data.
     */
    fallback() external payable {
        _fallback();
    }

    // ==================
    // Internal functions
    // ==================

    /**
     * @dev Fallback function that delegates calls to the address returned by `_IMPLEMENTATION_SLOT` through the `Dispatcher`.
     * Note: Will run if no other function in the contract matches the call data.
     */
    function _fallback() internal {
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
                // We take full control of memory in this inline assembly block because it will not return to Solidity code.
                // We overwrite the Solidity scratch pad at memory position 0 with the `dispatch()` function signature,
                // occuping the first 4 bytes.
                mstore(
                    0x00,
                    0xe9c4a3ac00000000000000000000000000000000000000000000000000000000
                )

                // Copy msg.data into memory, starting at position `4`.
                calldatacopy(0x04, 0x00, calldatasize())

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
