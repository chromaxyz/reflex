**THIS CHECKLIST IS NOT COMPLETE**. Use `--show-ignored-findings` to show all the results.
Summary

- [controlled-delegatecall](#controlled-delegatecall) (2 results) (High)
- [uninitialized-state](#uninitialized-state) (3 results) (High)
- [calls-loop](#calls-loop) (6 results) (Low)
- [low-level-calls](#low-level-calls) (5 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)
- [constable-states](#constable-states) (2 results) (Optimization)
- [immutable-states](#immutable-states) (1 results) (Optimization)

## controlled-delegatecall

Impact: High
Confidence: Medium

- [ ] ID-0
      [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L119-L125) uses delegatecall to a input-controlled function id - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L120)

../src/ReflexBase.sol#L119-L125

- [ ] ID-1
      [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L143-L161) uses delegatecall to a input-controlled function id - [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L158-L160)

../src/periphery/ReflexBatch.sol#L143-L161

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-2
      [ReflexState.\_modules](../src/ReflexState.sol#L53) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L119-L125) - [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L91-L114) - [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L143-L161)

../src/ReflexState.sol#L53

- [ ] ID-3
      [ReflexState.\_modules](../src/ReflexState.sol#L53) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L119-L125)

../src/ReflexState.sol#L53

- [ ] ID-4
      [ReflexState.\_owner](../src/ReflexState.sol#L40) is never initialized. It is used in:

../src/ReflexState.sol#L40

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-5
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L116-L155) has external calls inside a loop: [moduleSettings*.moduleVersion <= IReflexModule(\_modules[moduleSettings*.moduleId]).moduleVersion()](../src/ReflexInstaller.sol#L132)

../src/ReflexInstaller.sol#L116-L155

- [ ] ID-6
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L116-L155) has external calls inside a loop: [moduleSettings*.moduleType != IReflexModule(\_modules[moduleSettings*.moduleId]).moduleType()](../src/ReflexInstaller.sol#L136)

../src/ReflexInstaller.sol#L116-L155

- [ ] ID-7
      [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L143-L161) has external calls inside a loop: [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L158-L160)

../src/periphery/ReflexBatch.sol#L143-L161

- [ ] ID-8
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L116-L155) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L122)

../src/ReflexInstaller.sol#L116-L155

- [ ] ID-9
      [ReflexInstaller.addModules(address[])](../src/ReflexInstaller.sol#L84-L111) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L90)

../src/ReflexInstaller.sol#L84-L111

- [ ] ID-10
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L116-L155) has external calls inside a loop: [! IReflexModule(_modules[moduleSettings_.moduleId]).moduleUpgradeable()](../src/ReflexInstaller.sol#L128)

../src/ReflexInstaller.sol#L116-L155

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-11
      Low level call in [ReflexEndpoint.implementation()](../src/ReflexEndpoint.sol#L61-L71): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR,\_moduleId))](../src/ReflexEndpoint.sol#L62-L64)

../src/ReflexEndpoint.sol#L61-L71

- [ ] ID-12
      Low level call in [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L24-L34): - [(success,result) = contractAddress*.staticcall(callData*)](../src/periphery/ReflexBatch.sol#L27)

../src/periphery/ReflexBatch.sol#L24-L34

- [ ] ID-13
      Low level call in [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L91-L114): - [(success,result) = _modules[\_moduleId].delegatecall(abi.encodePacked(abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector,actions_),uint160(\_unpackMessageSender()),uint160(\_unpackEndpointAddress())))](../src/periphery/ReflexBatch.sol#L97-L103)

../src/periphery/ReflexBatch.sol#L91-L114

- [ ] ID-14
      Low level call in [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L143-L161): - [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L158-L160)

../src/periphery/ReflexBatch.sol#L143-L161

- [ ] ID-15
      Low level call in [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L119-L125): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L120)

../src/ReflexBase.sol#L119-L125

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-16
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L29) is too similar to [ReflexBase._createEndpoint(uint32,uint16,address).moduleType_](../src/ReflexBase.sol#L70)

../src/ReflexModule.sol#L29

## constable-states

Impact: Optimization
Confidence: High

- [ ] ID-17
      [ReflexState.\_owner](../src/ReflexState.sol#L40) should be constant

../src/ReflexState.sol#L40

- [ ] ID-18
      [ReflexState.\_pendingOwner](../src/ReflexState.sol#L46) should be constant

../src/ReflexState.sol#L46

## immutable-states

Impact: Optimization
Confidence: High

- [ ] ID-19
      [ReflexState.\_owner](../src/ReflexState.sol#L40) should be immutable

../src/ReflexState.sol#L40
