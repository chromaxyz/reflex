# Reflex

A first-generation Solidity framework for upgradeable modules.

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

## License

Licensed under the [AGPL-3.0-only](/LICENSE) license.
