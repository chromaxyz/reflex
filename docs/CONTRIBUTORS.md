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
- Imports are sorted by their category and marked by a comment.
- Code blocks are commented as follows:

```solidity
// ==============
// View functions
// ==============
```

## File naming

- Abstract core modules that are meant to be inherited by implementers **must** be prefixed by `Base`.

## Compiler

Make sure your PR's are compilable with the default profile and the profiles `intense`, `min-solc`, `via-ir` and `min-solc-via-ir`.
