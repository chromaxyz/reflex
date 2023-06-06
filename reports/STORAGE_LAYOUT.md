**ReflexBase**

| Name               | Type                                                  | Slot | Offset | Bytes | Contract                      |
| ------------------ | ----------------------------------------------------- | ---- | ------ | ----- | ----------------------------- |
| \_reentrancyStatus | uint256                                               | 0    | 0      | 32    | src/ReflexBase.sol:ReflexBase |
| \_owner            | address                                               | 1    | 0      | 20    | src/ReflexBase.sol:ReflexBase |
| \_pendingOwner     | address                                               | 2    | 0      | 20    | src/ReflexBase.sol:ReflexBase |
| \_modules          | mapping(uint32 => address)                            | 3    | 0      | 32    | src/ReflexBase.sol:ReflexBase |
| \_endpoints        | mapping(uint32 => address)                            | 4    | 0      | 32    | src/ReflexBase.sol:ReflexBase |
| \_relations        | mapping(address => struct IReflexState.TrustRelation) | 5    | 0      | 32    | src/ReflexBase.sol:ReflexBase |
| \_\_gap            | uint256[44]                                           | 6    | 0      | 1408  | src/ReflexBase.sol:ReflexBase |

**ReflexConstants**

| Name | Type | Slot | Offset | Bytes | Contract |
| ---- | ---- | ---- | ------ | ----- | -------- |

**ReflexDispatcher**

| Name               | Type                                                  | Slot | Offset | Bytes | Contract                                  |
| ------------------ | ----------------------------------------------------- | ---- | ------ | ----- | ----------------------------------------- |
| \_reentrancyStatus | uint256                                               | 0    | 0      | 32    | src/ReflexDispatcher.sol:ReflexDispatcher |
| \_owner            | address                                               | 1    | 0      | 20    | src/ReflexDispatcher.sol:ReflexDispatcher |
| \_pendingOwner     | address                                               | 2    | 0      | 20    | src/ReflexDispatcher.sol:ReflexDispatcher |
| \_modules          | mapping(uint32 => address)                            | 3    | 0      | 32    | src/ReflexDispatcher.sol:ReflexDispatcher |
| \_endpoints        | mapping(uint32 => address)                            | 4    | 0      | 32    | src/ReflexDispatcher.sol:ReflexDispatcher |
| \_relations        | mapping(address => struct IReflexState.TrustRelation) | 5    | 0      | 32    | src/ReflexDispatcher.sol:ReflexDispatcher |
| \_\_gap            | uint256[44]                                           | 6    | 0      | 1408  | src/ReflexDispatcher.sol:ReflexDispatcher |

**ReflexInstaller**

| Name               | Type                                                  | Slot | Offset | Bytes | Contract                                |
| ------------------ | ----------------------------------------------------- | ---- | ------ | ----- | --------------------------------------- |
| \_reentrancyStatus | uint256                                               | 0    | 0      | 32    | src/ReflexInstaller.sol:ReflexInstaller |
| \_owner            | address                                               | 1    | 0      | 20    | src/ReflexInstaller.sol:ReflexInstaller |
| \_pendingOwner     | address                                               | 2    | 0      | 20    | src/ReflexInstaller.sol:ReflexInstaller |
| \_modules          | mapping(uint32 => address)                            | 3    | 0      | 32    | src/ReflexInstaller.sol:ReflexInstaller |
| \_endpoints        | mapping(uint32 => address)                            | 4    | 0      | 32    | src/ReflexInstaller.sol:ReflexInstaller |
| \_relations        | mapping(address => struct IReflexState.TrustRelation) | 5    | 0      | 32    | src/ReflexInstaller.sol:ReflexInstaller |
| \_\_gap            | uint256[44]                                           | 6    | 0      | 1408  | src/ReflexInstaller.sol:ReflexInstaller |

**ReflexModule**

| Name               | Type                                                  | Slot | Offset | Bytes | Contract                          |
| ------------------ | ----------------------------------------------------- | ---- | ------ | ----- | --------------------------------- |
| \_reentrancyStatus | uint256                                               | 0    | 0      | 32    | src/ReflexModule.sol:ReflexModule |
| \_owner            | address                                               | 1    | 0      | 20    | src/ReflexModule.sol:ReflexModule |
| \_pendingOwner     | address                                               | 2    | 0      | 20    | src/ReflexModule.sol:ReflexModule |
| \_modules          | mapping(uint32 => address)                            | 3    | 0      | 32    | src/ReflexModule.sol:ReflexModule |
| \_endpoints        | mapping(uint32 => address)                            | 4    | 0      | 32    | src/ReflexModule.sol:ReflexModule |
| \_relations        | mapping(address => struct IReflexState.TrustRelation) | 5    | 0      | 32    | src/ReflexModule.sol:ReflexModule |
| \_\_gap            | uint256[44]                                           | 6    | 0      | 1408  | src/ReflexModule.sol:ReflexModule |

