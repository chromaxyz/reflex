// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBase} from "./interfaces/IBase.sol";

// Sources
import {BaseProxy} from "./BaseProxy.sol";
import {BaseState} from "./BaseState.sol";

/**
 * @title Base
 * @dev Upgradeable, extendable.
 */
abstract contract Base is IBase, BaseState {
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
     */
    function _createProxy(uint32 moduleId_, uint16 moduleType_) internal virtual returns (address) {
        if (moduleId_ == 0) revert InvalidModuleId();
        if (moduleType_ == 0 || moduleType_ > _MODULE_TYPE_INTERNAL) revert InvalidModuleType();
        if (moduleType_ == _MODULE_TYPE_INTERNAL) revert InternalModule();

        if (_proxies[moduleId_] != address(0)) return _proxies[moduleId_];

        address proxyAddress = address(new BaseProxy(moduleId_));

        if (moduleType_ == _MODULE_TYPE_SINGLE_PROXY) _proxies[moduleId_] = proxyAddress;

        _relations[proxyAddress].moduleId = moduleId_;
        _relations[proxyAddress].moduleType = moduleType_;
        _relations[proxyAddress].moduleImplementation = address(0);

        emit ProxyCreated(proxyAddress);

        return proxyAddress;
    }

    /**
     * @dev Perform delegatecall to trusted internal module.
     * @param moduleId_ Module id.
     * @param input_ Input data.
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
        if (errorMessage_.length > 0) {
            assembly {
                revert(add(32, errorMessage_), mload(errorMessage_))
            }
        }

        revert EmptyError();
    }
}
