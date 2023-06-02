Summary

- [controlled-delegatecall](#controlled-delegatecall) (2 results) (High)
- [uninitialized-state](#uninitialized-state) (3 results) (High)
- [calls-loop](#calls-loop) (6 results) (Low)
- [low-level-calls](#low-level-calls) (5 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)

## controlled-delegatecall

Impact: High
Confidence: Medium

- [ ] ID-0
      [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L160-L178) uses delegatecall to a input-controlled function id - [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L175-L177)

../src/periphery/ReflexBatch.sol#L160-L178

- [ ] ID-1
      [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L107-L113) uses delegatecall to a input-controlled function id - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L108)

../src/ReflexBase.sol#L107-L113

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-2
      [ReflexState.\_modules](../src/ReflexState.sol#L57) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L107-L113) - [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L108-L131) - [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L160-L178)

../src/ReflexState.sol#L57

- [ ] ID-3
      [ReflexState.\_modules](../src/ReflexState.sol#L57) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L107-L113)

../src/ReflexState.sol#L57

- [ ] ID-4
      [ReflexState.\_owner](../src/ReflexState.sol#L42) is never initialized. It is used in:

../src/ReflexState.sol#L42

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-5
      [ReflexInstaller.addModules(address[])](../src/ReflexInstaller.sol#L112-L139) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L118)

../src/ReflexInstaller.sol#L112-L139

- [ ] ID-6
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L150-L189) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L156)

../src/ReflexInstaller.sol#L150-L189

- [ ] ID-7
      [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L160-L178) has external calls inside a loop: [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L175-L177)

../src/periphery/ReflexBatch.sol#L160-L178

- [ ] ID-8
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L150-L189) has external calls inside a loop: [moduleSettings*.moduleType != IReflexModule(\_modules[moduleSettings*.moduleId]).moduleType()](../src/ReflexInstaller.sol#L170)

../src/ReflexInstaller.sol#L150-L189

- [ ] ID-9
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L150-L189) has external calls inside a loop: [moduleSettings*.moduleVersion <= IReflexModule(\_modules[moduleSettings*.moduleId]).moduleVersion()](../src/ReflexInstaller.sol#L166)

../src/ReflexInstaller.sol#L150-L189

- [ ] ID-10
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L150-L189) has external calls inside a loop: [! IReflexModule(_modules[moduleSettings_.moduleId]).moduleUpgradeable()](../src/ReflexInstaller.sol#L162)

../src/ReflexInstaller.sol#L150-L189

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-11
      Low level call in [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L108-L131): - [(success,result) = _modules[\_moduleId].delegatecall(abi.encodePacked(abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector,actions_),uint160(\_unpackMessageSender()),uint160(\_unpackEndpointAddress())))](../src/periphery/ReflexBatch.sol#L114-L120)

../src/periphery/ReflexBatch.sol#L108-L131

- [ ] ID-12
      Low level call in [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L160-L178): - [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L175-L177)

../src/periphery/ReflexBatch.sol#L160-L178

- [ ] ID-13
      Low level call in [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L31-L41): - [(success,result) = contractAddress*.staticcall(callData*)](../src/periphery/ReflexBatch.sol#L34)

../src/periphery/ReflexBatch.sol#L31-L41

- [ ] ID-14
      Low level call in [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L107-L113): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L108)

../src/ReflexBase.sol#L107-L113

- [ ] ID-15
      Low level call in [ReflexEndpoint.implementation()](../src/ReflexEndpoint.sol#L62-L72): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR,\_moduleId))](../src/ReflexEndpoint.sol#L63-L65)

../src/ReflexEndpoint.sol#L62-L72

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-16
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L29) is too similar to [ReflexBase._createEndpoint(uint32,uint16,address).moduleType_](../src/ReflexBase.sol#L58)

../src/ReflexModule.sol#L29

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-17
      [ReflexBase.\_getEndpointCreationCode(uint32)](../src/ReflexBase.sol#L121-L123) uses literals with too many digits: - [abi.encodePacked(type()(ReflexEndpoint).creationCode,abi.encode(moduleId\_))](../src/ReflexBase.sol#L122)

../src/ReflexBase.sol#L121-L123
