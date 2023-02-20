Summary

- [uninitialized-state](#uninitialized-state) (3 results) (High)
- [calls-loop](#calls-loop) (6 results) (Low)
- [assembly](#assembly) (7 results) (Informational)
- [low-level-calls](#low-level-calls) (3 results) (Informational)
- [naming-convention](#naming-convention) (13 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-0
      [ReflexState.\_modules](../src/ReflexState.sol#L53) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L88-L94)

../src/ReflexState.sol#L53

- [ ] ID-1
      [ReflexState.\_modules](../src/ReflexState.sol#L53) is never initialized. It is used in: - [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L80-L99) - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L88-L94)

../src/ReflexState.sol#L53

- [ ] ID-2
      [ReflexState.\_owner](../src/ReflexState.sol#L40) is never initialized. It is used in:

../src/ReflexState.sol#L40

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-3
      [ReflexInstaller.addModules(address[])](../src/ReflexInstaller.sol#L112-L136) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L118)

../src/ReflexInstaller.sol#L112-L136

- [ ] ID-4
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [moduleSettings*.moduleType != IReflexModule(\_modules[moduleSettings*.moduleId]).moduleType()](../src/ReflexInstaller.sol#L167)

../src/ReflexInstaller.sol#L147-L183

- [ ] ID-5
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [! IReflexModule(_modules[moduleSettings_.moduleId]).moduleUpgradeable()](../src/ReflexInstaller.sol#L159)

../src/ReflexInstaller.sol#L147-L183

- [ ] ID-6
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L153)

../src/ReflexInstaller.sol#L147-L183

- [ ] ID-7
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [moduleSettings*.moduleVersion <= IReflexModule(\_modules[moduleSettings*.moduleId]).moduleVersion()](../src/ReflexInstaller.sol#L163)

../src/ReflexInstaller.sol#L147-L183

- [ ] ID-8
      [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L80-L99) has external calls inside a loop: [(success*,returnData*) = moduleImplementation*.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender\_),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L96-L98)

../src/periphery/ReflexBatch.sol#L80-L99

## assembly

Impact: Informational
Confidence: High

- [ ] ID-9
      [ReflexBase.\_unpackTrailingParameters()](../src/ReflexBase.sol#L125-L137) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L133-L136)

../src/ReflexBase.sol#L125-L137

- [ ] ID-10
      [ReflexBase.\_revertBytes(bytes)](../src/ReflexBase.sol#L143-L152) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L146-L148)

../src/ReflexBase.sol#L143-L152

- [ ] ID-11
      [ReflexDispatcher.fallback()](../src/ReflexDispatcher.sol#L83-L121) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L97-L120)

../src/ReflexDispatcher.sol#L83-L121

- [ ] ID-12
      [ReflexBase.\_unpackEndpointAddress()](../src/ReflexBase.sol#L112-L118) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L115-L117)

../src/ReflexBase.sol#L112-L118

- [ ] ID-13
      [ReflexBase.\_unpackMessageSender()](../src/ReflexBase.sol#L100-L106) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L103-L105)

../src/ReflexBase.sol#L100-L106

- [ ] ID-14
      [ReflexEndpoint.sentinel()](../src/ReflexEndpoint.sol#L76-L91) uses assembly - [INLINE ASM](../src/ReflexEndpoint.sol#L83-L86)

../src/ReflexEndpoint.sol#L76-L91

- [ ] ID-15
      [ReflexEndpoint.\_fallback()](../src/ReflexEndpoint.sol#L100-L181) uses assembly - [INLINE ASM](../src/ReflexEndpoint.sol#L106-L151) - [INLINE ASM](../src/ReflexEndpoint.sol#L154-L179)

../src/ReflexEndpoint.sol#L100-L181

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-16
      Low level call in [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L88-L94): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L89)

../src/ReflexBase.sol#L88-L94

- [ ] ID-17
      Low level call in [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L80-L99): - [(success*,returnData*) = moduleImplementation*.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender\_),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L96-L98)

../src/periphery/ReflexBatch.sol#L80-L99

- [ ] ID-18
      Low level call in [ReflexEndpoint.implementation()](../src/ReflexEndpoint.sol#L60-L70): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR,\_moduleId))](../src/ReflexEndpoint.sol#L61-L63)

../src/ReflexEndpoint.sol#L60-L70

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-19
      Variable [ReflexState.\_pendingOwner](../src/ReflexState.sol#L46) is not in mixedCase

../src/ReflexState.sol#L46

- [ ] ID-20
      Variable [ReflexModule.\_moduleId](../src/ReflexModule.sol#L24) is not in mixedCase

../src/ReflexModule.sol#L24

- [ ] ID-21
      Variable [ReflexState.\_reentrancyLock](../src/ReflexState.sol#L34) is not in mixedCase

../src/ReflexState.sol#L34

- [ ] ID-22
      Variable [ReflexEndpoint.\_deployer](../src/ReflexEndpoint.sol#L35) is not in mixedCase

../src/ReflexEndpoint.sol#L35

- [ ] ID-23
      Variable [ReflexState.\_modules](../src/ReflexState.sol#L53) is not in mixedCase

../src/ReflexState.sol#L53

- [ ] ID-24
      Variable [ReflexEndpoint.\_moduleId](../src/ReflexEndpoint.sol#L30) is not in mixedCase

../src/ReflexEndpoint.sol#L30

- [ ] ID-25
      Variable [ReflexModule.\_moduleVersion](../src/ReflexModule.sol#L34) is not in mixedCase

../src/ReflexModule.sol#L34

- [ ] ID-26
      Variable [ReflexModule.\_moduleUpgradeable](../src/ReflexModule.sol#L39) is not in mixedCase

../src/ReflexModule.sol#L39

- [ ] ID-27
      Variable [ReflexState.\_\_gap](../src/ReflexState.sol#L76) is not in mixedCase

../src/ReflexState.sol#L76

- [ ] ID-28
      Variable [ReflexState.\_owner](../src/ReflexState.sol#L40) is not in mixedCase

../src/ReflexState.sol#L40

- [ ] ID-29
      Variable [ReflexState.\_proxies](../src/ReflexState.sol#L60) is not in mixedCase

../src/ReflexState.sol#L60

- [ ] ID-30
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L29) is not in mixedCase

../src/ReflexModule.sol#L29

- [ ] ID-31
      Variable [ReflexState.\_relations](../src/ReflexState.sol#L67) is not in mixedCase

../src/ReflexState.sol#L67

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-32
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L29) is too similar to [ReflexBase._createEndpoint(uint32,uint16,address).moduleType_](../src/ReflexBase.sol#L58)

../src/ReflexModule.sol#L29
