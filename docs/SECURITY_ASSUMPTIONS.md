# Security Assumptions

- It is assumed `owner` is not malicious.
- It is assumed Reflex `implementers` are not malicious.
- It is assumed Reflex `implementations` are correct and adhere to guidelines and restrictions set out in the [IMPLEMENTERS](docs/IMPLEMENTERS.md) guide, specifically:
  - `State` layout is consistent across `Modules`.
  - Implementers **MUST NOT** implement an `implementation()` or preferably a `sentinel()` method in `Modules` as this causes a function selector clash in the `Endpoint`.
  - Implementers **MUST NOT** implement a `selfdestruct` inside of `Modules` as this causes disastrous unexpected behaviour.
  - The registration of `Modules` **MUST BE** permissioned, malicious `Modules` can impact the behaviour of the entire application.
  - `Modules` **MUST NOT** define any storage variables. In the rare case this is necessary one should use unstructured storage.
  - `Modules` **CAN ONLY** initialize **IMMUTABLE** storage variables inside of their constructor.
  - Native `ETH` is not supported, instead users are required to wrap their `ETH` into `WETH`. This is to prevent an entire class of possible re-entrancy bugs.
- It is assumed no `delegatecalls` that could have a side effect in Reflex occur to zero-address, faulty, malicious or user-controllable contracts.
- It is assumed that functions tagged as `reentrancyAllowed` can be re-entered and are safe to be re-entered as they are limited by their scope to a trusted set of contracts as defined through the Reflex framework.
- It is assumed that any storage set by malicious actors on any `Module` implemenetation **CAN NOT** effect execution, storage or incur any side-effects on the storage in the `Dispatcher`.
