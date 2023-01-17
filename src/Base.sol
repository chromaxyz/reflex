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
    // Constants
    // =========

    /// @dev `bytes4(keccak256("DeploymentFailed()"))`.
    uint256 private constant _DEPLOYMENT_FAILED_ERROR_SELECTOR = 0x30116425;

    // =========
    // Modifiers
    // =========

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

        _relations[proxyAddress] = TrustRelation({
            moduleId: moduleId_,
            moduleType: moduleType_,
            moduleImplementation: address(0) // TODO: is this line necessary?
        });

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

    // ===============
    // Private methods
    // ===============

    function _clone(address implementation_, bytes memory data, bytes32 salt) private returns (address instance_) {
        // TODO: no need for payable

        assembly {
            // Compute the boundaries of the data and cache the memory slots around it.
            let memoryBeforeCacheChunk3 := mload(sub(data, 0x60))
            let memoryBeforeCacheChunk2 := mload(sub(data, 0x40))
            let memoryBeforeCacheChunk1 := mload(sub(data, 0x20))
            let dataLength := mload(data)
            let dataEnd := add(add(data, 0x20), dataLength)
            let memoryAfterCacheChunk1 := mload(dataEnd)

            // +2 bytes for telling how much data there is appended to the call.
            let extraLength := add(dataLength, 2)

            // Write the bytecode before the data.
            mstore(data, 0x5af43d3d93803e606057fd5bf3)
            // Write the address of the implementation.
            mstore(sub(data, 0x0d), implementation_)
            // Write the rest of the bytecode.
            mstore(sub(data, 0x21), or(shl(0x48, extraLength), 0x593da1005b363d3d373d3d3d3d610000806062363936013d73))
            // `keccak256("ReceiveETH(uint256)")`
            mstore(sub(data, 0x3a), 0x9e4ac34f21c619cefc926c8bd93b54bf5a39c7ab2127a895af1cc0691d7e3dff)
            mstore(sub(data, 0x5a), or(shl(0x78, add(extraLength, 0x62)), 0x6100003d81600a3d39f336602c57343d527f))
            mstore(dataEnd, shl(0xf0, extraLength))

            // Create the instance.
            instance_ := create2(0, sub(data, 0x4c), add(extraLength, 0x6c), salt)

            // If `instance` is zero, revert.
            if iszero(instance_) {
                // Store the function selector of `DeploymentFailed()`.
                mstore(0x00, _DEPLOYMENT_FAILED_ERROR_SELECTOR)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }

            // Restore the overwritten memory surrounding `data`.
            mstore(dataEnd, memoryAfterCacheChunk1)
            mstore(data, dataLength)
            mstore(sub(data, 0x20), memoryBeforeCacheChunk1)
            mstore(sub(data, 0x40), memoryBeforeCacheChunk2)
            mstore(sub(data, 0x60), memoryBeforeCacheChunk3)
        }
    }
}
