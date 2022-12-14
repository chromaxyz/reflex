// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {IBase} from "../interfaces/IBase.sol";

// Internals
import {Proxy} from "./Proxy.sol";

// Sources
import {BaseState} from "../BaseState.sol";

/**
 * @title Base
 * @dev Extendable
 */
abstract contract Base is IBase, BaseState {
    // ==================
    // Internal functions
    // ==================

    /**
     * @dev Create or return proxy by module id.
     * @param moduleId_ Module id.
     */
    function _createProxy(
        uint32 moduleId_,
        uint16 moduleType_
    ) internal virtual returns (address) {
        if (moduleId_ == 0) revert InvalidModuleId();
        if (moduleType_ == 0 || moduleType_ > _MODULE_TYPE_INTERNAL)
            revert InvalidModuleType();

        if (moduleType_ == _MODULE_TYPE_INTERNAL) revert InternalModule();

        if (_proxies[moduleId_] != address(0)) return _proxies[moduleId_];

        address proxyAddress = address(new Proxy());

        if (
            moduleType_ == _MODULE_TYPE_SINGLE_PROXY ||
            moduleType_ == _MODULE_TYPE_MULTI_PROXY
        ) _proxies[moduleId_] = proxyAddress;

        _trusts[proxyAddress].moduleId = moduleId_;

        return proxyAddress;
    }

    // TODO: write test for this and evaluate its use

    /**
     * @dev Call internal module.
     * @param moduleId_ Module id.
     * @param input_ Input data.
     */
    function _callInternalModule(
        uint32 moduleId_,
        bytes memory input_
    ) internal returns (bytes memory) {
        (bool success, bytes memory result) = _modules[moduleId_].delegatecall(
            input_
        );

        if (!success) _revertBytes(result);

        return result;
    }

    /**
     * @dev Unpack message sender from calldata.
     */
    function _unpackMessageSender()
        internal
        pure
        virtual
        returns (address messageSender)
    {
        // Calldata: [original calldata (N bytes)][original msg.sender (20 bytes)][proxy address (20 bytes)]
        assembly {
            messageSender := shr(0x60, calldataload(sub(calldatasize(), 0x28)))
        }
    }

    /**
     * @dev Unpack message sender and parameters from calldata.
     */
    function _unpackParameters()
        internal
        pure
        virtual
        returns (address messageSender, address proxyAddress)
    {
        // Calldata: [original calldata (N bytes)][original msg.sender (20 bytes)][proxy address (20 bytes)]
        assembly {
            messageSender := shr(0x60, calldataload(sub(calldatasize(), 0x28)))
            proxyAddress := shr(0x60, calldataload(sub(calldatasize(), 0x14)))
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
