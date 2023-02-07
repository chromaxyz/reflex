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
      [ReflexState.\_modules](../src/ReflexState.sol#L53) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L87-L93)

../src/ReflexState.sol#L53

- [ ] ID-1
      [ReflexState.\_owner](../src/ReflexState.sol#L40) is never initialized. It is used in:

../src/ReflexState.sol#L40

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-2
      [ReflexInstaller.addModules(address[])](../src/ReflexInstaller.sol#L107-L131) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L113)

../src/ReflexInstaller.sol#L107-L131

- [ ] ID-3
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L142-L178) has external calls inside a loop: [moduleSettings*.moduleType != IReflexModule(\_modules[moduleSettings*.moduleId]).moduleType()](../src/ReflexInstaller.sol#L162)

../src/ReflexInstaller.sol#L142-L178

- [ ] ID-4
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L142-L178) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L148)

../src/ReflexInstaller.sol#L142-L178

- [ ] ID-5
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L142-L178) has external calls inside a loop: [! IReflexModule(_modules[moduleSettings_.moduleId]).moduleUpgradeable()](../src/ReflexInstaller.sol#L154)

../src/ReflexInstaller.sol#L142-L178

- [ ] ID-6
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L142-L178) has external calls inside a loop: [moduleSettings*.moduleVersion <= IReflexModule(\_modules[moduleSettings*.moduleId]).moduleVersion()](../src/ReflexInstaller.sol#L158)

../src/ReflexInstaller.sol#L142-L178

## assembly

Impact: Informational
Confidence: High

- [ ] ID-7
      [ReflexBase.\_unpackMessageSender()](../src/ReflexBase.sol#L99-L104) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L101-L103)

../src/ReflexBase.sol#L99-L104

- [ ] ID-8
      [ReflexDispatcher.dispatch()](../src/ReflexDispatcher.sol#L81-L129) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L98-L128)

../src/ReflexDispatcher.sol#L81-L129

- [ ] ID-9
      [ReflexBase.\_unpackTrailingParameters()](../src/ReflexBase.sol#L122-L128) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L123-L127)

../src/ReflexBase.sol#L122-L128

- [ ] ID-10
      [ReflexProxy.\_fallback()](../src/ReflexProxy.sol#L99-L196) uses assembly - [INLINE ASM](../src/ReflexProxy.sol#L105-L150) - [INLINE ASM](../src/ReflexProxy.sol#L153-L194)

../src/ReflexProxy.sol#L99-L196

- [ ] ID-11
      [ReflexBase.\_unpackProxyAddress()](../src/ReflexBase.sol#L110-L115) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L112-L114)

../src/ReflexBase.sol#L110-L115

- [ ] ID-12
      [ReflexBase.\_revertBytes(bytes)](../src/ReflexBase.sol#L134-L142) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L136-L138)

../src/ReflexBase.sol#L134-L142

- [ ] ID-13
      [ReflexProxy.sentinel()](../src/ReflexProxy.sol#L75-L90) uses assembly - [INLINE ASM](../src/ReflexProxy.sol#L82-L85)

../src/ReflexProxy.sol#L75-L90

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-14
      Low level call in [ReflexProxy.implementation()](../src/ReflexProxy.sol#L59-L69): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR,\_moduleId))](../src/ReflexProxy.sol#L60-L62)

../src/ReflexProxy.sol#L59-L69

- [ ] ID-15
      Low level call in [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L87-L93): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L88)

../src/ReflexBase.sol#L87-L93

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-16
      Variable [ReflexState.\_pendingOwner](../src/ReflexState.sol#L46) is not in mixedCase

../src/ReflexState.sol#L46

- [ ] ID-17
      Variable [ReflexModule.\_moduleId](../src/ReflexModule.sol#L23) is not in mixedCase

../src/ReflexModule.sol#L23

- [ ] ID-18
      Variable [ReflexState.\_reentrancyLock](../src/ReflexState.sol#L34) is not in mixedCase

../src/ReflexState.sol#L34

- [ ] ID-19
      Variable [ReflexState.\_modules](../src/ReflexState.sol#L53) is not in mixedCase

../src/ReflexState.sol#L53

- [ ] ID-20
      Variable [ReflexProxy.\_deployer](../src/ReflexProxy.sol#L34) is not in mixedCase

../src/ReflexProxy.sol#L34

- [ ] ID-21
      Variable [ReflexProxy.\_moduleId](../src/ReflexProxy.sol#L29) is not in mixedCase

../src/ReflexProxy.sol#L29

- [ ] ID-22
      Variable [ReflexModule.\_moduleVersion](../src/ReflexModule.sol#L33) is not in mixedCase

../src/ReflexModule.sol#L33

- [ ] ID-23
      Variable [ReflexModule.\_moduleUpgradeable](../src/ReflexModule.sol#L38) is not in mixedCase

../src/ReflexModule.sol#L38

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
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L28) is not in mixedCase

../src/ReflexModule.sol#L28

- [ ] ID-28
      Variable [ReflexState.\_relations](../src/ReflexState.sol#L67) is not in mixedCase

../src/ReflexState.sol#L67

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-29
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L28) is too similar to [ReflexBase._createProxy(uint32,uint16,address).moduleType_](../src/ReflexBase.sol#L57)

../src/ReflexModule.sol#L28

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-30
      [ReflexProxy.\_fallback()](../src/ReflexProxy.sol#L99-L196) uses literals with too many digits: - [mstore(uint256,uint256)(0x00,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/ReflexProxy.sol#L157-L161)

../src/ReflexProxy.sol#L99-L196