**ReflexEndpoint**

| Name | Type | Slot | Offset | Bytes | Contract |
| ---- | ---- | ---- | ------ | ----- | -------- |

**ReflexState**

| Name               | Type                                                  | Slot | Offset | Bytes | Contract                        |
| ------------------ | ----------------------------------------------------- | ---- | ------ | ----- | ------------------------------- |
| \_reentrancyStatus | uint256                                               | 0    | 0      | 32    | src/ReflexState.sol:ReflexState |
| \_owner            | address                                               | 1    | 0      | 20    | src/ReflexState.sol:ReflexState |
| \_pendingOwner     | address                                               | 2    | 0      | 20    | src/ReflexState.sol:ReflexState |
| \_modules          | mapping(uint32 => address)                            | 3    | 0      | 32    | src/ReflexState.sol:ReflexState |
| \_endpoints        | mapping(uint32 => address)                            | 4    | 0      | 32    | src/ReflexState.sol:ReflexState |
| \_relations        | mapping(address => struct IReflexState.TrustRelation) | 5    | 0      | 32    | src/ReflexState.sol:ReflexState |
| \_\_gap            | uint256[44]                                           | 6    | 0      | 1408  | src/ReflexState.sol:ReflexState |

**ReflexBatch**

| Name               | Type                                                  | Slot | Offset | Bytes | Contract                                  |
| ------------------ | ----------------------------------------------------- | ---- | ------ | ----- | ----------------------------------------- |
| \_reentrancyStatus | uint256                                               | 0    | 0      | 32    | src/periphery/ReflexBatch.sol:ReflexBatch |
| \_owner            | address                                               | 1    | 0      | 20    | src/periphery/ReflexBatch.sol:ReflexBatch |
| \_pendingOwner     | address                                               | 2    | 0      | 20    | src/periphery/ReflexBatch.sol:ReflexBatch |
| \_modules          | mapping(uint32 => address)                            | 3    | 0      | 32    | src/periphery/ReflexBatch.sol:ReflexBatch |
| \_endpoints        | mapping(uint32 => address)                            | 4    | 0      | 32    | src/periphery/ReflexBatch.sol:ReflexBatch |
| \_relations        | mapping(address => struct IReflexState.TrustRelation) | 5    | 0      | 32    | src/periphery/ReflexBatch.sol:ReflexBatch |
| \_\_gap            | uint256[44]                                           | 6    | 0      | 1408  | src/periphery/ReflexBatch.sol:ReflexBatch |

**MockImplementationDispatcher**

| Name                   | Type                                                  | Slot | Offset | Bytes | Contract                                                                 |
| ---------------------- | ----------------------------------------------------- | ---- | ------ | ----- | ------------------------------------------------------------------------ |
| \_reentrancyStatus     | uint256                                               | 0    | 0      | 32    | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_owner                | address                                               | 1    | 0      | 20    | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_pendingOwner         | address                                               | 2    | 0      | 20    | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_modules              | mapping(uint32 => address)                            | 3    | 0      | 32    | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_endpoints            | mapping(uint32 => address)                            | 4    | 0      | 32    | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_relations            | mapping(address => struct IReflexState.TrustRelation) | 5    | 0      | 32    | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_\_gap                | uint256[44]                                           | 6    | 0      | 1408  | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_implementationState0 | bytes32                                               | 50   | 0      | 32    | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_implementationState1 | uint256                                               | 51   | 0      | 32    | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_implementationState2 | address                                               | 52   | 0      | 20    | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_implementationState3 | address                                               | 53   | 0      | 20    | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_implementationState4 | bool                                                  | 53   | 20     | 1     | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_implementationState5 | mapping(address => uint256)                           | 54   | 0      | 32    | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_tokens               | mapping(address => struct ImplementationState.Token)  | 55   | 0      | 32    | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| IS_TEST                | bool                                                  | 56   | 0      | 1     | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| \_failed               | bool                                                  | 56   | 1      | 1     | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
| stdstore               | struct StdStorage                                     | 57   | 0      | 224   | test/mocks/MockImplementationDispatcher.sol:MockImplementationDispatcher |
