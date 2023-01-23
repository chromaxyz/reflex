// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {CommonBase} from "forge-std/Base.sol";

/**
 * @title Users
 * @dev Common stand-in users for testing.
 * @author `Users` has been modified from: PRBTest (https://github.com/PaulRBerg/prb-math/blob/main/test/BaseTest.t.sol) (MIT)
 */
abstract contract Users is CommonBase {
    // =======
    // Structs
    // =======

    struct UserAddresses {
        // solhint-disable-next-line var-name-mixedcase
        address payable Alice;
        // solhint-disable-next-line var-name-mixedcase
        address payable Bob;
        // solhint-disable-next-line var-name-mixedcase
        address payable Caroll;
        // solhint-disable-next-line var-name-mixedcase
        address payable Dave;
    }

    // =======
    // Storage
    // =======

    UserAddresses internal _users;

    // =====
    // Setup
    // =====

    function setUp() public virtual {
        _users = UserAddresses({
            Alice: _createUser("Alice"),
            Bob: _createUser("Bob"),
            Caroll: _createUser("Caroll"),
            Dave: _createUser("Dave")
        });
    }

    // =========
    // Utilities
    // =========

    /**
     * @dev Create user address from user label.
     */
    function _createUser(string memory label_) internal returns (address payable user) {
        user = payable(address(uint160(uint256(keccak256(abi.encodePacked(label_))))));
        vm.label(user, label_);
        vm.deal(user, 100e18);
    }
}
