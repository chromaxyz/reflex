Summary

- [uninitialized-state](#uninitialized-state) (2 results) (High)
- [calls-loop](#calls-loop) (5 results) (Low)
- [assembly](#assembly) (7 results) (Informational)
- [costly-loop](#costly-loop) (3 results) (Informational)
- [low-level-calls](#low-level-calls) (2 results) (Informational)
- [naming-convention](#naming-convention) (14 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-0
      [ReflexState.\_modules](../src/ReflexState.sol#L53) is never initialized. It is used in: - [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L78-L84)

../src/ReflexState.sol#L53

- [ ] ID-1
      [ReflexState.\_owner](../src/ReflexState.sol#L40) is never initialized. It is used in:

../src/ReflexState.sol#L40

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-2
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L127-L161) has external calls inside a loop: [! IReflexModule(_modules[moduleSettings_.moduleId]).moduleUpgradeable()](../src/ReflexInstaller.sol#L141)

../src/ReflexInstaller.sol#L127-L161

- [ ] ID-3
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L127-L161) has external calls inside a loop: [moduleSettings*.moduleVersion <= IReflexModule(\_modules[moduleSettings*.moduleId]).moduleVersion()](../src/ReflexInstaller.sol#L145)

../src/ReflexInstaller.sol#L127-L161

- [ ] ID-4
      [ReflexInstaller.addModules(address[])](../src/ReflexInstaller.sol#L93-L116) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L99)

../src/ReflexInstaller.sol#L93-L116

- [ ] ID-5
      [ReflexInstaller.upgradeModules(address[])](../src/ReflexInstaller.sol#L127-L161) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L135)

../src/ReflexInstaller.sol#L127-L161

- [ ] ID-6
      [ReflexInstaller.removeModules(address[])](../src/ReflexInstaller.sol#L172-L202) has external calls inside a loop: [moduleSettings\_ = IReflexModule(moduleAddress).moduleSettings()](../src/ReflexInstaller.sol#L178)

../src/ReflexInstaller.sol#L172-L202

## assembly

Impact: Informational
Confidence: High

- [ ] ID-7
      [ReflexDispatcher.dispatch()](../src/ReflexDispatcher.sol#L73-L121) uses assembly - [INLINE ASM](../src/ReflexDispatcher.sol#L90-L120)

../src/ReflexDispatcher.sol#L73-L121

- [ ] ID-8
      [ReflexBase.\_unpackProxyAddress()](../src/ReflexBase.sol#L101-L106) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L103-L105)

../src/ReflexBase.sol#L101-L106

- [ ] ID-9
      [ReflexProxy.\_fallback()](../src/ReflexProxy.sol#L99-L196) uses assembly - [INLINE ASM](../src/ReflexProxy.sol#L105-L150) - [INLINE ASM](../src/ReflexProxy.sol#L153-L194)

../src/ReflexProxy.sol#L99-L196

- [ ] ID-10
      [ReflexBase.\_revertBytes(bytes)](../src/ReflexBase.sol#L125-L133) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L127-L129)

../src/ReflexBase.sol#L125-L133

- [ ] ID-11
      [ReflexBase.\_unpackTrailingParameters()](../src/ReflexBase.sol#L113-L119) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L114-L118)

../src/ReflexBase.sol#L113-L119

- [ ] ID-12
      [ReflexProxy.sentinel()](../src/ReflexProxy.sol#L75-L90) uses assembly - [INLINE ASM](../src/ReflexProxy.sol#L82-L85)

../src/ReflexProxy.sol#L75-L90

- [ ] ID-13
      [ReflexBase.\_unpackMessageSender()](../src/ReflexBase.sol#L90-L95) uses assembly - [INLINE ASM](../src/ReflexBase.sol#L92-L94)

../src/ReflexBase.sol#L90-L95

## costly-loop

Impact: Informational
Confidence: Medium

- [ ] ID-14
      [ReflexInstaller.removeModules(address[])](../src/ReflexInstaller.sol#L172-L202) has costly operations inside a loop: - [delete \_relations[proxyAddress]](../src/ReflexInstaller.sol#L186)

../src/ReflexInstaller.sol#L172-L202

- [ ] ID-15
      [ReflexInstaller.removeModules(address[])](../src/ReflexInstaller.sol#L172-L202) has costly operations inside a loop: - [delete _modules[moduleSettings_.moduleId]](../src/ReflexInstaller.sol#L194)

../src/ReflexInstaller.sol#L172-L202

- [ ] ID-16
      [ReflexInstaller.removeModules(address[])](../src/ReflexInstaller.sol#L172-L202) has costly operations inside a loop: - [delete _proxies[moduleSettings_.moduleId]](../src/ReflexInstaller.sol#L192)

../src/ReflexInstaller.sol#L172-L202

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-17
      Low level call in [ReflexBase.\_callInternalModule(uint32,bytes)](../src/ReflexBase.sol#L78-L84): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/ReflexBase.sol#L79)

../src/ReflexBase.sol#L78-L84

- [ ] ID-18
      Low level call in [ReflexProxy.implementation()](../src/ReflexProxy.sol#L59-L69): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR,\_moduleId))](../src/ReflexProxy.sol#L60-L62)

../src/ReflexProxy.sol#L59-L69

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-19
      Variable [ReflexState.\_pendingOwner](../src/ReflexState.sol#L46) is not in mixedCase

../src/ReflexState.sol#L46

- [ ] ID-20
      Variable [ReflexModule.\_moduleId](../src/ReflexModule.sol#L23) is not in mixedCase

../src/ReflexModule.sol#L23

- [ ] ID-21
      Variable [ReflexState.\_reentrancyLock](../src/ReflexState.sol#L34) is not in mixedCase

../src/ReflexState.sol#L34

- [ ] ID-22
      Variable [ReflexState.\_modules](../src/ReflexState.sol#L53) is not in mixedCase

../src/ReflexState.sol#L53

- [ ] ID-23
      Variable [ReflexProxy.\_deployer](../src/ReflexProxy.sol#L34) is not in mixedCase

../src/ReflexProxy.sol#L34

- [ ] ID-24
      Variable [ReflexProxy.\_moduleId](../src/ReflexProxy.sol#L29) is not in mixedCase

../src/ReflexProxy.sol#L29

- [ ] ID-25
      Variable [ReflexModule.\_moduleRemoveable](../src/ReflexModule.sol#L43) is not in mixedCase

../src/ReflexModule.sol#L43

- [ ] ID-26
      Variable [ReflexModule.\_moduleVersion](../src/ReflexModule.sol#L33) is not in mixedCase

../src/ReflexModule.sol#L33

- [ ] ID-27
      Variable [ReflexModule.\_moduleUpgradeable](../src/ReflexModule.sol#L38) is not in mixedCase

../src/ReflexModule.sol#L38

- [ ] ID-28
      Variable [ReflexState.\_\_gap](../src/ReflexState.sol#L76) is not in mixedCase

../src/ReflexState.sol#L76

- [ ] ID-29
      Variable [ReflexState.\_owner](../src/ReflexState.sol#L40) is not in mixedCase

../src/ReflexState.sol#L40

- [ ] ID-30
      Variable [ReflexState.\_proxies](../src/ReflexState.sol#L60) is not in mixedCase

../src/ReflexState.sol#L60

- [ ] ID-31
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L28) is not in mixedCase

../src/ReflexModule.sol#L28

- [ ] ID-32
      Variable [ReflexState.\_relations](../src/ReflexState.sol#L67) is not in mixedCase

../src/ReflexState.sol#L67

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-33
      Variable [ReflexModule.\_moduleType](../src/ReflexModule.sol#L28) is too similar to [ReflexBase._createProxy(uint32,uint16).moduleType_](../src/ReflexBase.sol#L53)

../src/ReflexModule.sol#L28

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-34
      [ReflexProxy.\_fallback()](../src/ReflexProxy.sol#L99-L196) uses literals with too many digits: - [mstore(uint256,uint256)(0x00,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/ReflexProxy.sol#L157-L161)

../src/ReflexProxy.sol#L99-L196
