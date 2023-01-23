# Contributors

Contributions to Reflex are welcome by anyone interested in writing more tests, improving readability, optimizing for gas efficiency, extending the core protocol or periphery modules.

When making a pull request, ensure that:

- All tests pass.
- Code coverage remains at 100% (`scripts/coverage.sh`).
- All new code adheres to the style guide:
  - All lint checks pass.
  - Code is thoroughly commented with natspec where relevant.
- If making a change to the contracts:
  - Gas snapshots are provided and demonstrate an improvement (or an acceptable deficit given other improvements).
  - Reference contracts are modified correspondingly if relevant.
  - New tests are included for all new features or code paths.
- A descriptive summary of the PR has been provided.

## Style guide

- Comments **must** have periods after every sentence.
- Underscore prefix are reserved for private and internal functions and variables.
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

Make sure your PR's are compilable with the default profile and the profiles `intense`, `min-solc`, `via-ir` and `min-solc-via-ir`.

## Tests

Reflex includes a suite of fuzzing and invariant tests written in Solidity with Foundry.

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

| Command                      | Action                                                                |
| ---------------------------- | --------------------------------------------------------------------- |
| `make build`                 | Compile all contracts in the repo with the `default` profile.         |
| `make build-min-solc`        | Compile all contracts in the repo with the `min-solc` profile.        |
| `make build-via-ir`          | Compile all contracts in the repo with the `via-ir` profile.          |
| `make build-min-solc-via-ir` | Compile all contracts in the repo with the `min-solc-via-ir` profile. |
| `make clean`                 | Delete cached files.                                                  |

### Test Commands

| Command                     | Action                                            |
| --------------------------- | ------------------------------------------------- |
| `make test`                 | Run all tests.                                    |
| `make test-intense`         | Run all tests with the `intense` profile.         |
| `make test-min-solc`        | Run all tests with the `min-solc` profile.        |
| `make test-via-ir`          | Run all tests with the `via-ir` profile.          |
| `make test-min-solc-via-ir` | Run all tests with the `min-solc-via-ir` profile. |

### Snapshot Commands

| Command                         | Action                                           |
| ------------------------------- | ------------------------------------------------ |
| `make snapshot`                 | Run snapshot.                                    |
| `make snapshot-min-solc`        | Run snapshot with the `min-solc` profile.        |
| `make snapshot-via-ir`          | Run snapshot with the `via-ir` profile.          |
| `make snapshot-min-solc-via-ir` | Run snapshot with the `min-solc-via-ir` profile. |

### Linter Commands

| Command           | Action                |
| ----------------- | --------------------- |
| `make lint-check` | Run the lint checker. |
| `make lint-fix`   | Run the lint fixer.   |
