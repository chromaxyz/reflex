Summary

- [calls-loop](#calls-loop) (6 results) (Low)
- [assembly](#assembly) (11 results) (Informational)
- [solc-version](#solc-version) (14 results) (Informational)
- [low-level-calls](#low-level-calls) (4 results) (Informational)
- [naming-convention](#naming-convention) (7 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-0
      [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L141-L159) has external calls inside a loop: [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L156-L158)

../src/periphery/ReflexBatch.sol#L141-L159

- [ ] ID-1
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L117-L163) has external calls inside a loop: [! IReflexModule(_REFLEX_STORAGE().modules[moduleSettings_.moduleId]).moduleUpgradeable()](../src/ReflexInstaller.sol#L130)

../src/ReflexInstaller.sol#L117-L163

- [ ] ID-2
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L117-L163) has external calls inside a loop: [moduleSettings*.moduleVersion <= IReflexModule(\_REFLEX_STORAGE().modules[moduleSettings*.moduleId]).moduleVersion()](../src/ReflexInstaller.sol#L135-L136)

../src/ReflexInstaller.sol#L117-L163

- [ ] ID-3
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L117-L163) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L123)

../src/ReflexInstaller.sol#L117-L163

- [ ] ID-4
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L117-L163) has external calls inside a loop: [moduleSettings*.moduleType != IReflexModule(\_REFLEX_STORAGE().modules[moduleSettings*.moduleId]).moduleType()](../src/ReflexInstaller.sol#L141-L142)

../src/ReflexInstaller.sol#L117-L163

- [ ] ID-5
      [ReflexInstaller.addModules(address[])](../src/ReflexInstaller.sol#L84-L112) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L90)

../src/ReflexInstaller.sol#L84-L112

## assembly

Impact: Informational
Confidence: High

- [ ] ID-6
      [ReflexModule.\_unpackTrailingParameters()](../src/ReflexModule.sol#L253-L264) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L260-L263)

../src/ReflexModule.sol#L253-L264

- [ ] ID-7
      [ReflexDispatcher.constructor(address,address)](../src/ReflexDispatcher.sol#L28-L77) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L54-L64)

../src/ReflexDispatcher.sol#L28-L77

- [ ] ID-8
      [ReflexModule.\_unpackMessageSender()](../src/ReflexModule.sol#L230-L235) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L232-L234)

../src/ReflexModule.sol#L230-L235

- [ ] ID-9
      [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L91-L112) uses assembly - [INLINE ASM](../src/periphery/ReflexBatch.sol#L107-L109)

../src/periphery/ReflexBatch.sol#L91-L112

- [ ] ID-10
      [ReflexDispatcher.fallback()](../src/ReflexDispatcher.sol#L112-L151) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L127-L150)

../src/ReflexDispatcher.sol#L112-L151

- [ ] ID-11
      [ReflexState.\_REFLEX_STORAGE()](../src/ReflexState.sol#L72-L76) uses assembly - [INLINE ASM](../src/ReflexState.sol#L73-L75)

../src/ReflexState.sol#L72-L76

- [ ] ID-12
      [ReflexModule.\_createEndpoint(uint32,uint16,address)](../src/ReflexModule.sol#L166-L200) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L179-L189)

../src/ReflexModule.sol#L166-L200

- [ ] ID-13
      [ReflexEndpoint.fallback()](../src/ReflexEndpoint.sol#L50-L132) uses assembly - [INLINE ASM](../src/ReflexEndpoint.sol#L56-L101) - [INLINE ASM](../src/ReflexEndpoint.sol#L104-L130)

../src/ReflexEndpoint.sol#L50-L132

- [ ] ID-14
      [ReflexModule.\_revertBytes(bytes)](../src/ReflexModule.sol#L270-L278) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L272-L274)

../src/ReflexModule.sol#L270-L278

- [ ] ID-15
      [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L24-L34) uses assembly - [INLINE ASM](../src/periphery/ReflexBatch.sol#L31-L33)

../src/periphery/ReflexBatch.sol#L24-L34

- [ ] ID-16
      [ReflexModule.\_unpackEndpointAddress()](../src/ReflexModule.sol#L241-L246) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L243-L245)

../src/ReflexModule.sol#L241-L246

## solc-version

Impact: Informational
Confidence: High

- [ ] ID-17
      Pragma version[^0.8.13](../src/interfaces/IReflexModule.sol#L2) allows old versions

../src/interfaces/IReflexModule.sol#L2

- [ ] ID-18
      Pragma version[^0.8.13](../src/periphery/ReflexBatch.sol#L2) allows old versions

../src/periphery/ReflexBatch.sol#L2

- [ ] ID-19
      Pragma version[^0.8.13](../src/interfaces/IReflexDispatcher.sol#L2) allows old versions

../src/interfaces/IReflexDispatcher.sol#L2

- [ ] ID-20
      Pragma version[^0.8.13](../src/interfaces/IReflexEndpoint.sol#L2) allows old versions

../src/interfaces/IReflexEndpoint.sol#L2

- [ ] ID-21
      Pragma version[^0.8.13](../src/interfaces/IReflexState.sol#L2) allows old versions

../src/interfaces/IReflexState.sol#L2

- [ ] ID-22
      Pragma version[^0.8.13](../src/interfaces/IReflexInstaller.sol#L2) allows old versions

../src/interfaces/IReflexInstaller.sol#L2

- [ ] ID-23
      Pragma version[^0.8.13](../src/ReflexEndpoint.sol#L2) allows old versions

../src/ReflexEndpoint.sol#L2

- [ ] ID-24
      Pragma version[^0.8.13](../src/periphery/interfaces/IReflexBatch.sol#L2) allows old versions

../src/periphery/interfaces/IReflexBatch.sol#L2

- [ ] ID-25
      Pragma version[^0.8.13](../src/ReflexConstants.sol#L2) allows old versions

../src/ReflexConstants.sol#L2

- [ ] ID-26
      Pragma version[^0.8.13](../src/ReflexModule.sol#L2) allows old versions

../src/ReflexModule.sol#L2

- [ ] ID-27
      solc-0.8.19 is not recommended for deployment

- [ ] ID-28
      Pragma version[^0.8.13](../src/ReflexState.sol#L2) allows old versions

../src/ReflexState.sol#L2

- [ ] ID-29
      Pragma version[^0.8.13](../src/ReflexInstaller.sol#L2) allows old versions

../src/ReflexInstaller.sol#L2

- [ ] ID-30
      Pragma version[^0.8.13](../src/ReflexDispatcher.sol#L2) allows old versions

../src/ReflexDispatcher.sol#L2

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-31
      Low level call in [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L24-L34): - [(success,result) = contractAddress*.staticcall(callData*)](../src/periphery/ReflexBatch.sol#L27)

../src/periphery/ReflexBatch.sol#L24-L34

- [ ] ID-32
      Low level call in [ReflexModule.\_callInternalModule(uint32,bytes)](../src/ReflexModule.sol#L217-L224): - [(success,result) = _REFLEX_STORAGE().modules[moduleId_].delegatecall(input\_)](../src/ReflexModule.sol#L219)

../src/ReflexModule.sol#L217-L224

- [ ] ID-33
      Low level call in [ReflexBatch.\_performBatchAction(address,IReflexBatch.BatchAction)](../src/periphery/ReflexBatch.sol#L141-L159): - [(success*,returnData*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L156-L158)

../src/periphery/ReflexBatch.sol#L141-L159

- [ ] ID-34
      Low level call in [ReflexBatch.simulateBatchCallReturn(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L91-L112): - [(success,result) = _REFLEX_STORAGE().modules[\_moduleId].delegatecall(abi.encodePacked(abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector,actions_),uint160(\_unpackMessageSender()),uint160(\_unpackEndpointAddress())))](../src/periphery/ReflexBatch.sol#L95-L101)

../src/periphery/ReflexBatch.sol#L91-L112

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-35
      Variable [ReflexModule.\_moduleId](../src/ReflexModule.sol#L25) is not in mixedCase

../src/ReflexModule.sol#L25

- [ ] ID-36
      Function [ReflexState.\_REFLEX_STORAGE()](../src/ReflexState.sol#L72-L76) is not in mixedCase

../src/ReflexState.sol#L72-L76

- [ ] ID-37
      Variable [ReflexEndpoint.\_deployer](../src/ReflexEndpoint.sol#L26) is not in mixedCase

../src/ReflexEndpoint.sol#L26

- [ ] ID-38
      Variable [ReflexEndpoint.\_moduleId](../src/ReflexEndpoint.sol#L21) is not in mixedCase

../src/ReflexEndpoint.sol#L21

- [ ] ID-39
      Variable [ReflexModule.\_moduleVersion](../src/ReflexModule.sol#L35) is not in mixedCase

../src/ReflexModule.sol#L35

- [ ] ID-40
      Variable [ReflexModule.\_moduleUpgradeable](../src/ReflexModule.sol#L40) is not in mixedCase

../src/ReflexModule.sol#L40

- [ ] ID-41
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L30) is not in mixedCase

../src/ReflexModule.sol#L30

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-42
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L30) is too similar to [ReflexModule._createEndpoint(uint32,uint16,address).moduleType_](../src/ReflexModule.sol#L168)

../src/ReflexModule.sol#L30
