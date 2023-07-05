# Implementers

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Modules](#modules)
  - [Single-endpoint modules](#single-endpoint-modules)
  - [Multi-endpoint modules](#multi-endpoint-modules)
  - [Internal modules](#internal-modules)
  - [User interaction flow](#user-interaction-flow)
- [Endpoints](#endpoints)
  - [Endpoint => Dispatcher](#endpoint--dispatcher)
  - [Dispatcher => Module](#dispatcher--module)
  - [Module => Endpoint](#module--endpoint)
- [Implementing](#implementing)
- [Framework deployment](#framework-deployment)
- [Module deployment](#module-deployment)
- [Numerical limitations](#numerical-limitations)
- [Acknowledgements](#acknowledgements)

## Modules

Reflex supports multiple types of modules out of the box:

- [Single-endpoint modules](#single-endpoint-modules)
- [Multi-endpoint modules](#multi-endpoint-modules)
- [Internal modules](#internal-modules)

Since modules are invoked by `DELEGATECALL` they should **NOT** have any storage-related initialization in their constructors. The only thing that should be done in their constructors is to initialize immutable variables, since these are embedded into the contract's bytecode, not storage. Modules also should not define any storage variables. In the rare cases they need private storage, they should use unstructured storage.

### Single-endpoint modules

Modules that have a single endpoint to a single implementation relation.
This is the most common type of module.

```mermaid
graph TD
  subgraph SingleEndpoint [ ]
  Endpoint --> Dispatcher
  Dispatcher --> Module["Module Implementation"]
  end
```

### Multi-endpoint modules

Modules that have a multiple endpoints to a single implementation relation.
It is relatively uncommon that one needs this type of module.

```mermaid
graph TD
  subgraph MultiEndpoint [ ]
  Endpoint1["Endpoint"] --> Dispatcher
  Endpoint2["Endpoint"] --> Dispatcher
  Endpoint3["Endpoint"] --> Dispatcher
  Dispatcher --> Module["Module Implementation"]
  end
```

### Internal modules

Modules that are called internally and don't have any public-facing endpoints.
Internal modules have the benefit that they are upgradeable where the `Dispatcher` itself is not.

```mermaid
graph TD
  subgraph InternalModule [ ]
  Endpoint1["Endpoint"] --> Dispatcher
  Dispatcher --> Module1["Module Implementation"]
  Module1["Module Implementation"] <--> InternalModule1["Internal Module 1"]
  Module1["Module Implementation"] <--> InternalModule2["Internal Module 2"]
  end
```

### User interaction flow

From the users' perspective the flow of interaction looks as follows:

```mermaid
sequenceDiagram
    User->>Module Endpoint: Request
    Module Endpoint->>Dispatcher (Storage): call()
    Dispatcher (Storage) ->>Module Implementation: delegatecall()
    Module Implementation->>Dispatcher (Storage): Response
    Dispatcher (Storage) ->>Module Endpoint: Response
    Module Endpoint->>User: Response
```

## Endpoint

Endpoints are non-upgradeable contracts that have two jobs:

- Forward method calls from external users to the `Dispatcher`.
- Receive method calls from the `Dispatcher` and log events as instructed.

Although endpoints themselves are non-upgradeable, they integrate with Reflex's module system, which does allow for upgrades.

Modules cannot be called directly. Instead, they must be invoked through an endpoint.
By default, all endpoints are implemented by the same code: [src/ReflexEndpoint.sol](../src/ReflexEndpoint.sol). This is a very simple contract that forwards its requests to the `Dispatcher`, along with the original `msg.sender`. The call is done with a normal `call()`, so the execution takes place within the `Dispatcher` contract's storage context, not the endpoints'.

Endpoints contain the bare minimum amount of logic required for forwarding. This is because they are not upgradeable. They should ideally be as optimized as possible so as to minimise gas costs since many of them will be deployed.

The `Dispatcher` contract ensures that all requests to it are from a known trusted endpoint address. The only way that addresses can become known trusted is when the `Dispatcher` contract itself creates them. In this way, the original `msg.sender` sent by the endpoint can be trusted.

The only other thing that endpoints do is to accept messages from the `Dispatcher` that instruct them to issue log messages as mentioned above.

One important feature provided by the endpoint-module system is that a single storage context (i.e. the `Dispatcher` contract) can have multiple possibly-colliding function ABI namespaces, which is not possible with systems like a conventional upgradeable proxy, or the [EIP-2535 Diamond, Multi-Facet Proxy](https://eips.ethereum.org/EIPS/eip-2535) standard. An example of how this works in practice can be found in [test/implementations/abstracts/ImplementationERC20.sol](../test/implementations/abstracts/ImplementationERC20.sol), [test/ImplementationERC20.t.sol](../test/ImplementationERC20.t.sol) and [test/ImplementationModuleMultiEndpoint.t.sol](../test/ImplementationModuleMultiEndpoint.t.sol).

### Endpoint => Dispatcher

To the calldata received in a fallback, the endpoint appends its view of msg.sender:

```
[calldata (N bytes)][msg.sender (20 bytes)]
```

This data is then passed to the `Dispatcher` contract with a `CALL` (not `DELEGATECALL`).

### Dispatcher => Module

In the `fallback` method, the `Dispatcher` contract looks up its view of `msg.sender`, which corresponds to the endpoint address.

The presumed endpoint address is then looked up in the internal `_relations` mapping, which must exist otherwise the call is reverted. It is determined to exist by having a non-zero entry in the `moduleId` field (modules must have non-zero IDs, see section [Numerical limitations](#numerical-limitations)).

The only way an endpoint address can be added to internal `_relations` mapping is if the `Dispatcher` contract itself creates it (using the `_createEndpoint` function in [src/ReflexBase.sol](../src/ReflexBase.sol)).

In the case of a `single-endpoint module`, the same storage slot in the internal `_relations` mapping will also contain an address for the module's implementation.

In the case of a `multi-endpoint module`, the storage slot will only contain the `moduleId`. This is because during an upgrade, `single-endpoint modules` just have to update this one spot, whereas `multi-endpoint modules` would otherwise need to update every corresponding entry in the internal `_relations` mapping.

At this point we know the message is originating from a legitimate endpoint, so the last 20 bytes can be assumed to correspond to an actual `msg.sender` who invoked an endpoint. The length of the calldata is checked. It should be at least `4 + 20 bytes` long, which corresponds to:

- `4 bytes` for selector used to call the endpoint (non-standard ABI invocations and fallback methods are not supported in modules).
- `20 bytes` for the trailing `msg.sender`.

The `Dispatcher` then takes the received calldata and appends its view of `msg.sender` (`caller()` in assembly), which corresponds to the endpoints' address. This results in the following:

```
[original calldata (N bytes)][original msg.sender (20 bytes)][endpoint address (20 bytes)]
```

This data is then sent to the module implementation with `DELEGATECALL`, so the module implementation code is executing within the storage context of the `Dispatcher`.

The module implementation will unpack the original calldata using the solidity ABI decoder, ignoring the trailing `40 bytes`.

Modules are not allowed to access `msg.sender`. Instead, they should use the `unpackMessageSender()` helper in [src/ReflexModule.sol](../src/ReflexModule.sol) which will retrieve the message sender from the trailing calldata. When modules need to access the endpoint address, there is a composite helper `unpackEndpointAddress` which will retrieve the endpoint address from the trailing calldata.

### Module => Endpoint

When a module directly emits a log it will happen from the `Dispatcher` contract's address. This is fine for many logs, but not in certain cases like when a module is implementing the ERC-20 standard. In these cases it is necessary to emit the log from the address of the endpoint itself.

In order to do this, the `Dispatcher` contract does a `CALL` to the endpoint address.

When the endpoint sees a call to its fallback from the `Dispatcher`, it knows not to re-enter the `Dispatcher` contract. Instead, it interprets this call as an instruction to issue a log message. This is the format of the calldata:

```
[number of topics as uint8 (1 byte)][topic #i (32 bytes)]{0,4}[extra log data (N bytes)]
```

The endpoint unpacks this message and executes the appropriate log instruction: `log0`, `log1`, `log2`, `log3` or `log4`, depending on the number of topics.

## Reentracy guard

All `single-endpoint` modules and `multi-endpoint` modules `CALL` (not `DELEGATECALL`) the `Dispatcher` meaning that all operations happen inside of the `Dispatcher` storage context. This allows us to have a single global re-entrancy lock that can cover every storage modifiying method in the protocol.

There are exceptions however to this rule and these must be handled with great care namely:

- `internal` modules are called internally using `DELEGATECALL`.
- One must only make `CALL`s to trusted modules and trusted sources.
- One must assume that any `CALL` made from inside of any module may re-enter.

To verify that all external state-modifying methods have a `nonReentrant` or `reentrancyAllowed` modifier applied one SHOULD RUN the respective [scripts/reentrancy-check.sh](../scripts/reentrancy-check.sh) and [scripts/reentrancy-generate.sh](../scripts/reentrancy-generate.sh) scripts.

## Storage

As mentioned before, execution takes place within the `Dispatcher` contract's storage context, not the endpoints'. Implementers must remain vigilant to not cause storage clashes by defining storage slots directly inside of `Modules`.

To verify that the storage layout is compatible one SHOULD RUN the respective [scripts/storage-check.sh](../scripts/storage-check.sh) and [scripts/storage-generate.sh](../scripts/storage-generate.sh) scripts after applying any updates.

## Implementing

In order to use the Reflex framework there are multiple abstract contracts one has to inherit as follows:

```solidity
// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendors
import { ReflexConstants } from "reflex/ReflexConstants.sol";
import { ReflexDispatcher } from "reflex/ReflexDispatcher.sol";
import { ReflexInstaller } from "reflex/ReflexInstaller.sol";
import { ReflexModule } from "reflex/ReflexModule.sol";
import { ReflexState } from "reflex/ReflexState.sol";

abstract contract Constants is ReflexConstants {
  // ...
}

abstract contract State is ReflexState, Constants {
  // ...
}

abstract contract Module is ReflexModule, State {
  /**
   * @param moduleSettings_ Module settings.
   */
  constructor(ModuleSettings memory moduleSettings_) ReflexModule(moduleSettings_) {}

  // ...
}

contract Installer is ReflexInstaller, Module {
  /**
   * @param moduleSettings_ Module settings.
   */
  constructor(ModuleSettings memory moduleSettings_) Module(moduleSettings_) {}

  // ...
}

contract Dispatcher is ReflexDispatcher, State {
  /**
   * @param owner_ Protocol owner.
   * @param installerModule_ Installer module address.
   */
  constructor(
    address owner_,
    address installerModule_
  ) ReflexDispatcher(owner_, installerModule_) {}

  // ...
}
```

As a diagram:

```mermaid
graph TD
    subgraph Application [ ]
    Dispatcher --> ReflexDispatcher
    Dispatcher --> State
    Installer --> ReflexInstaller
    Installer --> Module
    Module --> ReflexModule
    Module --> State
    State --> ReflexState
    State --> Constants
    Constants --> ReflexConstants
    end
```

## Framework deployment

An example of a deployment flow can be found in [`script/Deploy.s.sol`](../script/Deploy.s.sol).

## Module deployment

Prior to adding, upgrading or deprecating a module make sure to go through the [CHECKLIST](/docs/CHECKLIST.md)

## Numerical limitations

- Module id:

  - One per module
  - Type: `uint32`
  - Range: `(min: 0, reserved: ∈[0 .. 1], available: ∈[2 .. 4294967295])`

- Module type:

  - One per module type
  - Type: `uint16`
  - Range: `(min: 0, reserved: ∈[0 .. 2], available: ∈[3 .. 65535])`

## Security assumptions and known limitations

- It is assumed `owner` is not malicious.
- It is assumed Reflex `implementers` are not malicious.
- It is assumed Reflex `implementations` are correct and adhere to the following guidelines and restrictions:
  - `State` layout is consistent across `Modules`.
  - Reflex has multiple application entrypoints via their endpoints. The endpoint address however stays consistent throughout module upgrades.
  - Reflex does not support `payable` modifiers and native token transfers due to reentrancy concerns.
  - The `Dispatcher` and the internal `Endpoint` contracts are not upgradable.
  - The diamond storage struct defined in `ReflexState` is append-only extendable but implementers must remain vigilant to not cause storage clashes by defining storage slots directly inside of `Modules`.
  - Native ETH is not supported, instead users are required to wrap their ETH into WETH. This is to prevent an entire class of possible re-entrancy bugs.
  - Implementers **MUST NOT** implement a `selfdestruct` inside of `Modules` as this causes disastrous unexpected behaviour.
  - The registration of `Modules` **MUST BE** permissioned, malicious `Modules` can impact the behaviour of the entire application.
  - `Modules` **MUST NOT** define any storage variables or re-use diamond storage slots. In the rare case this is necessary one should use unstructured storage.
  - `Modules` **CAN ONLY** initialize **IMMUTABLE** storage variables inside of their constructor.
- It is assumed no `delegatecalls` that could have a side effect in Reflex occur to zero-address, faulty, malicious or user-controllable contracts.
- It is assumed that functions tagged as `reentrancyAllowed` **CAN** be re-entered and are safe to be re-entered as they are limited by their scope to a trusted set of contracts as defined through the Reflex framework.
- It is assumed that functions tagged as `nonReentrant` and `nonReadReentrant` **CAN NOT** be re-entered.
- It is assumed that there **CAN NOT** be a malicious actor who implements a `Module` with storage side-effects in the `Dispatcher`. If this is compromised in any way all state inside of the `Dispatcher` can be manipulated or corrupted.
- It is assumed that Solidity's ABI decoder remains tolerant of extra trailing data and will continue to ignore it.

## Acknowledgements

This guide is directly inspired by [Euler's Proxy Protocol](https://docs.euler.finance/developers/proxy-protocol) and we are thankful for their extensive documentation and novel modularization architecture.
