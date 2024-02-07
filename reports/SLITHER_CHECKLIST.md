Summary

- [pess-strange-setter](#pess-strange-setter) (1 results) (High)
- [pess-arbitrary-call-calldata-tainted](#pess-arbitrary-call-calldata-tainted) (2 results) (Medium)
- [pess-arbitrary-call](#pess-arbitrary-call) (1 results) (High)
- [pess-call-forward-to-protected](#pess-call-forward-to-protected) (2 results) (Medium)
- [missing-zero-check](#missing-zero-check) (1 results) (Low)
- [calls-loop](#calls-loop) (4 results) (Low)
- [assembly](#assembly) (11 results) (Informational)
- [solc-version](#solc-version) (14 results) (Informational)
- [low-level-calls](#low-level-calls) (3 results) (Informational)
- [naming-convention](#naming-convention) (4 results) (Informational)
- [pess-magic-number](#pess-magic-number) (3 results) (Informational)

## pess-strange-setter

Impact: High
Confidence: Medium

- [ ] ID-0
      Function [ReflexDispatcher.constructor(address,address)](../src/ReflexDispatcher.sol#L32-L79) is a strange setter. Nothing is set in constructor or set in a function without using function parameters

../src/ReflexDispatcher.sol#L32-L79

## pess-arbitrary-call-calldata-tainted

Impact: Medium
Confidence: Medium

- [ ] ID-1
      Manipulated call found: [(success*,result*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,messageSender*,endpointAddress))](../src/periphery/ReflexBatch.sol#L164-L167) in [ReflexBatch.\_performBatchAction(IReflexBatch.BatchAction,address)](../src/periphery/ReflexBatch.sol#L111-L168)
      Only the calldata could be manipulated
      The calldata could be manipulated through [ReflexBatch.performBatchCall(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L37-L56)

../src/periphery/ReflexBatch.sol#L164-L167

- [ ] ID-2
      Manipulated call found: [(success*,result*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,messageSender*,endpointAddress))](../src/periphery/ReflexBatch.sol#L164-L167) in [ReflexBatch.\_performBatchAction(IReflexBatch.BatchAction,address)](../src/periphery/ReflexBatch.sol#L111-L168)
      Only the calldata could be manipulated
      The calldata could be manipulated through [ReflexBatch.performBatchCall(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L37-L56)
      The calldata could be manipulated through [ReflexBatch.simulateBatchCall(IReflexBatch.BatchAction[])](../src/periphery/ReflexBatch.sol#L61-L82)

../src/periphery/ReflexBatch.sol#L164-L167

## pess-arbitrary-call

Impact: High
Confidence: High

- [ ] ID-3
      Manipulated call found: [(success,result) = contractAddress*.staticcall(callData*)](../src/periphery/ReflexBatch.sol#L25) in [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L24-L32)
      Both destination and calldata could be manipulated
      The call could be fully manipulated (arbitrary call) through [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L24-L32)

../src/periphery/ReflexBatch.sol#L25

## pess-call-forward-to-protected

Impact: Medium
Confidence: Low

- [ ] ID-4
      Function [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L24-L32) contains a low level call to a custom address

../src/periphery/ReflexBatch.sol#L24-L32

- [ ] ID-5
      Function [ReflexBatch.\_performBatchAction(IReflexBatch.BatchAction,address)](../src/periphery/ReflexBatch.sol#L111-L168) contains a low level call to a custom address

../src/periphery/ReflexBatch.sol#L111-L168

## missing-zero-check

Impact: Low
Confidence: Medium

- [ ] ID-6
      [ReflexBatch.performStaticCall(address,bytes).contractAddress\_](../src/periphery/ReflexBatch.sol#L24) lacks a zero-check on : - [(success,result) = contractAddress*.staticcall(callData*)](../src/periphery/ReflexBatch.sol#L25)

../src/periphery/ReflexBatch.sol#L24

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-7
      [ReflexInstaller.addModules(address[])](../src/ReflexInstaller.sol#L89-L120) has external calls inside a loop: [moduleSettings* = IReflexModule(moduleImplementation*).moduleSettings()](../src/ReflexInstaller.sol#L95)

../src/ReflexInstaller.sol#L89-L120

- [ ] ID-8
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L125-L160) has external calls inside a loop: [moduleSettings*.moduleType != IReflexModule(\_REFLEX_STORAGE().modules[moduleId*]).moduleType()](../src/ReflexInstaller.sol#L139)

../src/ReflexInstaller.sol#L125-L160

- [ ] ID-9
      [ReflexBatch.\_performBatchAction(IReflexBatch.BatchAction,address)](../src/periphery/ReflexBatch.sol#L111-L168) has external calls inside a loop: [(success*,result*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,messageSender*,endpointAddress))](../src/periphery/ReflexBatch.sol#L164-L167)

../src/periphery/ReflexBatch.sol#L111-L168

- [ ] ID-10
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L125-L160) has external calls inside a loop: [moduleSettings* = IReflexModule(moduleImplementation*).moduleSettings()](../src/ReflexInstaller.sol#L131)

../src/ReflexInstaller.sol#L125-L160

## assembly

Impact: Informational
Confidence: High

- [ ] ID-11
      [ReflexStorage.\_REFLEX_STORAGE()](../src/ReflexStorage.sol#L116-L120) uses assembly - [INLINE ASM](../src/ReflexStorage.sol#L117-L119)

../src/ReflexStorage.sol#L116-L120

- [ ] ID-12
      [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L24-L32) uses assembly - [INLINE ASM](../src/periphery/ReflexBatch.sol#L29-L31)

../src/periphery/ReflexBatch.sol#L24-L32

- [ ] ID-13
      [ReflexModule.\_unpackTrailingParameters()](../src/ReflexModule.sol#L240-L251) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L247-L250)

../src/ReflexModule.sol#L240-L251

- [ ] ID-14
      [ReflexBatch.\_performBatchAction(IReflexBatch.BatchAction,address)](../src/periphery/ReflexBatch.sol#L111-L168) uses assembly - [INLINE ASM](../src/periphery/ReflexBatch.sol#L118-L161)

../src/periphery/ReflexBatch.sol#L111-L168

- [ ] ID-15
      [ReflexModule.\_unpackEndpointAddress()](../src/ReflexModule.sol#L228-L233) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L230-L232)

../src/ReflexModule.sol#L228-L233

- [ ] ID-16
      [ReflexModule.\_createEndpoint(uint32,uint16,address)](../src/ReflexModule.sol#L151-L196) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L170-L180)

../src/ReflexModule.sol#L151-L196

- [ ] ID-17
      [ReflexDispatcher.constructor(address,address)](../src/ReflexDispatcher.sol#L32-L79) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L57-L67)

../src/ReflexDispatcher.sol#L32-L79

- [ ] ID-18
      [ReflexDispatcher.fallback()](../src/ReflexDispatcher.sol#L114-L193) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L117-L192)

../src/ReflexDispatcher.sol#L114-L193

- [ ] ID-19
      [ReflexModule.\_revertBytes(bytes)](../src/ReflexModule.sol#L257-L268) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L258-L267)

../src/ReflexModule.sol#L257-L268

- [ ] ID-20
      [ReflexEndpoint.fallback()](../src/ReflexEndpoint.sol#L46-L128) uses assembly - [INLINE ASM](../src/ReflexEndpoint.sol#L54-L99) - [INLINE ASM](../src/ReflexEndpoint.sol#L103-L126)

../src/ReflexEndpoint.sol#L46-L128

- [ ] ID-21
      [ReflexModule.\_unpackMessageSender()](../src/ReflexModule.sol#L217-L222) uses assembly - [INLINE ASM](../src/ReflexModule.sol#L219-L221)

../src/ReflexModule.sol#L217-L222

## solc-version

Impact: Informational
Confidence: High

- [ ] ID-22
      Pragma version[^0.8.13](../src/ReflexStorage.sol#L2) allows old versions

../src/ReflexStorage.sol#L2

- [ ] ID-23
      Pragma version[^0.8.13](../src/interfaces/IReflexModule.sol#L2) allows old versions

../src/interfaces/IReflexModule.sol#L2

- [ ] ID-24
      Pragma version[^0.8.13](../src/periphery/ReflexBatch.sol#L2) allows old versions

../src/periphery/ReflexBatch.sol#L2

- [ ] ID-25
      Pragma version[^0.8.13](../src/interfaces/IReflexDispatcher.sol#L2) allows old versions

../src/interfaces/IReflexDispatcher.sol#L2

- [ ] ID-26
      Pragma version[^0.8.13](../src/interfaces/IReflexEndpoint.sol#L2) allows old versions

../src/interfaces/IReflexEndpoint.sol#L2

- [ ] ID-27
      Pragma version[^0.8.13](../src/interfaces/IReflexStorage.sol#L2) allows old versions

../src/interfaces/IReflexStorage.sol#L2

- [ ] ID-28
      Pragma version[^0.8.13](../src/interfaces/IReflexInstaller.sol#L2) allows old versions

../src/interfaces/IReflexInstaller.sol#L2

- [ ] ID-29
      Pragma version[^0.8.13](../src/ReflexEndpoint.sol#L2) allows old versions

../src/ReflexEndpoint.sol#L2

- [ ] ID-30
      Pragma version[^0.8.13](../src/periphery/interfaces/IReflexBatch.sol#L2) allows old versions

../src/periphery/interfaces/IReflexBatch.sol#L2

- [ ] ID-31
      Pragma version[^0.8.13](../src/ReflexConstants.sol#L2) allows old versions

../src/ReflexConstants.sol#L2

- [ ] ID-32
      Pragma version[^0.8.13](../src/ReflexModule.sol#L2) allows old versions

../src/ReflexModule.sol#L2

- [ ] ID-33
      solc-0.8.19 is not recommended for deployment

- [ ] ID-34
      Pragma version[^0.8.13](../src/ReflexInstaller.sol#L2) allows old versions

../src/ReflexInstaller.sol#L2

- [ ] ID-35
      Pragma version[^0.8.13](../src/ReflexDispatcher.sol#L2) allows old versions

../src/ReflexDispatcher.sol#L2

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-36
      Low level call in [ReflexModule.\_callInternalModule(uint32,bytes)](../src/ReflexModule.sol#L204-L211): - [(success,result) = _REFLEX_STORAGE().modules[moduleId_].delegatecall(input\_)](../src/ReflexModule.sol#L206)

../src/ReflexModule.sol#L204-L211

- [ ] ID-37
      Low level call in [ReflexBatch.\_performBatchAction(IReflexBatch.BatchAction,address)](../src/periphery/ReflexBatch.sol#L111-L168): - [(success*,result*) = moduleImplementation.delegatecall(abi.encodePacked(action*.callData,messageSender*,endpointAddress))](../src/periphery/ReflexBatch.sol#L164-L167)

../src/periphery/ReflexBatch.sol#L111-L168

- [ ] ID-38
      Low level call in [ReflexBatch.performStaticCall(address,bytes)](../src/periphery/ReflexBatch.sol#L24-L32): - [(success,result) = contractAddress*.staticcall(callData*)](../src/periphery/ReflexBatch.sol#L25)

../src/periphery/ReflexBatch.sol#L24-L32

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-39
      Variable [ReflexModule.\_MODULE_TYPE](../src/ReflexModule.sol#L30) is not in mixedCase

../src/ReflexModule.sol#L30

- [ ] ID-40
      Function [ReflexStorage.\_REFLEX_STORAGE()](../src/ReflexStorage.sol#L116-L120) is not in mixedCase

../src/ReflexStorage.sol#L116-L120

- [ ] ID-41
      Variable [ReflexEndpoint.\_DISPATCHER](../src/ReflexEndpoint.sol#L26) is not in mixedCase

../src/ReflexEndpoint.sol#L26

- [ ] ID-42
      Variable [ReflexModule.\_MODULE_ID](../src/ReflexModule.sol#L25) is not in mixedCase

../src/ReflexModule.sol#L25

## pess-magic-number

Impact: Informational
Confidence: High

- [ ] ID-43
      Magic number 40 is used multiple times in:
      [messageSender\_ = calldataload(uint256)(calldatasize()() - 40) >> 96](../src/ReflexModule.sol#L220)
      [messageSender\_ = calldataload(uint256)(calldatasize()() - 40) >> 96](../src/ReflexModule.sol#L248)

../src/ReflexModule.sol#L220

- [ ] ID-44
      Magic number 20 is used multiple times in:
      [endpointAddress\_ = calldataload(uint256)(calldatasize()() - 20) >> 96](../src/ReflexModule.sol#L231)
      [endpointAddress\_ = calldataload(uint256)(calldatasize()() - 20) >> 96](../src/ReflexModule.sol#L249)

../src/ReflexModule.sol#L231

- [ ] ID-45
      Magic number 32 is used multiple times in:
      [revert(uint256,uint256)(32 + errorMessage*,mload(uint256)(errorMessage*))](../src/ReflexModule.sol#L266)
      [return(uint256,uint256)(32 + result,mload(uint256)(result))](../src/periphery/ReflexBatch.sol#L30)
      [moduleImplementation = relation\_\_performBatchAction_asm_0 >> 32 & 0xffffffffffffffffffffffffffffffffffffffff](../src/periphery/ReflexBatch.sol#L140)

../src/ReflexModule.sol#L266
