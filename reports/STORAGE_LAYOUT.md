**ReflexBase**

| Name             | Type                                                  | Slot | Offset | Bytes | Contract                      |
| ---------------- | ----------------------------------------------------- | ---- | ------ | ----- | ----------------------------- |
| \_reentrancyLock | uint256                                               | 0    | 0      | 32    | src/ReflexBase.sol:ReflexBase |
| \_owner          | address                                               | 1    | 0      | 20    | src/ReflexBase.sol:ReflexBase |
| \_pendingOwner   | address                                               | 2    | 0      | 20    | src/ReflexBase.sol:ReflexBase |
| \_modules        | mapping(uint32 => address)                            | 3    | 0      | 32    | src/ReflexBase.sol:ReflexBase |
| \_proxies        | mapping(uint32 => address)                            | 4    | 0      | 32    | src/ReflexBase.sol:ReflexBase |
| \_relations      | mapping(address => struct TReflexState.TrustRelation) | 5    | 0      | 32    | src/ReflexBase.sol:ReflexBase |
| \_\_gap          | uint256[44]                                           | 6    | 0      | 1408  | src/ReflexBase.sol:ReflexBase |

**ReflexConstants**

| Name | Type | Slot | Offset | Bytes | Contract |
| ---- | ---- | ---- | ------ | ----- | -------- |

**ReflexDispatcher**

| Name             | Type                                                  | Slot | Offset | Bytes | Contract                                  |
| ---------------- | ----------------------------------------------------- | ---- | ------ | ----- | ----------------------------------------- |
| \_reentrancyLock | uint256                                               | 0    | 0      | 32    | src/ReflexDispatcher.sol:ReflexDispatcher |
| \_owner          | address                                               | 1    | 0      | 20    | src/ReflexDispatcher.sol:ReflexDispatcher |
| \_pendingOwner   | address                                               | 2    | 0      | 20    | src/ReflexDispatcher.sol:ReflexDispatcher |
| \_modules        | mapping(uint32 => address)                            | 3    | 0      | 32    | src/ReflexDispatcher.sol:ReflexDispatcher |
| \_proxies        | mapping(uint32 => address)                            | 4    | 0      | 32    | src/ReflexDispatcher.sol:ReflexDispatcher |
| \_relations      | mapping(address => struct TReflexState.TrustRelation) | 5    | 0      | 32    | src/ReflexDispatcher.sol:ReflexDispatcher |
| \_\_gap          | uint256[44]                                           | 6    | 0      | 1408  | src/ReflexDispatcher.sol:ReflexDispatcher |

**ReflexInstaller**

| Name             | Type                                                  | Slot | Offset | Bytes | Contract                                |
| ---------------- | ----------------------------------------------------- | ---- | ------ | ----- | --------------------------------------- |
| \_reentrancyLock | uint256                                               | 0    | 0      | 32    | src/ReflexInstaller.sol:ReflexInstaller |
| \_owner          | address                                               | 1    | 0      | 20    | src/ReflexInstaller.sol:ReflexInstaller |
| \_pendingOwner   | address                                               | 2    | 0      | 20    | src/ReflexInstaller.sol:ReflexInstaller |
| \_modules        | mapping(uint32 => address)                            | 3    | 0      | 32    | src/ReflexInstaller.sol:ReflexInstaller |
| \_proxies        | mapping(uint32 => address)                            | 4    | 0      | 32    | src/ReflexInstaller.sol:ReflexInstaller |
| \_relations      | mapping(address => struct TReflexState.TrustRelation) | 5    | 0      | 32    | src/ReflexInstaller.sol:ReflexInstaller |
| \_\_gap          | uint256[44]                                           | 6    | 0      | 1408  | src/ReflexInstaller.sol:ReflexInstaller |

**ReflexModule**

| Name             | Type                                                  | Slot | Offset | Bytes | Contract                          |
| ---------------- | ----------------------------------------------------- | ---- | ------ | ----- | --------------------------------- |
| \_reentrancyLock | uint256                                               | 0    | 0      | 32    | src/ReflexModule.sol:ReflexModule |
| \_owner          | address                                               | 1    | 0      | 20    | src/ReflexModule.sol:ReflexModule |
| \_pendingOwner   | address                                               | 2    | 0      | 20    | src/ReflexModule.sol:ReflexModule |
| \_modules        | mapping(uint32 => address)                            | 3    | 0      | 32    | src/ReflexModule.sol:ReflexModule |
| \_proxies        | mapping(uint32 => address)                            | 4    | 0      | 32    | src/ReflexModule.sol:ReflexModule |
| \_relations      | mapping(address => struct TReflexState.TrustRelation) | 5    | 0      | 32    | src/ReflexModule.sol:ReflexModule |
| \_\_gap          | uint256[44]                                           | 6    | 0      | 1408  | src/ReflexModule.sol:ReflexModule |

**ReflexProxy**

| Name | Type | Slot | Offset | Bytes | Contract |
| ---- | ---- | ---- | ------ | ----- | -------- |

**ReflexState**

| Name             | Type                                                  | Slot | Offset | Bytes | Contract                        |
| ---------------- | ----------------------------------------------------- | ---- | ------ | ----- | ------------------------------- |
| \_reentrancyLock | uint256                                               | 0    | 0      | 32    | src/ReflexState.sol:ReflexState |
| \_owner          | address                                               | 1    | 0      | 20    | src/ReflexState.sol:ReflexState |
| \_pendingOwner   | address                                               | 2    | 0      | 20    | src/ReflexState.sol:ReflexState |
| \_modules        | mapping(uint32 => address)                            | 3    | 0      | 32    | src/ReflexState.sol:ReflexState |
| \_proxies        | mapping(uint32 => address)                            | 4    | 0      | 32    | src/ReflexState.sol:ReflexState |
| \_relations      | mapping(address => struct TReflexState.TrustRelation) | 5    | 0      | 32    | src/ReflexState.sol:ReflexState |
| \_\_gap          | uint256[44]                                           | 6    | 0      | 1408  | src/ReflexState.sol:ReflexState |

**ImplementationDispatcher**

| Name                    | Type                                                  | Slot | Offset | Bytes | Contract                                                                   |
| ----------------------- | ----------------------------------------------------- | ---- | ------ | ----- | -------------------------------------------------------------------------- |
| \_reentrancyLock        | uint256                                               | 0    | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_owner                 | address                                               | 1    | 0      | 20    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_pendingOwner          | address                                               | 2    | 0      | 20    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_modules               | mapping(uint32 => address)                            | 3    | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_proxies               | mapping(uint32 => address)                            | 4    | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_relations             | mapping(address => struct TReflexState.TrustRelation) | 5    | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_\_gap                 | uint256[44]                                           | 6    | 0      | 1408  | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_implementationState0  | bytes32                                               | 50   | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_implementationState1  | uint256                                               | 51   | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_implementationState2  | address                                               | 52   | 0      | 20    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| getImplementationState3 | address                                               | 53   | 0      | 20    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| getImplementationState4 | bool                                                  | 53   | 20     | 1     | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_implementationState5  | mapping(address => uint256)                           | 54   | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
| \_tokens                | mapping(address => struct ImplementationState.Token)  | 55   | 0      | 32    | test/implementations/ImplementationDispatcher.sol:ImplementationDispatcher |
