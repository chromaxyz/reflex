# Contributors

Contributions to Reflex are welcome by anyone interested in writing more tests, improving readability, optimizing for gas efficiency, extending the core protocol or periphery modules.

When making a pull request, ensure that:

- All tests pass.
- Code coverage remains at 100%, run [`scripts/coverage.sh`](../scripts/coverage.sh).
- All new code adheres to the style guide:
  - All lint checks pass.
  - Code is thoroughly commented with NatSpec where relevant.
- If making a change to the contracts:
  - Gas snapshots are provided and demonstrate an improvement (or an acceptable deficit given other improvements).
  - Reference contracts are modified correspondingly if relevant.
  - New tests are included for all new features or code paths.
- A descriptive summary of the PR has been provided.

## Style guide

- Comments **must** have periods after every sentence.
- Underscore prefix are reserved for private and internal methods and variables.
- Underscore postfix are reserved for function arguments and return arguments.
- Memory addresses and memory related constants should be in hexadecimal format (e.g. `0x20`).
- While the linter is set to a maximum line length of 120, please try to keep everything, including comments to 100 characters or below.
- Private and internal constants are `_PREFIXED_ALL_CAPS`.
- Imports are named imports, sorted by their category and marked by a comment as follows:

```solidity
// Vendor
import { Test } from "forge-std/Test.sol";
```

- Code blocks are commented as follows:

```solidity
// ============
// View methods
// ============
```

## File naming

- Abstract core modules that are meant to be inherited by implementers **must** be prefixed by `Reflex`.

## Compiler

Make sure your PR's are compilable with the `default` profile and the profiles `min-solc`, `via-ir` and `min-solc-via-ir`.

## Tests

Reflex includes a suite of fuzzing and invariant tests written in Solidity with Foundry.

To install Foundry:

```sh
curl -L https://foundry.paradigm.xyz | bash
```

This will download `foundryup`. To start Foundry, run:

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

Test profiles: `default`, `intense`, `bounded`, `unbounded`.

Usage: `PROFILE=default make test`.

| Command                                                        | Action                                              |
| -------------------------------------------------------------- | --------------------------------------------------- |
| `make test` or `PROFILE=default make test`                     | Run all tests with the `default` profile.           |
| `make test-unit` or `PROFILE=default make test-unit`           | Run all unit tests with the `default` profile.      |
| `make test-fuzz` or `PROFILE=default make test-fuzz`           | Run all fuzz tests with the `default` profile.      |
| `make test-invariant` or `PROFILE=default make test-invariant` | Run all invariant tests with the `default` profile. |

### Snapshot Commands

Build profiles: `default`, `min-solc`, `via-ir`, `min-solc-via-ir`.

Test profiles: `default`, `intense`, `bounded`, `unbounded`.

Usage: `PROFILE=default make snapshot`.

| Command                                            | Action                                   |
| -------------------------------------------------- | ---------------------------------------- |
| `make snapshot` or `PROFILE=default make snapshot` | Run snapshot with the `default` profile. |

### Linter Commands

| Command           | Action                |
| ----------------- | --------------------- |
| `make lint-check` | Run the lint checker. |
| `make lint-fix`   | Run the lint fixer.   |
