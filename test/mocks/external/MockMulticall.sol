// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

/**
 * @title Multicall3
 * @notice Aggregate results from multiple function calls
 * @dev Multicall & Multicall2 backwards-compatible
 * @dev Aggregate methods are marked `payable` to save 24 gas per call
 * @author Michael Elliot <mike@makerdao.com>
 * @author Joshua Levine <joshua@makerdao.com>
 * @author Nick Johnson <arachnid@notdot.net>
 * @author Andreas Bigger <andreas@nascent.xyz>
 * @author Matt Solomon <matt@mattsolomon.dev>
 *
 * @author `Multicall` has been modified from: Multicall3 (https://github.com/mds1/multicall) (MIT)
 */
contract MockMulticall {
    error CallFailed();

    struct Call {
        address target;
        bytes callData;
    }
    struct Result {
        bool success;
        bytes returnData;
    }

    function aggregate(Call[] memory calls) public returns (bytes[] memory returnData) {
        returnData = new bytes[](calls.length);

        for (uint256 i = 0; i < calls.length; i++) {
            (bool success, bytes memory ret) = calls[i].target.call(calls[i].callData);

            if (!success) revert CallFailed();

            returnData[i] = ret;
        }
    }

    function tryAggregate(bool requireSuccess, Call[] memory calls) public returns (Result[] memory returnData) {
        returnData = new Result[](calls.length);

        for (uint256 i = 0; i < calls.length; i++) {
            (bool success, bytes memory ret) = calls[i].target.call(calls[i].callData);

            if (requireSuccess) {
                if (!success) revert CallFailed();
            }

            returnData[i] = Result(success, ret);
        }
    }
}
