Summary

- [controlled-delegatecall](#controlled-delegatecall) (2 results) (High)
- [uninitialized-state](#uninitialized-state) (3 results) (High)
- [missing-zero-check](#missing-zero-check) (1 results) (Low)
- [calls-loop](#calls-loop) (6 results) (Low)
- [assembly](#assembly) (9 results) (Informational)
- [low-level-calls](#low-level-calls) (5 results) (Informational)
- [naming-convention](#naming-convention) (13 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)

## controlled-delegatecall

Impact: High
Confidence: Medium

- [ ] ID-0
      [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L88-L94) uses delegatecall to a input-controlled function id - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L89)

../src/ReflexBase.sol#L88-L94

- [ ] ID-1
      [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L130-L149) uses delegatecall to a input-controlled function id - [(success*,returnData*) = moduleImplementation*.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender\_),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L146-L148)

../src/periphery/ReflexBatch.sol#L130-L149

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-2
      [ReflexState.\_modules](../src/ReflexState.sol#L57) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L88-L94) - [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L97-L117) - [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L130-L149)

../src/ReflexState.sol#L57

- [ ] ID-3
      [ReflexState.\_modules](../src/ReflexState.sol#L57) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L88-L94)

../src/ReflexState.sol#L57

- [ ] ID-4
      [ReflexState.\_owner](../src/ReflexState.sol#L42) is never initialized. It is used in:

../src/ReflexState.sol#L42

## missing-zero-check

Impact: Low
Confidence: Medium

- [ ] ID-5
      [ReflexBatch.performStaticCall(address,bytes).contractAddress\_](../src/periphery/ReflexBatch.sol#L30) lacks a zero-check on : - [(success,result) = contractAddress*.staticcall(payload*)](../src/periphery/ReflexBatch.sol#L31)

../src/periphery/ReflexBatch.sol#L30

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
      [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L130-L149) has external calls inside a loop: [(success*,returnData*) = moduleImplementation*.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender\_),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L146-L148)

../src/periphery/ReflexBatch.sol#L130-L149

- [ ] ID-11
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [moduleSettings*.moduleVersion <= IReflexModule(\_modules[moduleSettings*.moduleId]).moduleVersion()](../src/ReflexInstaller.sol#L163)

../src/ReflexInstaller.sol#L147-L183

## assembly

Impact: Informational
Confidence: High

- [ ] ID-12
      [ReflexBase.\_unpackTrailingParameters()](../src/ReflexBase.sol#L125-L137) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L133-L136)

../src/ReflexBase.sol#L125-L137

- [ ] ID-13
      [ReflexBase.\_revertBytes(bytes)](../src/ReflexBase.sol#L143-L152) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L146-L148)

../src/ReflexBase.sol#L143-L152

- [ ] ID-14
      [ReflexDispatcher.fallback()](../src/ReflexDispatcher.sol#L83-L121) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L97-L120)

../src/ReflexDispatcher.sol#L83-L121

- [ ] ID-15
      [ReflexBase.\_unpackEndpointAddress()](../src/ReflexBase.sol#L112-L118) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L115-L117)

../src/ReflexBase.sol#L112-L118

- [ ] ID-16
      [ReflexBase.\_unpackMessageSender()](../src/ReflexBase.sol#L100-L106) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L103-L105)

../src/ReflexBase.sol#L100-L106

- [ ] ID-17
      [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L97-L117) uses assembly - [INLINE ASM](../src/periphery/ReflexBatch.sol#L112-L114)

../src/periphery/ReflexBatch.sol#L97-L117

- [ ] ID-18
      [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L30-L38) uses assembly - [INLINE ASM](../src/periphery/ReflexBatch.sol#L35-L37)

../src/periphery/ReflexBatch.sol#L30-L38

- [ ] ID-19
      [ReflexEndpoint.sentinel()](../src/ReflexEndpoint.sol#L76-L91) uses assembly - [INLINE ASM](../src/ReflexEndpoint.sol#L83-L86)

../src/ReflexEndpoint.sol#L76-L91

- [ ] ID-20
      [ReflexEndpoint.\_fallback()](../src/ReflexEndpoint.sol#L100-L181) uses assembly - [INLINE ASM](../src/ReflexEndpoint.sol#L106-L151) - [INLINE ASM](../src/ReflexEndpoint.sol#L154-L179)

../src/ReflexEndpoint.sol#L100-L181

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-21
      Low level call in [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L88-L94): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L89)

../src/ReflexBase.sol#L88-L94

- [ ] ID-22
      Low level call in [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L97-L117): - [(success,result) = _modules[\_moduleId].delegatecall(abi.encodePacked(abi.encodeWithSelector(ReflexBatch.simulateBatchCallRevert.selector,actions_),uint160(\_unpackMessageSender()),uint160(\_unpackEndpointAddress())))](../src/periphery/ReflexBatch.sol#L100-L106)

../src/periphery/ReflexBatch.sol#L97-L117

- [ ] ID-23
      Low level call in [ReflexEndpoint.implementation()](../src/ReflexEndpoint.sol#L60-L70): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR,\_moduleId))](../src/ReflexEndpoint.sol#L61-L63)

../src/ReflexEndpoint.sol#L60-L70

- [ ] ID-24
      Low level call in [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L30-L38): - [(success,result) = contractAddress*.staticcall(payload*)](../src/periphery/ReflexBatch.sol#L31)

../src/periphery/ReflexBatch.sol#L30-L38

- [ ] ID-25
      Low level call in [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L130-L149): - [(success*,returnData*) = moduleImplementation*.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender\_),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L146-L148)

../src/periphery/ReflexBatch.sol#L130-L149

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-26
      Variable [ReflexState.\_pendingOwner](../src/ReflexState.sol#L49) is not in mixedCase

../src/ReflexState.sol#L49

- [ ] ID-27
      Variable [ReflexModule.\_moduleId](../src/ReflexModule.sol#L24) is not in mixedCase

../src/ReflexModule.sol#L24

- [ ] ID-28
      Variable [ReflexState.\_reentrancyLock](../src/ReflexState.sol#L35) is not in mixedCase

../src/ReflexState.sol#L35

- [ ] ID-29
      Variable [ReflexEndpoint.\_deployer](../src/ReflexEndpoint.sol#L35) is not in mixedCase

../src/ReflexEndpoint.sol#L35

- [ ] ID-30
      Variable [ReflexState.\_modules](../src/ReflexState.sol#L57) is not in mixedCase

../src/ReflexState.sol#L57

- [ ] ID-31
      Variable [ReflexEndpoint.\_moduleId](../src/ReflexEndpoint.sol#L30) is not in mixedCase

../src/ReflexEndpoint.sol#L30

- [ ] ID-32
      Variable [ReflexModule.\_moduleVersion](../src/ReflexModule.sol#L34) is not in mixedCase

../src/ReflexModule.sol#L34

- [ ] ID-33
      Variable [ReflexModule.\_moduleUpgradeable](../src/ReflexModule.sol#L39) is not in mixedCase

../src/ReflexModule.sol#L39

- [ ] ID-34
      Variable [ReflexState.\_\_gap](../src/ReflexState.sol#L83) is not in mixedCase

../src/ReflexState.sol#L83

- [ ] ID-35
      Variable [ReflexState.\_owner](../src/ReflexState.sol#L42) is not in mixedCase

../src/ReflexState.sol#L42

- [ ] ID-36
      Variable [ReflexState.\_endpoints](../src/ReflexState.sol#L65) is not in mixedCase

../src/ReflexState.sol#L65

- [ ] ID-37
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L29) is not in mixedCase

../src/ReflexModule.sol#L29

- [ ] ID-38
      Variable [ReflexState.\_relations](../src/ReflexState.sol#L73) is not in mixedCase

../src/ReflexState.sol#L73

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-39
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L29) is too similar to [ReflexBase._createEndpoint(uint32,uint16,address).moduleType_](../src/ReflexBase.sol#L58)

../src/ReflexModule.sol#L29
