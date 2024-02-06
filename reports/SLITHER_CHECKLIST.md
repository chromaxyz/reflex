Summary

- [missing-zero-check](#missing-zero-check) (1 results) (Low)
- [calls-loop](#calls-loop) (4 results) (Low)
- [assembly](#assembly) (11 results) (Informational)
- [dead-code](#dead-code) (4 results) (Informational)
- [solc-version](#solc-version) (14 results) (Informational)
- [low-level-calls](#low-level-calls) (3 results) (Informational)
- [naming-convention](#naming-convention) (1 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)
- [unused-state](#unused-state) (17 results) (Informational)

## missing-zero-check

Impact: Low
Confidence: Medium

- [ ] ID-0
      [ReflexBatch.performStaticCall(address,bytes).contractAddress\_](../src/periphery/ReflexBatch.sol#L24) lacks a zero-check on : - [(success,result) = contractAddress*.staticcall(callData*)](../src/periphery/ReflexBatch.sol#L25)

../src/periphery/ReflexBatch.sol#L24

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-1
      [ReflexBatch.\_performBatchAction(IReflexBatch.BatchAction,address)](../src/periphery/ReflexBatch.sol#L111-L168) has external calls inside a loop: [(success*,result*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,messageSender*,endpointAddress))](../src/periphery/ReflexBatch.sol#L164-L167)

../src/periphery/ReflexBatch.sol#L111-L168

- [ ] ID-2
      [ReflexInstaller.addModules(address[])](../src/ReflexInstaller.sol#L84-L115) has external calls inside a loop: [moduleSettings* = IReflexModule(moduleImplementation*).moduleSettings()](../src/ReflexInstaller.sol#L90)

../src/ReflexInstaller.sol#L84-L115

- [ ] ID-3
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L120-L155) has external calls inside a loop: [moduleSettings*.moduleType != IReflexModule(\_REFLEX_STORAGE().modules[moduleId*]).moduleType()](../src/ReflexInstaller.sol#L134)

../src/ReflexInstaller.sol#L120-L155

- [ ] ID-4
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L120-L155) has external calls inside a loop: [moduleSettings* = IReflexModule(moduleImplementation*).moduleSettings()](../src/ReflexInstaller.sol#L126)

../src/ReflexInstaller.sol#L120-L155

## assembly

Impact: Informational
Confidence: High

- [ ] ID-5
      [ReflexStorage.\_REFLEX_STORAGE()](../src/ReflexStorage.sol#L116-L120) uses assembly - [INLINE ASM](../src/ReflexStorage.sol#L117-L119)

../src/ReflexStorage.sol#L116-L120

- [ ] ID-6
      [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L24-L32) uses assembly - [INLINE ASM](../src/periphery/ReflexBatch.sol#L29-L31)

../src/periphery/ReflexBatch.sol#L24-L32

- [ ] ID-7
      [ReflexModule.\_createEndpoint(uint32,uint16,address)](../src/ReflexModule.sol#L149-L194) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L168-L178)

../src/ReflexModule.sol#L149-L194

- [ ] ID-8
      [ReflexModule.\_unpackEndpointAddress()](../src/ReflexModule.sol#L226-L231) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L228-L230)

../src/ReflexModule.sol#L226-L231

- [ ] ID-9
      [ReflexBatch.\_performBatchAction(IReflexBatch.BatchAction,address)](../src/periphery/ReflexBatch.sol#L111-L168) uses assembly - [INLINE ASM](../src/periphery/ReflexBatch.sol#L118-L161)

../src/periphery/ReflexBatch.sol#L111-L168

- [ ] ID-10
      [ReflexModule.\_unpackTrailingParameters()](../src/ReflexModule.sol#L238-L249) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L245-L248)

../src/ReflexModule.sol#L238-L249

- [ ] ID-11
      [ReflexModule.\_revertBytes(bytes)](../src/ReflexModule.sol#L255-L266) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L256-L265)

../src/ReflexModule.sol#L255-L266

- [ ] ID-12
      [ReflexDispatcher.constructor(address,address)](../src/ReflexDispatcher.sol#L28-L75) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L53-L63)

../src/ReflexDispatcher.sol#L28-L75

- [ ] ID-13
      [ReflexModule.\_unpackMessageSender()](../src/ReflexModule.sol#L215-L220) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L217-L219)

../src/ReflexModule.sol#L215-L220

- [ ] ID-14
      [ReflexDispatcher.fallback()](../src/ReflexDispatcher.sol#L110-L189) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L113-L188)

../src/ReflexDispatcher.sol#L110-L189

- [ ] ID-15
      [ReflexEndpoint.fallback()](../src/ReflexEndpoint.sol#L40-L121) uses assembly - [INLINE ASM](../src/ReflexEndpoint.sol#L47-L92) - [INLINE ASM](../src/ReflexEndpoint.sol#L96-L119)

../src/ReflexEndpoint.sol#L40-L121

## dead-code

Impact: Informational
Confidence: Medium

- [ ] ID-16
      [ReflexModule.\_unpackTrailingParameters()](../src/ReflexModule.sol#L238-L249) is never used and should be removed

../src/ReflexModule.sol#L238-L249

- [ ] ID-17
      [ReflexModule.\_unpackEndpointAddress()](../src/ReflexModule.sol#L226-L231) is never used and should be removed

../src/ReflexModule.sol#L226-L231

- [ ] ID-18
      [ReflexDispatcher.\_getEndpointCreationCode(uint32)](../src/ReflexDispatcher.sol#L201-L203) is never used and should be removed

../src/ReflexDispatcher.sol#L201-L203

- [ ] ID-19
      [ReflexModule.\_callInternalModule(uint32,bytes)](../src/ReflexModule.sol#L202-L209) is never used and should be removed

../src/ReflexModule.sol#L202-L209

## solc-version

Impact: Informational
Confidence: High

- [ ] ID-20
      Pragma version[^0.8.13](../src/ReflexStorage.sol#L2) allows old versions

../src/ReflexStorage.sol#L2

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
      Pragma version[^0.8.13](../src/interfaces/IReflexEndpoint.sol#L2) allows old versions

../src/interfaces/IReflexEndpoint.sol#L2

- [ ] ID-25
      Pragma version[^0.8.13](../src/interfaces/IReflexStorage.sol#L2) allows old versions

../src/interfaces/IReflexStorage.sol#L2

- [ ] ID-26
      Pragma version[^0.8.13](../src/interfaces/IReflexInstaller.sol#L2) allows old versions

../src/interfaces/IReflexInstaller.sol#L2

- [ ] ID-27
      Pragma version[^0.8.13](../src/ReflexEndpoint.sol#L2) allows old versions

../src/ReflexEndpoint.sol#L2

- [ ] ID-28
      Pragma version[^0.8.13](../src/periphery/interfaces/IReflexBatch.sol#L2) allows old versions

../src/periphery/interfaces/IReflexBatch.sol#L2

- [ ] ID-29
      Pragma version[^0.8.13](../src/ReflexConstants.sol#L2) allows old versions

../src/ReflexConstants.sol#L2

- [ ] ID-30
      Pragma version[^0.8.13](../src/ReflexModule.sol#L2) allows old versions

../src/ReflexModule.sol#L2

- [ ] ID-31
      solc-0.8.19 is not recommended for deployment

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
      Low level call in [ReflexBatch.\_performBatchAction(IReflexBatch.BatchAction,address)](../src/periphery/ReflexBatch.sol#L111-L168): - [(success*,result*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,messageSender*,endpointAddress))](../src/periphery/ReflexBatch.sol#L164-L167)

../src/periphery/ReflexBatch.sol#L111-L168

- [ ] ID-35
      Low level call in [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L24-L32): - [(success,result) = contractAddress*.staticcall(callData*)](../src/periphery/ReflexBatch.sol#L25)

../src/periphery/ReflexBatch.sol#L24-L32

- [ ] ID-36
      Low level call in [ReflexModule.\_callInternalModule(uint32,bytes)](../src/ReflexModule.sol#L202-L209): - [(success,result) = _REFLEX_STORAGE().modules[moduleId_].delegatecall(input\_)](../src/ReflexModule.sol#L204)

../src/ReflexModule.sol#L202-L209

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-37
      Function [ReflexStorage.\_REFLEX_STORAGE()](../src/ReflexStorage.sol#L116-L120) is not in mixedCase

../src/ReflexStorage.sol#L116-L120

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-38
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L30) is too similar to [ReflexModule._createEndpoint(uint32,uint16,address).moduleType_](../src/ReflexModule.sol#L151)

../src/ReflexModule.sol#L30

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-39
      [ReflexDispatcher.\_getEndpointCreationCode(uint32)](../src/ReflexDispatcher.sol#L201-L203) uses literals with too many digits: - [endpointCreationCode\_ = type()(ReflexEndpoint).creationCode](../src/ReflexDispatcher.sol#L202)

../src/ReflexDispatcher.sol#L201-L203

## unused-state

Impact: Informational
Confidence: High

- [ ] ID-40
      [ReflexStorage.\_REFLEX_STORAGE_ENDPOINTS_SLOT](../src/ReflexStorage.sol#L59-L60) is never used in [ReflexBatch](../src/periphery/ReflexBatch.sol#L16-L169)

../src/ReflexStorage.sol#L59-L60

- [ ] ID-41
      [ReflexStorage.\_REFLEX_STORAGE_PENDING_OWNER_SLOT](../src/ReflexStorage.sol#L45-L46) is never used in [ReflexBatch](../src/periphery/ReflexBatch.sol#L16-L169)

../src/ReflexStorage.sol#L45-L46

- [ ] ID-42
      [ReflexConstants.\_MODULE_ID_INSTALLER](../src/ReflexConstants.sol#L49) is never used in [ReflexInstaller](../src/ReflexInstaller.sol#L17-L170)

../src/ReflexConstants.sol#L49

- [ ] ID-43
      [ReflexStorage.\_REFLEX_STORAGE_OWNER_SLOT](../src/ReflexStorage.sol#L38-L39) is never used in [ReflexBatch](../src/periphery/ReflexBatch.sol#L16-L169)

../src/ReflexStorage.sol#L38-L39

- [ ] ID-44
      [ReflexConstants.\_MODULE_TYPE_MULTI_ENDPOINT](../src/ReflexConstants.sol#L35) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexConstants.sol#L35

- [ ] ID-45
      [ReflexStorage.\_REFLEX_STORAGE_OWNER_SLOT](../src/ReflexStorage.sol#L38-L39) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexStorage.sol#L38-L39

- [ ] ID-46
      [ReflexConstants.\_MODULE_ID_INSTALLER](../src/ReflexConstants.sol#L49) is never used in [ReflexBatch](../src/periphery/ReflexBatch.sol#L16-L169)

../src/ReflexConstants.sol#L49

- [ ] ID-47
      [ReflexStorage.\_REFLEX_STORAGE_PENDING_OWNER_SLOT](../src/ReflexStorage.sol#L45-L46) is never used in [ReflexInstaller](../src/ReflexInstaller.sol#L17-L170)

../src/ReflexStorage.sol#L45-L46

- [ ] ID-48
      [ReflexStorage.\_REFLEX_STORAGE_ENDPOINTS_SLOT](../src/ReflexStorage.sol#L59-L60) is never used in [ReflexInstaller](../src/ReflexInstaller.sol#L17-L170)

../src/ReflexStorage.sol#L59-L60

- [ ] ID-49
      [ReflexStorage.\_REFLEX_STORAGE_MODULES_SLOT](../src/ReflexStorage.sol#L52-L53) is never used in [ReflexInstaller](../src/ReflexInstaller.sol#L17-L170)

../src/ReflexStorage.sol#L52-L53

- [ ] ID-50
      [ReflexStorage.\_REFLEX_STORAGE_PENDING_OWNER_SLOT](../src/ReflexStorage.sol#L45-L46) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexStorage.sol#L45-L46

- [ ] ID-51
      [ReflexConstants.\_MODULE_TYPE_INTERNAL](../src/ReflexConstants.sol#L40) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexConstants.sol#L40

- [ ] ID-52
      [ReflexStorage.\_REFLEX_STORAGE_ENDPOINTS_SLOT](../src/ReflexStorage.sol#L59-L60) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexStorage.sol#L59-L60

- [ ] ID-53
      [ReflexStorage.\_REFLEX_STORAGE_RELATIONS_SLOT](../src/ReflexStorage.sol#L66-L67) is never used in [ReflexInstaller](../src/ReflexInstaller.sol#L17-L170)

../src/ReflexStorage.sol#L66-L67

- [ ] ID-54
      [ReflexStorage.\_REFLEX_STORAGE_OWNER_SLOT](../src/ReflexStorage.sol#L38-L39) is never used in [ReflexInstaller](../src/ReflexInstaller.sol#L17-L170)

../src/ReflexStorage.sol#L38-L39

- [ ] ID-55
      [ReflexStorage.\_REFLEX_STORAGE_REENTRANCY_STATUS_SLOT](../src/ReflexStorage.sol#L31-L32) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexStorage.sol#L31-L32

- [ ] ID-56
      [ReflexConstants.\_REENTRANCY_GUARD_LOCKED](../src/ReflexConstants.sol#L21) is never used in [ReflexDispatcher](../src/ReflexDispatcher.sol#L19-L204)

../src/ReflexConstants.sol#L21
