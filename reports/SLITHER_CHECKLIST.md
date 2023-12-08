Summary

- [calls-loop](#calls-loop) (4 results) (Low)
- [assembly](#assembly) (12 results) (Informational)
- [dead-code](#dead-code) (4 results) (Informational)
- [solc-version](#solc-version) (14 results) (Informational)
- [low-level-calls](#low-level-calls) (2 results) (Informational)
- [naming-convention](#naming-convention) (1 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)
- [unused-state](#unused-state) (17 results) (Informational)

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-0
      [ReflexBatch.\_performBatchAction(IReflexBatch.BatchAction,address)](../src/periphery/ReflexBatch.sol#L112-L169) has external calls inside a loop: [(success*,result*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L165-L168)

../src/periphery/ReflexBatch.sol#L112-L169

- [ ] ID-1
      [ReflexInstaller.addModules(address[])](../src/ReflexInstaller.sol#L84-L115) has external calls inside a loop: [moduleSettings* = IReflexModule(moduleImplementation*).moduleSettings()](../src/ReflexInstaller.sol#L90)

../src/ReflexInstaller.sol#L84-L115

- [ ] ID-2
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L120-L155) has external calls inside a loop: [moduleSettings*.moduleType != IReflexModule(\_REFLEX_STORAGE().modules[moduleId*]).moduleType()](../src/ReflexInstaller.sol#L134)

../src/ReflexInstaller.sol#L120-L155

- [ ] ID-3
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L120-L155) has external calls inside a loop: [moduleSettings* = IReflexModule(moduleImplementation*).moduleSettings()](../src/ReflexInstaller.sol#L126)

../src/ReflexInstaller.sol#L120-L155

## assembly

Impact: Informational
Confidence: High

- [ ] ID-4
      [ReflexBatch.\_performBatchAction(IReflexBatch.BatchAction,address)](../src/periphery/ReflexBatch.sol#L112-L169) uses assembly - [INLINE ASM](../src/periphery/ReflexBatch.sol#L119-L162)

../src/periphery/ReflexBatch.sol#L112-L169

- [ ] ID-5
      [ReflexModule.\_afterNonReentrant()](../src/ReflexModule.sol#L162-L167) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L163-L166)

../src/ReflexModule.sol#L162-L167

- [ ] ID-6
      [ReflexState.\_REFLEX_STORAGE()](../src/ReflexState.sol#L114-L118) uses assembly - [INLINE ASM](../src/ReflexState.sol#L115-L117)

../src/ReflexState.sol#L114-L118

- [ ] ID-7
      [ReflexModule.\_unpackMessageSender()](../src/ReflexModule.sol#L242-L247) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L244-L246)

../src/ReflexModule.sol#L242-L247

- [ ] ID-8
      [ReflexModule.\_beforeNonReentrant()](../src/ReflexModule.sol#L144-L157) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L145-L156)

../src/ReflexModule.sol#L144-L157

- [ ] ID-9
      [ReflexModule.\_unpackTrailingParameters()](../src/ReflexModule.sol#L265-L276) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L272-L275)

../src/ReflexModule.sol#L265-L276

- [ ] ID-10
      [ReflexModule.\_revertBytes(bytes)](../src/ReflexModule.sol#L282-L293) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L283-L292)

../src/ReflexModule.sol#L282-L293

- [ ] ID-11
      [ReflexDispatcher.constructor(address,address)](../src/ReflexDispatcher.sol#L28-L75) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L53-L63)

../src/ReflexDispatcher.sol#L28-L75

- [ ] ID-12
      [ReflexModule.\_createEndpoint(uint32,uint16,address)](../src/ReflexModule.sol#L176-L221) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L195-L205)

../src/ReflexModule.sol#L176-L221

- [ ] ID-13
      [ReflexDispatcher.fallback()](../src/ReflexDispatcher.sol#L110-L189) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L113-L188)

../src/ReflexDispatcher.sol#L110-L189

- [ ] ID-14
      [ReflexEndpoint.fallback()](../src/ReflexEndpoint.sol#L40-L121) uses assembly - [INLINE ASM](../src/ReflexEndpoint.sol#L47-L92) - [INLINE ASM](../src/ReflexEndpoint.sol#L96-L119)

../src/ReflexEndpoint.sol#L40-L121

- [ ] ID-15
      [ReflexModule.\_unpackEndpointAddress()](../src/ReflexModule.sol#L253-L258) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L255-L257)

../src/ReflexModule.sol#L253-L258

## dead-code

Impact: Informational
Confidence: Medium

- [ ] ID-16
      [ReflexModule.\_unpackTrailingParameters()](../src/ReflexModule.sol#L265-L276) is never used and should be removed

../src/ReflexModule.sol#L265-L276

- [ ] ID-17
      [ReflexModule.\_unpackEndpointAddress()](../src/ReflexModule.sol#L253-L258) is never used and should be removed

../src/ReflexModule.sol#L253-L258

- [ ] ID-18
      [ReflexDispatcher.\_getEndpointCreationCode(uint32)](../src/ReflexDispatcher.sol#L201-L203) is never used and should be removed

../src/ReflexDispatcher.sol#L201-L203

- [ ] ID-19
      [ReflexModule.\_callInternalModule(uint32,bytes)](../src/ReflexModule.sol#L229-L236) is never used and should be removed

../src/ReflexModule.sol#L229-L236

## solc-version

Impact: Informational
Confidence: High

- [ ] ID-20
      Pragma version[^0.8.13](../src/interfaces/IReflexModule.sol#L2) allows old versions

../src/interfaces/IReflexModule.sol#L2

- [ ] ID-21
      Pragma version[^0.8.13](../src/periphery/ReflexBatch.sol#L2) allows old versions

../src/periphery/ReflexBatch.sol#L2

- [ ] ID-22
      Pragma version[^0.8.13](../src/interfaces/IReflexDispatcher.sol#L2) allows old versions

../src/interfaces/IReflexDispatcher.sol#L2

- [ ] ID-23
      Pragma version[^0.8.13](../src/interfaces/IReflexEndpoint.sol#L2) allows old versions

../src/interfaces/IReflexEndpoint.sol#L2

- [ ] ID-24
      Pragma version[^0.8.13](../src/interfaces/IReflexState.sol#L2) allows old versions

../src/interfaces/IReflexState.sol#L2

- [ ] ID-25
      Pragma version[^0.8.13](../src/interfaces/IReflexInstaller.sol#L2) allows old versions

../src/interfaces/IReflexInstaller.sol#L2

- [ ] ID-26
      Pragma version[^0.8.13](../src/ReflexEndpoint.sol#L2) allows old versions

../src/ReflexEndpoint.sol#L2

- [ ] ID-27
      Pragma version[^0.8.13](../src/periphery/interfaces/IReflexBatch.sol#L2) allows old versions

../src/periphery/interfaces/IReflexBatch.sol#L2

- [ ] ID-28
      Pragma version[^0.8.13](../src/ReflexConstants.sol#L2) allows old versions

../src/ReflexConstants.sol#L2

- [ ] ID-29
      Pragma version[^0.8.13](../src/ReflexModule.sol#L2) allows old versions

../src/ReflexModule.sol#L2

- [ ] ID-30
      solc-0.8.23 is not recommended for deployment

- [ ] ID-31
      Pragma version[^0.8.13](../src/ReflexState.sol#L2) allows old versions

../src/ReflexState.sol#L2

- [ ] ID-32
      Pragma version[^0.8.13](../src/ReflexInstaller.sol#L2) allows old versions

../src/ReflexInstaller.sol#L2

- [ ] ID-33
      Pragma version[^0.8.13](../src/ReflexDispatcher.sol#L2) allows old versions

../src/ReflexDispatcher.sol#L2

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-34
      Low level call in [ReflexModule.\_callInternalModule(uint32,bytes)](../src/ReflexModule.sol#L229-L236): - [(success,result) = _REFLEX_STORAGE().modules[moduleId_].delegatecall(input\_)](../src/ReflexModule.sol#L231)

../src/ReflexModule.sol#L229-L236

- [ ] ID-35
      Low level call in [ReflexBatch.\_performBatchAction(IReflexBatch.BatchAction,address)](../src/periphery/ReflexBatch.sol#L112-L169): - [(success*,result*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,uint160(messageSender*),uint160(endpointAddress)))](../src/periphery/ReflexBatch.sol#L165-L168)

../src/periphery/ReflexBatch.sol#L112-L169

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-36
      Function [ReflexState.\_REFLEX_STORAGE()](../src/ReflexState.sol#L114-L118) is not in mixedCase

../src/ReflexState.sol#L114-L118

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-37
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L30) is too similar to [ReflexModule._createEndpoint(uint32,uint16,address).moduleType_](../src/ReflexModule.sol#L178)

../src/ReflexModule.sol#L30

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-38
      [ReflexDispatcher.\_getEndpointCreationCode(uint32)](../src/ReflexDispatcher.sol#L201-L203) uses literals with too many digits: - [endpointCreationCode\_ = type()(ReflexEndpoint).creationCode](../src/ReflexDispatcher.sol#L202)

../src/ReflexDispatcher.sol#L201-L203

## unused-state

Impact: Informational
Confidence: High

- [ ] ID-39
      [ReflexState.\_REFLEX_STORAGE_OWNER_SLOT](../src/ReflexState.sol#L37-L38) is never used in [ReflexBatch](../src/periphery/ReflexBatch.sol#L16-L170)

../src/ReflexState.sol#L37-L38

- [ ] ID-40
      [ReflexConstants.\_MODULE_ID_INSTALLER](../src/ReflexConstants.sol#L49) is never used in [ReflexInstaller](../src/ReflexInstaller.sol#L17-L170)

../src/ReflexConstants.sol#L49

- [ ] ID-41
      [ReflexState.\_REFLEX_STORAGE_ENDPOINTS_SLOT](../src/ReflexState.sol#L58-L59) is never used in [ReflexInstaller](../src/ReflexInstaller.sol#L17-L170)

../src/ReflexState.sol#L58-L59

- [ ] ID-42
      [ReflexState.\_REFLEX_STORAGE_ENDPOINTS_SLOT](../src/ReflexState.sol#L58-L59) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexState.sol#L58-L59

- [ ] ID-43
      [ReflexConstants.\_MODULE_TYPE_MULTI_ENDPOINT](../src/ReflexConstants.sol#L35) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexConstants.sol#L35

- [ ] ID-44
      [ReflexState.\_REFLEX_STORAGE_MODULES_SLOT](../src/ReflexState.sol#L51-L52) is never used in [ReflexInstaller](../src/ReflexInstaller.sol#L17-L170)

../src/ReflexState.sol#L51-L52

- [ ] ID-45
      [ReflexState.\_REFLEX_STORAGE_PENDING_OWNER_SLOT](../src/ReflexState.sol#L44-L45) is never used in [ReflexInstaller](../src/ReflexInstaller.sol#L17-L170)

../src/ReflexState.sol#L44-L45

- [ ] ID-46
      [ReflexState.\_REFLEX_STORAGE_REENTRANCY_STATUS_SLOT](../src/ReflexState.sol#L30-L31) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexState.sol#L30-L31

- [ ] ID-47
      [ReflexState.\_REFLEX_STORAGE_RELATIONS_SLOT](../src/ReflexState.sol#L65-L66) is never used in [ReflexInstaller](../src/ReflexInstaller.sol#L17-L170)

../src/ReflexState.sol#L65-L66

- [ ] ID-48
      [ReflexState.\_REFLEX_STORAGE_OWNER_SLOT](../src/ReflexState.sol#L37-L38) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexState.sol#L37-L38

- [ ] ID-49
      [ReflexConstants.\_MODULE_ID_INSTALLER](../src/ReflexConstants.sol#L49) is never used in [ReflexBatch](../src/periphery/ReflexBatch.sol#L16-L170)

../src/ReflexConstants.sol#L49

- [ ] ID-50
      [ReflexState.\_REFLEX_STORAGE_PENDING_OWNER_SLOT](../src/ReflexState.sol#L44-L45) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexState.sol#L44-L45

- [ ] ID-51
      [ReflexState.\_REFLEX_STORAGE_OWNER_SLOT](../src/ReflexState.sol#L37-L38) is never used in [ReflexInstaller](../src/ReflexInstaller.sol#L17-L170)

../src/ReflexState.sol#L37-L38

- [ ] ID-52
      [ReflexState.\_REFLEX_STORAGE_PENDING_OWNER_SLOT](../src/ReflexState.sol#L44-L45) is never used in [ReflexBatch](../src/periphery/ReflexBatch.sol#L16-L170)

../src/ReflexState.sol#L44-L45

- [ ] ID-53
      [ReflexState.\_REFLEX_STORAGE_ENDPOINTS_SLOT](../src/ReflexState.sol#L58-L59) is never used in [ReflexBatch](../src/periphery/ReflexBatch.sol#L16-L170)

../src/ReflexState.sol#L58-L59

- [ ] ID-54
      [ReflexConstants.\_MODULE_TYPE_INTERNAL](../src/ReflexConstants.sol#L40) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexConstants.sol#L40

- [ ] ID-55
      [ReflexConstants.\_REENTRANCY_GUARD_LOCKED](../src/ReflexConstants.sol#L21) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexConstants.sol#L21
