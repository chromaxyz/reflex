# Reflex

A first-generation Solidity framework for upgradeable modules.

## Positives

- Upgradeable modules: single-proxy modules, multi-proxy modules and internal modules.
- Avoids hitting the max contract size limitation of ~24kb.
- Avoids function selector clashing, allowing to have multiple spec-compliant modules run side-by-side.

## Negatives

- Multiple application entrypoints via their proxies.

## Contracts

```
.
├── BaseConstants.sol
├── BaseModule.sol
├── BaseState.sol
├── Dispatcher.sol
├── interfaces
│   ├── IBaseInstaller.sol
│   ├── IBaseModule.sol
│   ├── IBase.sol
│   ├── IBaseState.sol
│   └── IDispatcher.sol
├── internals
│   ├── Base.sol
│   └── Proxy.sol
└── modules
    └── BaseInstaller.sol
```

## Acknowledgements

These contracts were inspired by or directly modified from many sources, primarily:

- [Euler](https://github.com/euler-xyz/euler-contracts)
- [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts)
- [Balancer V2](https://github.com/balancer-labs/balancer-v2-monorepo/tree/master/pkg/vault/contracts)

## License

Licensed under the [AGPL-3.0-only](/LICENSE) license.
