// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Interfaces
import {IReflexCircuitBreaker} from "./interfaces/IReflexCircuitBreaker.sol";

// Sources
import {ReflexModule} from "../ReflexModule.sol";

/**
 * @title Reflex Circuit Breaker
 *
 * @dev Execution takes place within the Dispatcher's storage context.
 * @dev Upgradeable, extendable.
 */
abstract contract ReflexCircuitBreaker is IReflexCircuitBreaker, ReflexModule {
    // Could the circuit breaker be designed as an internal module?
    // Design would likely be a bit different than the original, but the idea is the same.
    // Would be more simplistic
    // Would be more gas efficient
    // Would only support ERC20
    // SafeERC20 / SafeCast copied from Solady, inlined
    // Would only support percentage based circuit breakers
    // A way for users to recover locked funds
    // A way to track funds flowing through the system
    // Goal is to adhere to the standard as much as possible but with a more simplistic design

    // =========
    // Constants
    // =========

    /**
     * @dev `bytes32(uint256(keccak256("_REFLEX_CIRCUIT_BREAKER_STORAGE")) - 1)`
     * A `-1` offset is added so the preimage of the hash cannot be known,
     * reducing the chances of a possible attack.
     */
    bytes32 internal constant _REFLEX_CIRCUIT_BREAKER_STORAGE_SLOT =
        0xd9ac2ceb110c0df268ba862a6063bcc7110ab1a6271b4c65be465273acab1998;

    // =======
    // Storage
    // =======

    /**
     * @dev Append-only extendable.
     */
    struct ReflexCircuitBreakerStorage {
        bool isRateLimited;
        uint256 rateLimitCooldownPeriod;
        uint256 lastRateLimitTimestamp;
        uint256 gracePeriodEndTimestamp;
    }

    // ======
    // Events
    // ======

    // event AssetRegistered(address indexed asset, uint256 metricThreshold, uint256 minAmountToLimit);

    // event AssetInflow(address indexed token, uint256 indexed amount);

    // event AssetRateLimitBreached(address indexed asset, uint256 timestamp);

    // event AssetWithdraw(address indexed asset, address indexed recipient, uint256 amount);

    // event LockedFundsClaimed(address indexed asset, address indexed recipient);

    // event AdminSet(address indexed newAdmin);

    // event GracePeriodStarted(uint256 gracePeriodEnd);

    // ============
    // View methods
    // ============

    // function lockedFunds(address recipient, address asset) external view returns (uint256 amount);

    // function isProtectedContract(address account) external view returns (bool protectionActive);

    // function admin() external view returns (address)

    // function isRateLimited() external view returns (bool);

    // function rateLimitCooldownPeriod() external view returns (uint256);

    // function lastRateLimitTimestamp() external view returns (uint256);

    // function gracePeriodEndTimestamp() external view returns (uint256);

    // function isRateLimitTriggered(address _asset) external view returns (bool);

    // function isInGracePeriod() external view returns (bool);

    // function isOperational() external view returns (bool);

    // ==============
    // Public methods
    // ==============

    // function onTokenInflow(address _token, uint256 _amount) external;

    // function onTokenOutflow(address _token, uint256 _amount, address _recipient, bool _revertOnRateLimit) external;

    // function claimLockedFunds(address _asset, address _recipient) external;

    // function overrideExpiredRateLimit() external;

    // ====================
    // Permissioned methods
    // ====================

    // function registerAsset(address _asset, uint256 _metricThreshold, uint256 _minAmountToLimit) external;

    // function updateAssetParams(address _asset, uint256 _metricThreshold, uint256 _minAmountToLimit) external;

    // function setAdmin(address _newAdmin) external;

    // function overrideRateLimit() external;

    // function addProtectedContracts(address[] calldata _ProtectedContracts) external;

    // function removeProtectedContracts(address[] calldata _ProtectedContracts) external;

    // function startGracePeriod(uint256 _gracePeriodEndTimestamp) external;

    // function markAsNotOperational() external;

    // function migrateFundsAfterExploit(address[] calldata _assets, address _recoveryRecipient) external;

    // ================
    // Internal methods
    // ================

    // How to manage protected contracts?
    // Considering Reflex is just one contract (Dispatcher) with virtualized modules
    // All modules are therefore considered to be protected, instead relying on the
    // specific implementation inside of modules
    // We have to make it specifically tailored for Reflex protocols
    // Circuit breaker is designed as part of the core

    function _onInflow() internal virtual {}

    function _onOutflow() internal virtual {}

    /**
     * @dev Get the Reflex Circuit Breaker storage pointer.
     * @return storage_ Pointer to the Reflex Circuit Breaker storage state.
     */
    // solhint-disable-next-line func-name-mixedcase
    function _REFLEX_CIRCUIT_BREAKER_STORAGE() internal pure returns (ReflexCircuitBreakerStorage storage storage_) {
        assembly ("memory-safe") {
            storage_.slot := _REFLEX_CIRCUIT_BREAKER_STORAGE_SLOT
        }
    }
}
