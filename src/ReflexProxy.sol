// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IReflexProxy} from "./interfaces/IReflexProxy.sol";

/**
 * @title Reflex Proxy
 * @dev Execution takes place within the Dispatcher's storage context, not the proxy's.
 * @dev Non-upgradeable, extendable.
 */
contract ReflexProxy is IReflexProxy {
    // =========
    // Constants
    // =========

    /**
     * @dev `bytes4(keccak256("moduleIdToModuleImplementation(uint256)"))`.
     */
    bytes4 private constant _MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR = 0xb550ebbd;

    // ==========
    // Immutables
    // ==========

    /**
     * @dev Same as the implementations' module id.
     */
    uint256 internal immutable _moduleId;

    /**
     * @dev Deployer address.
     */
    address internal immutable _deployer;

    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleId_ Same as the implementations' module id.
     */
    constructor(uint256 moduleId_) {
        if (moduleId_ == 0) revert InvalidModuleId();

        _moduleId = moduleId_;
        _deployer = msg.sender;
    }

    // ============
    // View methods
    // ============

    /**
     * @notice Returns implementation address by resolving through the `Dispatcher`.
     * @dev To prevent selector clashing avoid using the `implementation()` selector inside of modules.
     * @return address Implementation address or zero address if unresolved.
     */
    function implementation() external view virtual override returns (address) {
        (bool success, bytes memory response) = _deployer.staticcall(
            abi.encodeWithSelector(_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR, _moduleId)
        );

        if (success) {
            return abi.decode(response, (address));
        } else {
            return address(0);
        }
    }

    /**
     * @dev Sentinel DELEGATECALL opcode to nudge Etherscan to recognize this as being a proxy.
     * @dev Function selector clashing is mitigated by falling through to the fallback.
     */
    function sentinel() external virtual override {
        // TODO: replace with better solution, preferably permanent.

        if (msg.sender == address(0)) {
            // This branch is expected to never be executed as `msg.sender` can never be 0.
            // If this branch ever were to be executed it is expected to be harmless and have no side-effects.
            // A `delegatecall` to non-contract address 0 yields `true` and is ignored.
            assembly {
                // Ignore return value.
                pop(delegatecall(gas(), 0x00, 0, 0, 0, 0))
            }
        } else {
            // If the function selector clashes fall through to the fallback.
            _fallback();
        }
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev Will run if no other function in the contract matches the call data.
     */
    function _fallback() internal virtual {
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
                    log2(0x60, sub(calldatasize(), 0x41), mload(0x20), mload(0x40))
                }
                case 3 {
                    // 3 Topics
                    // log3(memory[offset:offset+len], topic0, topic1, topic2)
                    log3(0x80, sub(calldatasize(), 0x61), mload(0x20), mload(0x40), mload(0x60))
                }
                case 4 {
                    // 4 Topics
                    // log4(memory[offset:offset+len], topic0, topic1, topic2, topic3)
                    log4(0xA0, sub(calldatasize(), 0x81), mload(0x20), mload(0x40), mload(0x60), mload(0x80))
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
                    // bytes4(keccak256("dispatch()")) padded to 32 bytes.
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

    // ==================
    // Fallback functions
    // ==================

    /**
     * @dev Will run if no other function in the contract matches the call data.
     */
    fallback() external virtual {
        _fallback();
    }
}
