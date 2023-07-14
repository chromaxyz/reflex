// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
// solhint-disable-next-line no-console
import {console2} from "forge-std/console2.sol";

// Interfaces
import {IReflexModule} from "../../src/interfaces/IReflexModule.sol";

// Fixtures
import {ImplementationFixture} from "../fixtures/ImplementationFixture.sol";

// Mocks
import {MockImplementationModule} from "../mocks/MockImplementationModule.sol";

/**
 * @title Reflex Invariant Handler
 */
contract ReflexInvariantHandler is ImplementationFixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_SINGLE = 100;
    uint32 internal constant _MODULE_INTERNAL_ID = 101;

    // =======
    // Storage
    // =======

    address[] internal _actors;
    address internal _currentActor;

    uint256 internal _currentTimestamp;
    uint256[] internal _timestamps;
    uint256 internal _timestampCount;

    mapping(bytes32 => uint256) internal _callCounters;

    MockImplementationModule public singleModule;
    MockImplementationModule public singleModuleEndpoint;

    MockImplementationModule public internalModule;

    // =========
    // Modifiers
    // =========

    modifier useActor(uint256 actorIndexSeed_) {
        _currentActor = _actors[bound(actorIndexSeed_, 0, _actors.length - 1)];

        _;
    }

    modifier useCurrentTimestamp() {
        vm.warp(_currentTimestamp);

        _;
    }

    modifier countCall(bytes32 message_) {
        _increaseCallCount(message_);

        _;
    }

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        singleModule = new MockImplementationModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_ID_SINGLE, moduleType: _MODULE_TYPE_SINGLE_ENDPOINT})
        );

        internalModule = new MockImplementationModule(
            IReflexModule.ModuleSettings({moduleId: _MODULE_INTERNAL_ID, moduleType: _MODULE_TYPE_INTERNAL})
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(singleModule);
        moduleAddresses[1] = address(internalModule);
        installerEndpoint.addModules(moduleAddresses);

        singleModuleEndpoint = MockImplementationModule(dispatcher.getEndpoint(_MODULE_ID_SINGLE));

        _setCurrentTimestamp(block.timestamp);
        vm.warp(_currentTimestamp);

        _addActor(_users.Alice);
        _addActor(_users.Bob);
        _addActor(_users.Caroll);
        _addActor(_users.Dave);
    }

    // =======
    // Methods
    // =======

    function getCurrentActor() external view virtual returns (address) {
        return _currentActor;
    }

    function getCallCount(bytes32 message_) external view virtual returns (uint256) {
        return _callCounters[message_];
    }

    function warp(uint256 warpTime_) external virtual countCall("warp") useCurrentTimestamp {
        warpTime_ = bound(warpTime_, 1, 365 days);
        _setCurrentTimestamp(block.timestamp + warpTime_);
        vm.warp(_currentTimestamp);
    }

    // =========
    // Utilities
    // =========

    function _addActor(address actor_) internal virtual {
        _actors.push(actor_);
    }

    function _setCurrentTimestamp(uint256 currentTimestamp_) internal virtual {
        _timestamps.push(currentTimestamp_);
        _timestampCount++;
        _currentTimestamp = currentTimestamp_;
    }

    function _increaseCallCount(bytes32 message_) internal virtual {
        _callCounters[message_] += 1;
    }
}
