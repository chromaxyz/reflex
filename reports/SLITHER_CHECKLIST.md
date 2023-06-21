Summary

- [controlled-delegatecall](#controlled-delegatecall) (2 results) (High)
- [uninitialized-state](#uninitialized-state) (3 results) (High)
- [calls-loop](#calls-loop) (6 results) (Low)
- [assembly](#assembly) (10 results) (Informational)
- [solc-version](#solc-version) (16 results) (Informational)
- [low-level-calls](#low-level-calls) (5 results) (Informational)
- [naming-convention](#naming-convention) (13 results) (Informational)
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
      [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L144-L162) uses delegatecall to a input-controlled function id - [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L159-L161)

../src/periphery/ReflexBatch.sol#L144-L162

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-2
      [ReflexState.\_modules](../src/ReflexState.sol#L62) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L119-L125) - [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L91-L115) - [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L144-L162)

../src/ReflexState.sol#L62

- [ ] ID-3
      [ReflexState.\_modules](../src/ReflexState.sol#L62) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L119-L125)

../src/ReflexState.sol#L62

- [ ] ID-4
      [ReflexState.\_owner](../src/ReflexState.sol#L45) is never initialized. It is used in:

../src/ReflexState.sol#L45

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
      [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L144-L162) has external calls inside a loop: [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L159-L161)

../src/periphery/ReflexBatch.sol#L144-L162

- [ ] ID-8
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L116-L155) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L122)

../src/ReflexInstaller.sol#L116-L155

- [ ] ID-9
      [ReflexInstaller.addModules(address[])](../src/ReflexInstaller.sol#L84-L111) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L90)

../src/ReflexInstaller.sol#L84-L111

- [ ] ID-10
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L116-L155) has external calls inside a loop: [! IReflexModule(_modules[moduleSettings_.moduleId]).moduleUpgradeable()](../src/ReflexInstaller.sol#L128)

../src/ReflexInstaller.sol#L116-L155

## assembly

Impact: Informational
Confidence: High

- [ ] ID-11
      [ReflexDispatcher.fallback()](../src/ReflexDispatcher.sol#L77-L115) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L91-L114)

../src/ReflexDispatcher.sol#L77-L115

- [ ] ID-12
      [ReflexBase.\_revertBytes(bytes)](../src/ReflexBase.sol#L171-L179) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L173-L175)

../src/ReflexBase.sol#L171-L179

- [ ] ID-13
      [ReflexBase.\_unpackTrailingParameters()](../src/ReflexBase.sol#L154-L165) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L161-L164)

../src/ReflexBase.sol#L154-L165

- [ ] ID-14
      [ReflexEndpoint.\_fallback()](../src/ReflexEndpoint.sol#L100-L182) uses assembly - [INLINE ASM](../src/ReflexEndpoint.sol#L106-L151) - [INLINE ASM](../src/ReflexEndpoint.sol#L154-L180)

../src/ReflexEndpoint.sol#L100-L182

- [ ] ID-15
      [ReflexBase.\_unpackEndpointAddress()](../src/ReflexBase.sol#L142-L147) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L144-L146)

../src/ReflexBase.sol#L142-L147

- [ ] ID-16
      [ReflexBase.\_unpackMessageSender()](../src/ReflexBase.sol#L131-L136) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L133-L135)

../src/ReflexBase.sol#L131-L136

- [ ] ID-17
      [ReflexBase.\_createEndpoint(uint32,uint16,address)](../src/ReflexBase.sol#L68-L102) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L81-L91)

../src/ReflexBase.sol#L68-L102

- [ ] ID-18
      [ReflexEndpoint.sentinel()](../src/ReflexEndpoint.sol#L76-L91) uses assembly - [INLINE ASM](../src/ReflexEndpoint.sol#L83-L86)

../src/ReflexEndpoint.sol#L76-L91

- [ ] ID-19
      [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L24-L34) uses assembly - [INLINE ASM](../src/periphery/ReflexBatch.sol#L31-L33)

../src/periphery/ReflexBatch.sol#L24-L34

- [ ] ID-20
      [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L91-L115) uses assembly - [INLINE ASM](../src/periphery/ReflexBatch.sol#L110-L112)

../src/periphery/ReflexBatch.sol#L91-L115

## solc-version

Impact: Informational
Confidence: High

- [ ] ID-21
      Pragma version[^0.8.13](../src/interfaces/IReflexModule.sol#L2) allows old versions

../src/interfaces/IReflexModule.sol#L2

- [ ] ID-22
      Pragma version[^0.8.13](../src/periphery/ReflexBatch.sol#L2) allows old versions

../src/periphery/ReflexBatch.sol#L2

- [ ] ID-23
      Pragma version[^0.8.13](../src/interfaces/IReflexDispatcher.sol#L2) allows old versions

../src/interfaces/IReflexDispatcher.sol#L2

- [ ] ID-24
      Pragma version[^0.8.13](../src/ReflexBase.sol#L2) allows old versions

../src/ReflexBase.sol#L2

- [ ] ID-25
      Pragma version[^0.8.13](../src/interfaces/IReflexEndpoint.sol#L2) allows old versions

../src/interfaces/IReflexEndpoint.sol#L2

- [ ] ID-26
      Pragma version[^0.8.13](../src/interfaces/IReflexState.sol#L2) allows old versions

../src/interfaces/IReflexState.sol#L2

- [ ] ID-27
      Pragma version[^0.8.13](../src/interfaces/IReflexInstaller.sol#L2) allows old versions

../src/interfaces/IReflexInstaller.sol#L2

- [ ] ID-28
      Pragma version[^0.8.13](../src/ReflexEndpoint.sol#L2) allows old versions

../src/ReflexEndpoint.sol#L2

- [ ] ID-29
      Pragma version[^0.8.13](../src/periphery/interfaces/IReflexBatch.sol#L2) allows old versions

../src/periphery/interfaces/IReflexBatch.sol#L2

- [ ] ID-30
      Pragma version[^0.8.13](../src/ReflexConstants.sol#L2) allows old versions

../src/ReflexConstants.sol#L2

- [ ] ID-31
      Pragma version[^0.8.13](../src/ReflexModule.sol#L2) allows old versions

../src/ReflexModule.sol#L2

- [ ] ID-32
      solc-0.8.19 is not recommended for deployment

- [ ] ID-33
      Pragma version[^0.8.13](../src/ReflexState.sol#L2) allows old versions

../src/ReflexState.sol#L2

- [ ] ID-34
      Pragma version[^0.8.13](../src/interfaces/IReflexBase.sol#L2) allows old versions

../src/interfaces/IReflexBase.sol#L2

- [ ] ID-35
      Pragma version[^0.8.13](../src/ReflexInstaller.sol#L2) allows old versions

../src/ReflexInstaller.sol#L2

- [ ] ID-36
      Pragma version[^0.8.13](../src/ReflexDispatcher.sol#L2) allows old versions

../src/ReflexDispatcher.sol#L2

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-37
      Low level call in [ReflexEndpoint.implementation()](../src/ReflexEndpoint.sol#L61-L71): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR,\_moduleId))](../src/ReflexEndpoint.sol#L62-L64)

../src/ReflexEndpoint.sol#L61-L71

- [ ] ID-38
      Low level call in [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L91-L115): - [(success,result) = _modules[\_moduleId].delegatecall(abi.encodePacked(abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector,actions_),uint160(\_unpackMessageSender()),uint160(\_unpackEndpointAddress())))](../src/periphery/ReflexBatch.sol#L98-L104)

../src/periphery/ReflexBatch.sol#L91-L115

- [ ] ID-39
      Low level call in [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L24-L34): - [(success,result) = contractAddress*.staticcall(callData*)](../src/periphery/ReflexBatch.sol#L27)

../src/periphery/ReflexBatch.sol#L24-L34

- [ ] ID-40
      Low level call in [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L144-L162): - [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L159-L161)

../src/periphery/ReflexBatch.sol#L144-L162

- [ ] ID-41
      Low level call in [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L119-L125): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L120)

../src/ReflexBase.sol#L119-L125

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-42
      Variable [ReflexState.\_pendingOwner](../src/ReflexState.sol#L51) is not in mixedCase

../src/ReflexState.sol#L51

- [ ] ID-43
      Variable [ReflexModule.\_moduleId](../src/ReflexModule.sol#L24) is not in mixedCase

../src/ReflexModule.sol#L24

- [ ] ID-44
      Variable [ReflexEndpoint.\_deployer](../src/ReflexEndpoint.sol#L35) is not in mixedCase

../src/ReflexEndpoint.sol#L35

- [ ] ID-45
      Variable [ReflexState.\_modules](../src/ReflexState.sol#L62) is not in mixedCase

../src/ReflexState.sol#L62

- [ ] ID-46
      Variable [ReflexEndpoint.\_moduleId](../src/ReflexEndpoint.sol#L30) is not in mixedCase

../src/ReflexEndpoint.sol#L30

- [ ] ID-47
      Variable [ReflexModule.\_moduleVersion](../src/ReflexModule.sol#L34) is not in mixedCase

../src/ReflexModule.sol#L34

- [ ] ID-48
      Variable [ReflexModule.\_moduleUpgradeable](../src/ReflexModule.sol#L39) is not in mixedCase

../src/ReflexModule.sol#L39

- [ ] ID-49
      Variable [ReflexState.\_\_REFLEX_GAP](../src/ReflexState.sol#L91) is not in mixedCase

../src/ReflexState.sol#L91

- [ ] ID-50
      Variable [ReflexState.\_reentrancyStatus](../src/ReflexState.sol#L35) is not in mixedCase

../src/ReflexState.sol#L35

- [ ] ID-51
      Variable [ReflexState.\_owner](../src/ReflexState.sol#L45) is not in mixedCase

../src/ReflexState.sol#L45

- [ ] ID-52
      Variable [ReflexState.\_endpoints](../src/ReflexState.sol#L69) is not in mixedCase

../src/ReflexState.sol#L69

- [ ] ID-53
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L29) is not in mixedCase

../src/ReflexModule.sol#L29

- [ ] ID-54
      Variable [ReflexState.\_relations](../src/ReflexState.sol#L76) is not in mixedCase

../src/ReflexState.sol#L76

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-55
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L29) is too similar to [ReflexBase._createEndpoint(uint32,uint16,address).moduleType_](../src/ReflexBase.sol#L70)

../src/ReflexModule.sol#L29

## constable-states

Impact: Optimization
Confidence: High

- [ ] ID-56
      [ReflexState.\_owner](../src/ReflexState.sol#L45) should be constant

../src/ReflexState.sol#L45

- [ ] ID-57
      [ReflexState.\_pendingOwner](../src/ReflexState.sol#L51) should be constant

../src/ReflexState.sol#L51

## immutable-states

Impact: Optimization
Confidence: High

- [ ] ID-58
      [ReflexState.\_owner](../src/ReflexState.sol#L45) should be immutable

../src/ReflexState.sol#L45
