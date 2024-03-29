// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexModule} from "./interfaces/IReflexModule.sol";

// Sources
import {ReflexEndpoint} from "./ReflexEndpoint.sol";
import {ReflexStorage} from "./ReflexStorage.sol";

/**
 * @title Reflex Module
 *
 * @dev Execution takes place within the Dispatcher's storage context.
 * @dev Upgradeable, extendable.
 */
abstract contract ReflexModule is IReflexModule, ReflexStorage {
    // ==========
    // Immutables
    // ==========

    /**
     * @dev Module id.
     */
    uint32 internal immutable _MODULE_ID;

    /**
     * @dev Module type.
     */
    uint16 internal immutable _MODULE_TYPE;

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
        assembly ("memory-safe") {
            // On the first call to `nonReentrant`, _status will be `_REENTRANCY_GUARD_UNLOCKED`.
            if eq(sload(_REFLEX_STORAGE_REENTRANCY_STATUS_SLOT), _REENTRANCY_GUARD_LOCKED) {
                // Store the function selector of `Reentrancy()`.
                mstore(0x00, 0xab143c06)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }

            // Any calls to `nonReentrant` after this point will fail.
            sstore(_REFLEX_STORAGE_REENTRANCY_STATUS_SLOT, _REENTRANCY_GUARD_LOCKED)
        }

        _;

        assembly ("memory-safe") {
            // By storing the original value once again, a refund is triggered.
            sstore(_REFLEX_STORAGE_REENTRANCY_STATUS_SLOT, _REENTRANCY_GUARD_UNLOCKED)
        }
    }

    /**
     * @dev Prevents a contract from reading itself, directly or indirectly in a `nonReentrant` context.
     * Calling a `nonReadReentrant` function from another `nonReadReentrant` function is not supported.
     */
    modifier nonReadReentrant() virtual {
        assembly ("memory-safe") {
            // On the first call to `nonReentrant`, _status will be `_REENTRANCY_GUARD_UNLOCKED`.
            // Any calls to `nonReadReentrant` after this point will fail.
            if eq(sload(_REFLEX_STORAGE_REENTRANCY_STATUS_SLOT), _REENTRANCY_GUARD_LOCKED) {
                // Store the function selector of `ReadOnlyReentrancy()`.
                mstore(0x00, 0x49ce9485)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }
        }

        _;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() virtual {
        if (_unpackMessageSender() != _REFLEX_STORAGE().owner) revert Unauthorized();

        _;
    }

    // ===========
    // Constructor
    // ===========

    /**
     * @param moduleSettings_ Module settings.
     */
    constructor(ModuleSettings memory moduleSettings_) {
        if (moduleSettings_.moduleId == 0) revert ModuleIdInvalid();
        if (moduleSettings_.moduleType == 0 || moduleSettings_.moduleType > _MODULE_TYPE_INTERNAL)
            revert ModuleTypeInvalid();

        _MODULE_ID = moduleSettings_.moduleId;
        _MODULE_TYPE = moduleSettings_.moduleType;
    }

    // ============
    // View methods
    // ============

    /**
     * @inheritdoc IReflexModule
     */
    function moduleId() public view virtual returns (uint32) {
        return _MODULE_ID;
    }

    /**
     * @inheritdoc IReflexModule
     */
    function moduleType() public view virtual returns (uint16) {
        return _MODULE_TYPE;
    }

    /**
     * @inheritdoc IReflexModule
     */
    function moduleSettings() public view virtual returns (ModuleSettings memory) {
        return ModuleSettings({moduleId: _MODULE_ID, moduleType: _MODULE_TYPE});
    }

    // ================
    // Internal methods
    // ================

    /**
     * @dev Create or return existing endpoint by module id.
     * `Endpoints` are commonly created by the `Installer` upon registering of a module
     * and by multi-module factories upon instance creation.
     * @param moduleId_ Module id.
     * @param moduleType_ Module type.
     * @param moduleImplementation_ Module implementation.
     * @return endpointAddress_ Endpoint address.
     */
    function _createEndpoint(
        uint32 moduleId_,
        uint16 moduleType_,
        address moduleImplementation_
    ) internal virtual returns (address endpointAddress_) {
        // Verify that the `moduleId_` is valid.
        if (moduleId_ == 0) revert ModuleIdInvalid();

        // Only single-endpoint and multi-endpoint modules can create endpoints.
        if (moduleType_ != _MODULE_TYPE_SINGLE_ENDPOINT && moduleType_ != _MODULE_TYPE_MULTI_ENDPOINT)
            revert ModuleTypeInvalid();

        // If endpoint already exists, return it.
        if (_REFLEX_STORAGE().endpoints[moduleId_] != address(0)) return _REFLEX_STORAGE().endpoints[moduleId_];

        // Fetch the endpoint implementation creation code.
        bytes memory endpointCreationCode = _getEndpointCreationCode(moduleId_);

        // Create the endpoint.
        assembly ("memory-safe") {
            endpointAddress_ := create(0, add(endpointCreationCode, 0x20), mload(endpointCreationCode))

            // If the code size of `endpointAddress_` is zero, revert.
            if iszero(extcodesize(endpointAddress_)) {
                // Store the function selector of `EndpointInvalid()`.
                mstore(0x00, 0x0b3b0bd1)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }
        }

        // If single-endpoint, register the endpoint address by module id in the `endpoints` mapping.
        if (moduleType_ == _MODULE_TYPE_SINGLE_ENDPOINT) _REFLEX_STORAGE().endpoints[moduleId_] = endpointAddress_;

        // If single-endpoint or multi-endpoint, register the module id and
        // module implementation in the `relations` mapping.
        // For multi-endpoint modules, the module implementation is `address(0)`.
        // In the `Dispatcher` and `Batch` the multi-endpoint module implementation is resolved to
        // module implementation in the `modules` mapping.
        _REFLEX_STORAGE().relations[endpointAddress_] = TrustRelation({
            moduleId: moduleId_,
            moduleImplementation: moduleImplementation_
        });

        emit EndpointCreated(moduleId_, endpointAddress_);
    }

    /**
     * @dev Perform delegatecall to trusted internal module.
     * @param moduleId_ Module id.
     * @param input_ Input data.
     * @return bytes Call result.
     */
    function _callInternalModule(uint32 moduleId_, bytes memory input_) internal virtual returns (bytes memory) {
        // WARNING: It is assumed that `moduleId_` points to a registered internal module and that it is trusted.
        (bool success, bytes memory result) = _REFLEX_STORAGE().modules[moduleId_].delegatecall(input_);

        if (!success) _revertBytes(result);

        return result;
    }

    /**
     * @dev Unpack message sender from calldata.
     * @return messageSender_ Message sender.
     */
    function _unpackMessageSender() internal pure virtual returns (address messageSender_) {
        // Calldata: [original calldata (N bytes)][original msg.sender (20 bytes)][endpoint address (20 bytes)]
        assembly ("memory-safe") {
            messageSender_ := shr(96, calldataload(sub(calldatasize(), 40)))
        }
    }

    /**
     * @dev Unpack endpoint address from calldata.
     * @return endpointAddress_ Endpoint address.
     */
    function _unpackEndpointAddress() internal pure virtual returns (address endpointAddress_) {
        // Calldata: [original calldata (N bytes)][original msg.sender (20 bytes)][endpoint address (20 bytes)]
        assembly ("memory-safe") {
            endpointAddress_ := shr(96, calldataload(sub(calldatasize(), 20)))
        }
    }

    /**
     * @dev Unpack trailing parameters from calldata.
     * @return messageSender_ Message sender.
     * @return endpointAddress_ Endpoint address.
     */
    function _unpackTrailingParameters()
        internal
        pure
        virtual
        returns (address messageSender_, address endpointAddress_)
    {
        // Calldata: [original calldata (N bytes)][original msg.sender (20 bytes)][endpoint address (20 bytes)]
        assembly ("memory-safe") {
            messageSender_ := shr(96, calldataload(sub(calldatasize(), 40)))
            endpointAddress_ := shr(96, calldataload(sub(calldatasize(), 20)))
        }
    }

    /**
     * @dev Bubble up revert with error message.
     * @param errorMessage_ Error message.
     */
    function _revertBytes(bytes memory errorMessage_) internal pure virtual {
        assembly ("memory-safe") {
            if iszero(mload(errorMessage_)) {
                // Store the function selector of `EmptyError()`.
                mstore(0x00, 0x4f3d7def)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }

            revert(add(32, errorMessage_), mload(errorMessage_))
        }
    }

    // ============
    // Hook methods
    // ============

    /**
     * @notice Hook that is called upon creation of an endpoint to get its implementation.
     * @dev This method may be overridden to customize the endpoint implementation.
     * In the common case you use a single-endpoint you will override this method in your `Installer` contract.
     * In the exceptional case you use a multi-endpoint module you will override this method in
     * the place you instantiate the endpoint, one of your `Module` contracts.
     * @return endpointCreationCode_ Endpoint creation code.
     */
    function _getEndpointCreationCode(uint32) internal virtual returns (bytes memory endpointCreationCode_) {
        endpointCreationCode_ = type(ReflexEndpoint).creationCode;
    }
}
