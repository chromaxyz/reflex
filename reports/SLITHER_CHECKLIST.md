Summary

- [uninitialized-state](#uninitialized-state) (2 results) (High)
- [calls-loop](#calls-loop) (5 results) (Low)
- [assembly](#assembly) (7 results) (Informational)
- [low-level-calls](#low-level-calls) (2 results) (Informational)
- [naming-convention](#naming-convention) (13 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-0
      [ReflexState.\_modules](../src/ReflexState.sol#L53) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L88-L94)

../src/ReflexState.sol#L53

- [ ] ID-1
      [ReflexState.\_owner](../src/ReflexState.sol#L40) is never initialized. It is used in:

../src/ReflexState.sol#L40

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-2
      [ReflexInstaller.addModules(address[])](../src/ReflexInstaller.sol#L112-L136) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L118)

../src/ReflexInstaller.sol#L112-L136

- [ ] ID-3
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [moduleSettings*.moduleType != IReflexModule(\_modules[moduleSettings*.moduleId]).moduleType()](../src/ReflexInstaller.sol#L167)

../src/ReflexInstaller.sol#L147-L183

- [ ] ID-4
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [! IReflexModule(_modules[moduleSettings_.moduleId]).moduleUpgradeable()](../src/ReflexInstaller.sol#L159)

../src/ReflexInstaller.sol#L147-L183

- [ ] ID-5
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L153)

../src/ReflexInstaller.sol#L147-L183

- [ ] ID-6
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L147-L183) has external calls inside a loop: [moduleSettings*.moduleVersion <= IReflexModule(\_modules[moduleSettings*.moduleId]).moduleVersion()](../src/ReflexInstaller.sol#L163)

../src/ReflexInstaller.sol#L147-L183

## assembly

Impact: Informational
Confidence: High

- [ ] ID-7
      [ReflexDispatcher.dispatch()](../src/ReflexDispatcher.sol#L82-L130) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L99-L129)

../src/ReflexDispatcher.sol#L82-L130

- [ ] ID-8
      [ReflexProxy.\_fallback()](../src/ReflexProxy.sol#L101-L198) uses assembly - [INLINE ASM](../src/ReflexProxy.sol#L107-L152) - [INLINE ASM](../src/ReflexProxy.sol#L155-L196)

../src/ReflexProxy.sol#L101-L198

- [ ] ID-9
      [ReflexBase.\_unpackMessageSender()](../src/ReflexBase.sol#L100-L106) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L103-L105)

../src/ReflexBase.sol#L100-L106

- [ ] ID-10
      [ReflexBase.\_revertBytes(bytes)](../src/ReflexBase.sol#L138-L147) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L141-L143)

../src/ReflexBase.sol#L138-L147

- [ ] ID-11
      [ReflexBase.\_unpackProxyAddress()](../src/ReflexBase.sol#L112-L118) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L115-L117)

../src/ReflexBase.sol#L112-L118

- [ ] ID-12
      [ReflexBase.\_unpackTrailingParameters()](../src/ReflexBase.sol#L125-L132) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L127-L131)

../src/ReflexBase.sol#L125-L132

- [ ] ID-13
      [ReflexProxy.sentinel()](../src/ReflexProxy.sol#L76-L92) uses assembly - [INLINE ASM](../src/ReflexProxy.sol#L84-L87)

../src/ReflexProxy.sol#L76-L92

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-14
      Low level call in [ReflexProxy.implementation()](../src/ReflexProxy.sol#L60-L70): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR,\_moduleId))](../src/ReflexProxy.sol#L61-L63)

../src/ReflexProxy.sol#L60-L70

- [ ] ID-15
      Low level call in [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L88-L94): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L89)

../src/ReflexBase.sol#L88-L94

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-16
      Variable [ReflexState.\_pendingOwner](../src/ReflexState.sol#L46) is not in mixedCase

../src/ReflexState.sol#L46

- [ ] ID-17
      Variable [ReflexModule.\_moduleId](../src/ReflexModule.sol#L24) is not in mixedCase

../src/ReflexModule.sol#L24

- [ ] ID-18
      Variable [ReflexState.\_reentrancyLock](../src/ReflexState.sol#L34) is not in mixedCase

../src/ReflexState.sol#L34

- [ ] ID-19
      Variable [ReflexState.\_modules](../src/ReflexState.sol#L53) is not in mixedCase

../src/ReflexState.sol#L53

- [ ] ID-20
      Variable [ReflexProxy.\_deployer](../src/ReflexProxy.sol#L35) is not in mixedCase

../src/ReflexProxy.sol#L35

- [ ] ID-21
      Variable [ReflexProxy.\_moduleId](../src/ReflexProxy.sol#L30) is not in mixedCase

../src/ReflexProxy.sol#L30

- [ ] ID-22
      Variable [ReflexModule.\_moduleVersion](../src/ReflexModule.sol#L34) is not in mixedCase

../src/ReflexModule.sol#L34

- [ ] ID-23
      Variable [ReflexModule.\_moduleUpgradeable](../src/ReflexModule.sol#L39) is not in mixedCase

../src/ReflexModule.sol#L39

- [ ] ID-24
      Variable [ReflexState.\_\_gap](../src/ReflexState.sol#L76) is not in mixedCase

../src/ReflexState.sol#L76

- [ ] ID-25
      Variable [ReflexState.\_owner](../src/ReflexState.sol#L40) is not in mixedCase

../src/ReflexState.sol#L40

- [ ] ID-26
      Variable [ReflexState.\_proxies](../src/ReflexState.sol#L60) is not in mixedCase

../src/ReflexState.sol#L60

- [ ] ID-27
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L29) is not in mixedCase

../src/ReflexModule.sol#L29

- [ ] ID-28
      Variable [ReflexState.\_relations](../src/ReflexState.sol#L67) is not in mixedCase

../src/ReflexState.sol#L67

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-29
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L29) is too similar to [ReflexBase._createProxy(uint32,uint16,address).moduleType_](../src/ReflexBase.sol#L58)

../src/ReflexModule.sol#L29

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-30
      [ReflexProxy.\_fallback()](../src/ReflexProxy.sol#L101-L198) uses literals with too many digits: - [mstore(uint256,uint256)(0x00,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/ReflexProxy.sol#L159-L163)

../src/ReflexProxy.sol#L101-L198
