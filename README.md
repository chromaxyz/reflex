# Reflex

A Solidity framework for upgradeable modularized applications.

---

[![Tests][gha-contracts-badge]][gha-contracts] [![Linter][gha-lint-badge]][gha-lint] [![Foundry][foundry-badge]][foundry] [![License: GPL-3.0-or-later][license-badge]][license]

[gha-contracts]: https://github.com/chromaxyz/reflex/actions/workflows/contracts.yml
[gha-contracts-badge]: https://github.com/chromaxyz/reflex/actions/workflows/contracts.yml/badge.svg
[gha-lint]: https://github.com/chromaxyz/reflex/actions/workflows/lint.yml
[gha-lint-badge]: https://github.com/chromaxyz/reflex/actions/workflows/lint.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-DEA584.svg
[license]: https://www.gnu.org/licenses/gpl-3.0
[license-badge]: https://img.shields.io/badge/License-GPL--3.0--or--later-blue

---

## Table of Contents

- [Reflex](#reflex)
  - [Table of Contents](#table-of-contents)
  - [Traits](#traits)
  - [Motivation](#motivation)
  - [Contracts](#contracts)
  - [Install](#install)
  - [Usage](#usage)
    - [Install Commands](#install-commands)
    - [Build Commands](#build-commands)
    - [Test Commands](#test-commands)
  - [Resources](#resources)
  - [Safety](#safety)
  - [Known limitations](#known-limitations)
  - [Contributing](#contributing)
  - [Acknowledgements](#acknowledgements)
  - [License](#license)

## Traits

- Provides a minimal, gas-optimized framework for building and maintaining upgradeable modularized applications.
- Modularization prevents hitting the Spurious Dragon maximum contract size limitation of `24576` bytes.
- Avoids function selector clashing allowing you to run multiple spec-compliant modules side-by-side.
- Multiple module types: `single-endpoint` modules, `multi-endpoint` modules and `internal` modules.
- Uses neutral language, avoids introducing new terminology.
- Relatively minimal overhead for the features it provides:
  - [~7948](test/GasBenchmark.t.sol) gas on the initial cold call.
  - [~948](test/GasBenchmark.t.sol) gas on the subsequent warm call.
  - [~14664](test/GasBenchmark.t.sol) gas on the initial cold batched transaction call.
  - [~3164](test/GasBenchmark.t.sol) gas on the subsequent warm batched transaction call.
- A built-in installer allowing you to add, upgrade and deprecate modules throughout the application lifespan.
- Has a global reentrancy lock capable of covering every storage-modifying method in the inheriting application.

Notably this is a so-called framework, a single well-tested implementation rather than a specification.
The framework serves as the foundation of your modular application allowing you to focus on your business logic.

To get started with Reflex we’ve created [Reflex Template](https://github.com/chromaxyz/reflex-template), a minimal template repository showing the basic use of Reflex in an application context.

## Motivation

If you are looking to iterate and expand the feature set of your smart contract application throughout the development lifecycle, Reflex is for you.

Until now the Solidity ecosystem has been using libraries and collections of code snippets intended to be composed together. We propose that the natural evolution are barebone, comprehensive and opinionated frameworks and this is the first of its kind.

As the name suggests it is a nod to React, the popular JavaScript framework for the web. Like React, Reflex is built on the powerful abstraction of modules.

In React, you as a developer do need to concern yourself with the internals of React Fiber’s reconciler to use React in your application: it just works. In the same light Reflex aims to alleviate developers from the implementation details of building upgradeable modular smart contracts.

## Contracts

```
.
├── interfaces
│   ├── IReflexDispatcher.sol
│   ├── IReflexEndpoint.sol
│   ├── IReflexInstaller.sol
│   ├── IReflexModule.sol
│   └── IReflexState.sol
├── periphery
│   ├── interfaces
│   │   └── IReflexBatch.sol
│   └── ReflexBatch.sol
├── ReflexConstants.sol
├── ReflexDispatcher.sol
├── ReflexEndpoint.sol
├── ReflexInstaller.sol
├── ReflexModule.sol
└── ReflexState.sol
```

```mermaid
graph TD
    subgraph Reflex [ ]

    ReflexInstaller --> ReflexModule
    ReflexDispatcher --> ReflexState
    ReflexModule --> ReflexState
    ReflexState --> ReflexConstants
    end
```

## Install

To install for [**Foundry**](https://github.com/foundry-rs/foundry):

```sh
forge install chromaxyz/reflex
```

## Usage

Reflex includes a suite of unit and fuzz tests written in Solidity with Foundry.

Please refer to the [IMPLEMENTERS](docs/IMPLEMENTERS.md) guide for an in-depth breakdown of the framework.

To install Foundry:

```sh
curl -L https://foundry.paradigm.xyz | bash
```

This will download foundryup. To start Foundry, run:

```sh
foundryup
```

For convenience we use a [Makefile](/Makefile) for running different tasks.

### Install Commands

| Command                  | Action                    |
| ------------------------ | ------------------------- |
| `make` or `make install` | Install all dependencies. |

### Build Commands

Build profiles: `default`, `min-solc`, `via-ir`, `min-solc-via-ir`.

Usage: `PROFILE=default make build`.

| Command                                      | Action                                            |
| -------------------------------------------- | ------------------------------------------------- |
| `make build` or `PROFILE=default make build` | Compile all contracts with the `default` profile. |
| `make clean`                                 | Delete all cached build files.                    |

### Test Commands

Build profiles: `default`, `min-solc`, `via-ir`, `min-solc-via-ir`.

Test profiles: `default`, `intense`.

Usage: `PROFILE=default make test`.

| Command                                    | Action                                    |
| ------------------------------------------ | ----------------------------------------- |
| `make test` or `PROFILE=default make test` | Run all tests with the `default` profile. |

## Resources

- [Checklist](./docs/CHECKLIST.md)
- [Contributors](./docs/CONTRIBUTORS.md)
- [Implementers](./docs/IMPLEMENTERS.md)

## Safety

This is **experimental software** and is provided on an "as is" and "as available" basis.

We **do not give any warranties** and **will not be liable for any loss** incurred through any use of this codebase.

At this point in time Reflex **has not yet been audited** and must therefore not yet be used in production.

## Known limitations

Please refer to the [IMPLEMENTERS](docs/IMPLEMENTERS.md#security-assumptions-and-known-limitations) guide for a list of known limitations and security assumptions.

## Contributing

Please refer to the [CONTRIBUTORS](docs/CONTRIBUTORS.md) guide for more information.

We are currently still in an experimental phase leading up to a first audit and would love to hear your feedback on how we can improve Reflex. Contributions are welcome by anyone interested in writing more tests, improving readability, optimizing for gas efficiency, simplifying the core protocol further or adding periphery modules.

## Acknowledgements

The goal of the framework is to provide an alternative, and in some aspects superior, solution to the fundamental problem EIP-2535: [Diamond, Multi-Facet Proxy](https://eips.ethereum.org/EIPS/eip-2535) aims to solve namely to enable the creation of modular smart contract systems that can be extended after deployment.

The architecture is directly inspired by [Euler's Proxy Protocol](https://docs.euler.finance/developers/proxy-protocol) and we are thankful for their extensive documentation and novel modularization architecture.

The original idea of what a Solidity framework may look like has been inspired by [Olympus DAO's Default Framework](https://github.com/fullyallocated/Default).

The contracts and tests were inspired by or directly modified from many sources, primarily:

- [Euler](https://github.com/euler-xyz/euler-contracts) - `GPL-2.0-or-later`
- [EIP-2535: Diamonds, Multi-Facet Proxy](https://eips.ethereum.org/EIPS/eip-2535) - `CC0`

## License

Licensed under the [GPL-3.0-or-later](/LICENSE) license.

For third party licenses please refer to [THIRD_PARTY_LICENSES](/THIRD_PARTY_LICENSES).
