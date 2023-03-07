Summary

- [controlled-delegatecall](#controlled-delegatecall) (2 results) (High)
- [uninitialized-state](#uninitialized-state) (3 results) (High)
- [missing-zero-check](#missing-zero-check) (1 results) (Low)
- [calls-loop](#calls-loop) (6 results) (Low)
- [low-level-calls](#low-level-calls) (5 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)

## controlled-delegatecall

Impact: High
Confidence: Medium

- [ ] ID-0
      [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L134-L153) uses delegatecall to a input-controlled function id - [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L150-L152)

../src/periphery/ReflexBatch.sol#L134-L153

- [ ] ID-1
      [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L97-L103) uses delegatecall to a input-controlled function id - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L98)

../src/ReflexBase.sol#L97-L103

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-2
      [ReflexState.\_modules](../src/ReflexState.sol#L57) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L97-L103) - [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L98-L121) - [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L134-L153)

../src/ReflexState.sol#L57

- [ ] ID-3
      [ReflexState.\_modules](../src/ReflexState.sol#L57) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L97-L103)

../src/ReflexState.sol#L57

- [ ] ID-4
      [ReflexState.\_owner](../src/ReflexState.sol#L42) is never initialized. It is used in:

../src/ReflexState.sol#L42

## missing-zero-check

Impact: Low
Confidence: Medium

- [ ] ID-5
      [ReflexBatch.performStaticCall(address,bytes).contractAddress\_](../src/periphery/ReflexBatch.sol#L31) lacks a zero-check on : - [(success,result) = contractAddress*.staticcall(callData*)](../src/periphery/ReflexBatch.sol#L32)

../src/periphery/ReflexBatch.sol#L31

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-6
      [ReflexInstaller.addModules(address[])](../src/ReflexInstaller.sol#L112-L136) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L118)

../src/ReflexInstaller.sol#L112-L136

- [ ] ID-7
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [moduleSettings*.moduleType != IReflexModule(\_modules[moduleSettings*.moduleId]).moduleType()](../src/ReflexInstaller.sol#L167)

../src/ReflexInstaller.sol#L147-L183

- [ ] ID-8
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [! IReflexModule(_modules[moduleSettings_.moduleId]).moduleUpgradeable()](../src/ReflexInstaller.sol#L159)

../src/ReflexInstaller.sol#L147-L183

- [ ] ID-9
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L153)

../src/ReflexInstaller.sol#L147-L183

- [ ] ID-10
      [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L134-L153) has external calls inside a loop: [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L150-L152)

../src/periphery/ReflexBatch.sol#L134-L153

- [ ] ID-11
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [moduleSettings*.moduleVersion <= IReflexModule(\_modules[moduleSettings*.moduleId]).moduleVersion()](../src/ReflexInstaller.sol#L163)

../src/ReflexInstaller.sol#L147-L183

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-12
      Low level call in [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L134-L153): - [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L150-L152)

../src/periphery/ReflexBatch.sol#L134-L153

- [ ] ID-13
      Low level call in [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L98-L121): - [(success,result) = _modules[\_moduleId].delegatecall(abi.encodePacked(abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector,actions_),uint160(\_unpackMessageSender()),uint160(\_unpackEndpointAddress())))](../src/periphery/ReflexBatch.sol#L104-L110)

../src/periphery/ReflexBatch.sol#L98-L121

- [ ] ID-14
      Low level call in [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L31-L39): - [(success,result) = contractAddress*.staticcall(callData*)](../src/periphery/ReflexBatch.sol#L32)

../src/periphery/ReflexBatch.sol#L31-L39

- [ ] ID-15
      Low level call in [ReflexEndpoint.implementation()](../src/ReflexEndpoint.sol#L60-L70): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR,\_moduleId))](../src/ReflexEndpoint.sol#L61-L63)

../src/ReflexEndpoint.sol#L60-L70

- [ ] ID-16
      Low level call in [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L97-L103): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L98)

../src/ReflexBase.sol#L97-L103

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-17
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L29) is too similar to [ReflexBase._createEndpoint(uint32,uint16,address).moduleType_](../src/ReflexBase.sol#L58)

../src/ReflexModule.sol#L29
