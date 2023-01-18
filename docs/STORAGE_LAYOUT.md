**BaseDispatcher**

| Name             | Type                                                | Slot | Offset | Bytes | Contract                              |
| ---------------- | --------------------------------------------------- | ---- | ------ | ----- | ------------------------------------- |
| \_reentrancyLock | uint256                                             | 0    | 0      | 32    | src/BaseDispatcher.sol:BaseDispatcher |
| \_owner          | address                                             | 1    | 0      | 20    | src/BaseDispatcher.sol:BaseDispatcher |
| \_pendingOwner   | address                                             | 2    | 0      | 20    | src/BaseDispatcher.sol:BaseDispatcher |
| \_modules        | mapping(uint32 => address)                          | 3    | 0      | 32    | src/BaseDispatcher.sol:BaseDispatcher |
| \_proxies        | mapping(uint32 => address)                          | 4    | 0      | 32    | src/BaseDispatcher.sol:BaseDispatcher |
| \_relations      | mapping(address => struct TBaseState.TrustRelation) | 5    | 0      | 32    | src/BaseDispatcher.sol:BaseDispatcher |
| \_\_gap          | uint256[44]                                         | 6    | 0      | 1408  | src/BaseDispatcher.sol:BaseDispatcher |

**ImplementationDispatcher**

| Name                    | Type                                                 | Slot | Offset | Bytes | Contract                                                                   |
| ----------------------- | ---------------------------------------------------- | ---- | ------ | ----- | -------------------------------------------------------------------------- |
| \_reentrancyLock        | uint256                                              | 0    | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_owner                 | address                                              | 1    | 0      | 20    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_pendingOwner          | address                                              | 2    | 0      | 20    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_modules               | mapping(uint32 => address)                           | 3    | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_proxies               | mapping(uint32 => address)                           | 4    | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_relations             | mapping(address => struct TBaseState.TrustRelation)  | 5    | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_\_gap                 | uint256[44]                                          | 6    | 0      | 1408  | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_implementationState0  | bytes32                                              | 50   | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_implementationState1  | uint256                                              | 51   | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_implementationState2  | address                                              | 52   | 0      | 20    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| getImplementationState3 | address                                              | 53   | 0      | 20    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| getImplementationState4 | bool                                                 | 53   | 20     | 1     | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_implementationState5  | mapping(address => uint256)                          | 54   | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_tokens                | mapping(address => struct ImplementationState.Token) | 55   | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
