// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexBase} from "./interfaces/IReflexBase.sol";

// Sources
import {ReflexProxy} from "./ReflexProxy.sol";
import {ReflexState} from "./ReflexState.sol";

/**
 * @title Reflex Base
 *
 * @dev Upgradeable, extendable.
 */
abstract contract ReflexBase is IReflexBase, ReflexState {
    // =========
    // Modifiers
    // =========

    /**
     * @dev Explicitly tag a method as being allowed to be reentered.
     */
    modifier reentrancyAllowed() virtual {
        _;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant` function is not supported.
     */
    modifier nonReentrant() virtual {
        // On the first call to `nonReentrant`, _status will be `_REENTRANCY_LOCK_UNLOCKED`.
        if (_reentrancyLock != _REENTRANCY_LOCK_UNLOCKED) revert Reentrancy();

        // Any calls to `nonReentrant` after this point will fail.
        _reentrancyLock = _REENTRANCY_LOCK_LOCKED;

        _;

        // By storing the original value once again, a refund is triggered (see https://eips.ethereum.org/EIPS/eip-2200).
        _reentrancyLock = _REENTRANCY_LOCK_UNLOCKED;
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev Create or return proxy by module id.
     * @param moduleId_ Module id.
     * @param moduleType_ Module type.
     * @param moduleImplementation_ Module implementation.
     * @return address Proxy address.
     */
    function _createProxy(
        uint32 moduleId_,
        uint16 moduleType_,
        address moduleImplementation_
    ) internal virtual returns (address) {
        if (moduleId_ == 0) revert InvalidModuleId();
        if (moduleType_ != _MODULE_TYPE_SINGLE_PROXY && moduleType_ != _MODULE_TYPE_MULTI_PROXY)
            revert InvalidModuleType();

        if (_proxies[moduleId_] != address(0)) return _proxies[moduleId_];

        address proxyAddress = address(new ReflexProxy(moduleId_));

        if (moduleType_ == _MODULE_TYPE_SINGLE_PROXY) _proxies[moduleId_] = proxyAddress;

        _relations[proxyAddress] = TrustRelation({
            moduleId: moduleId_,
            moduleType: moduleType_,
            moduleImplementation: moduleImplementation_
        });

        emit ProxyCreated(proxyAddress);

        return proxyAddress;
    }

    /**
     * @dev Perform delegatecall to trusted internal module.
     * @param moduleId_ Module id.
     * @param input_ Input data.
     * @return bytes Call result.
     */
    function _callInternalModule(uint32 moduleId_, bytes memory input_) internal returns (bytes memory) {
        (bool success, bytes memory result) = _modules[moduleId_].delegatecall(input_);

        if (!success) _revertBytes(result);

        return result;
    }

    /**
     * @dev Unpack message sender from calldata.
     * @return messageSender_ Message sender.
     */
    function _unpackMessageSender() internal pure virtual returns (address messageSender_) {
        // Calldata: [original calldata (N bytes)][original msg.sender (20 bytes)][proxy address (20 bytes)]
        /// @solidity memory-safe-assembly
        assembly {
            messageSender_ := shr(0x60, calldataload(sub(calldatasize(), 40)))
        }
    }

    /**
     * @dev Unpack proxy address from calldata.
     * @return proxyAddress_ Proxy address.
     */
    function _unpackProxyAddress() internal pure virtual returns (address proxyAddress_) {
        // Calldata: [original calldata (N bytes)][original msg.sender (20 bytes)][proxy address (20 bytes)]
        /// @solidity memory-safe-assembly
        assembly {
            proxyAddress_ := shr(0x60, calldataload(sub(calldatasize(), 20)))
        }
    }

    /**
     * @dev Unpack trailing parameters from calldata.
     * @return messageSender_ Message sender.
     * @return proxyAddress_ Proxy address.
     */
    function _unpackTrailingParameters() internal pure virtual returns (address messageSender_, address proxyAddress_) {
        /// @solidity memory-safe-assembly
        assembly {
            // Calldata: [original calldata (N bytes)][original msg.sender (20 bytes)][proxy address (20 bytes)]
            messageSender_ := shr(0x60, calldataload(sub(calldatasize(), 40)))
            proxyAddress_ := shr(0x60, calldataload(sub(calldatasize(), 20)))
        }
    }

    /**
     * @dev Revert with error message.
     * @param errorMessage_ Error message.
     */
    function _revertBytes(bytes memory errorMessage_) internal pure {
        /// @solidity memory-safe-assembly
        if (errorMessage_.length > 0) {
            assembly {
                revert(add(32, errorMessage_), mload(errorMessage_))
            }
        }

        revert EmptyError();
    }
}
