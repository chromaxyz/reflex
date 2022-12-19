// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// https://github.com/crytic/building-secure-contracts/tree/master/program-analysis/echidna#echidna-tutorial

contract BaseModuleEchidnaTest {
    event Flag(bool);

    bool private flag0 = true;
    bool private flag1 = true;

    function set0(int256 val) public returns (bool) {
        if (val % 100 == 0) flag0 = false;
        return flag0;
    }

    function set1(int256 val) public returns (bool) {
        if (val % 10 == 0 && !flag0) flag1 = false;
        return flag1;
    }

    function echidna_alwaystrue() public pure returns (bool) {
        return (true);
    }

    function echidna_revert_always() public pure returns (bool) {
        revert();
    }

    function echidna_sometimesfalse() public returns (bool) {
        emit Flag(flag0);
        emit Flag(flag1);
        return (flag1);
    }
}
