// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Fixtures
import {BoundedHandler, UnboundedHandler} from "../../fixtures/InvariantHarness.sol";

contract UnboundedDispatcherHandler is UnboundedHandler {}

contract BoundedDispatcherHandler is BoundedHandler {}
