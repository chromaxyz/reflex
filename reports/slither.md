Summary

- [uninitialized-state](#uninitialized-state) (2 results) (High)
- [calls-loop](#calls-loop) (5 results) (Low)
- [assembly](#assembly) (7 results) (Informational)
- [costly-loop](#costly-loop) (3 results) (Informational)
- [low-level-calls](#low-level-calls) (2 results) (Informational)
- [naming-convention](#naming-convention) (12 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-0
      [BaseState.\_modules](../src/BaseState.sol#L53) is never initialized. It is used in: - [Base.\_callInternalModule(uint32,bytes)](../src/Base.sol#L71-L77)

../src/BaseState.sol#L53

- [ ] ID-1
      [BaseState.\_owner](../src/BaseState.sol#L40) is never initialized. It is used in:

../src/BaseState.sol#L40

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-2
      [BaseInstaller.upgradeModules(address[])](../src/BaseInstaller.sol#L127-L161) has external calls inside a loop: [moduleSettings*.moduleVersion <= IBaseModule(\_modules[moduleSettings*.moduleId]).moduleVersion()](../src/BaseInstaller.sol#L145)

../src/BaseInstaller.sol#L127-L161

- [ ] ID-3
      [BaseInstaller.upgradeModules(address[])](../src/BaseInstaller.sol#L127-L161) has external calls inside a loop: [moduleSettings\_ = IBaseModule(moduleAddress).moduleSettings()](../src/BaseInstaller.sol#L135)

../src/BaseInstaller.sol#L127-L161

- [ ] ID-4
      [BaseInstaller.addModules(address[])](../src/BaseInstaller.sol#L93-L116) has external calls inside a loop: [moduleSettings\_ = IBaseModule(moduleAddress).moduleSettings()](../src/BaseInstaller.sol#L99)

../src/BaseInstaller.sol#L93-L116

- [ ] ID-5
      [BaseInstaller.upgradeModules(address[])](../src/BaseInstaller.sol#L127-L161) has external calls inside a loop: [! IBaseModule(_modules[moduleSettings_.moduleId]).moduleUpgradeable()](../src/BaseInstaller.sol#L141)

../src/BaseInstaller.sol#L127-L161

- [ ] ID-6
      [BaseInstaller.removeModules(address[])](../src/BaseInstaller.sol#L172-L202) has external calls inside a loop: [moduleSettings\_ = IBaseModule(moduleAddress).moduleSettings()](../src/BaseInstaller.sol#L178)

../src/BaseInstaller.sol#L172-L202

## assembly

Impact: Informational
Confidence: High

- [ ] ID-7
      [BaseProxy.sentinel()](../src/BaseProxy.sol#L73-L88) uses assembly - [INLINE ASM](../src/BaseProxy.sol#L80-L83)

../src/BaseProxy.sol#L73-L88

- [ ] ID-8
      [BaseDispatcher.dispatch()](../src/BaseDispatcher.sol#L73-L121) uses assembly - [INLINE ASM](../src/BaseDispatcher.sol#L90-L120)

../src/BaseDispatcher.sol#L73-L121

- [ ] ID-9
      [Base.\_unpackTrailingParameters()](../src/Base.sol#L106-L112) uses assembly - [INLINE ASM](../src/Base.sol#L107-L111)

../src/Base.sol#L106-L112

- [ ] ID-10
      [Base.\_unpackProxyAddress()](../src/Base.sol#L94-L99) uses assembly - [INLINE ASM](../src/Base.sol#L96-L98)

../src/Base.sol#L94-L99

- [ ] ID-11
      [Base.\_unpackMessageSender()](../src/Base.sol#L83-L88) uses assembly - [INLINE ASM](../src/Base.sol#L85-L87)

../src/Base.sol#L83-L88

- [ ] ID-12
      [BaseProxy.\_fallback()](../src/BaseProxy.sol#L97-L194) uses assembly - [INLINE ASM](../src/BaseProxy.sol#L103-L148) - [INLINE ASM](../src/BaseProxy.sol#L151-L192)

../src/BaseProxy.sol#L97-L194

- [ ] ID-13
      [Base.\_revertBytes(bytes)](../src/Base.sol#L118-L126) uses assembly - [INLINE ASM](../src/Base.sol#L120-L122)

../src/Base.sol#L118-L126

## costly-loop

Impact: Informational
Confidence: Medium

- [ ] ID-14
      [BaseInstaller.removeModules(address[])](../src/BaseInstaller.sol#L172-L202) has costly operations inside a loop: - [delete _modules[moduleSettings_.moduleId]](../src/BaseInstaller.sol#L194)

../src/BaseInstaller.sol#L172-L202

- [ ] ID-15
      [BaseInstaller.removeModules(address[])](../src/BaseInstaller.sol#L172-L202) has costly operations inside a loop: - [delete _proxies[moduleSettings_.moduleId]](../src/BaseInstaller.sol#L192)

../src/BaseInstaller.sol#L172-L202

- [ ] ID-16
      [BaseInstaller.removeModules(address[])](../src/BaseInstaller.sol#L172-L202) has costly operations inside a loop: - [delete \_relations[proxyAddress]](../src/BaseInstaller.sol#L186)

../src/BaseInstaller.sol#L172-L202

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-17
      Low level call in [Base.\_callInternalModule(uint32,bytes)](../src/Base.sol#L71-L77): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/Base.sol#L72)

../src/Base.sol#L71-L77

- [ ] ID-18
      Low level call in [BaseProxy.implementation()](../src/BaseProxy.sol#L57-L67): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR,\_moduleId))](../src/BaseProxy.sol#L58-L60)

../src/BaseProxy.sol#L57-L67

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-19
      Variable [BaseState.\_modules](../src/BaseState.sol#L53) is not in mixedCase

../src/BaseState.sol#L53

- [ ] ID-20
      Variable [BaseState.\_relations](../src/BaseState.sol#L67) is not in mixedCase

../src/BaseState.sol#L67

- [ ] ID-21
      Variable [BaseState.\_pendingOwner](../src/BaseState.sol#L46) is not in mixedCase

../src/BaseState.sol#L46

- [ ] ID-22
      Variable [BaseModule.\_moduleId](../src/BaseModule.sol#L23) is not in mixedCase

../src/BaseModule.sol#L23

- [ ] ID-23
      Variable [BaseState.\_proxies](../src/BaseState.sol#L60) is not in mixedCase

../src/BaseState.sol#L60

- [ ] ID-24
      Variable [BaseState.\_owner](../src/BaseState.sol#L40) is not in mixedCase

../src/BaseState.sol#L40

- [ ] ID-25
      Variable [BaseState.\_reentrancyLock](../src/BaseState.sol#L34) is not in mixedCase

../src/BaseState.sol#L34

- [ ] ID-26
      Variable [BaseProxy.\_deployer](../src/BaseProxy.sol#L32) is not in mixedCase

../src/BaseProxy.sol#L32

- [ ] ID-27
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L28) is not in mixedCase

../src/BaseModule.sol#L28

- [ ] ID-28
      Variable [BaseProxy.\_moduleId](../src/BaseProxy.sol#L27) is not in mixedCase

../src/BaseProxy.sol#L27

- [ ] ID-29
      Variable [BaseState.\_\_gap](../src/BaseState.sol#L76) is not in mixedCase

../src/BaseState.sol#L76

- [ ] ID-30
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L33) is not in mixedCase

../src/BaseModule.sol#L33

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-31
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L28) is too similar to [Base._createProxy(uint32,uint16).moduleType_](../src/Base.sol#L46)

../src/BaseModule.sol#L28

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-32
      [BaseProxy.\_fallback()](../src/BaseProxy.sol#L97-L194) uses literals with too many digits: - [mstore(uint256,uint256)(0x00,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/BaseProxy.sol#L155-L159)

../src/BaseProxy.sol#L97-L194
