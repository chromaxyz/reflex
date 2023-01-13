Summary

- [uninitialized-state](#uninitialized-state) (2 results) (High)
- [calls-loop](#calls-loop) (5 results) (Low)
- [assembly](#assembly) (6 results) (Informational)
- [costly-loop](#costly-loop) (3 results) (Informational)
- [low-level-calls](#low-level-calls) (2 results) (Informational)
- [naming-convention](#naming-convention) (12 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-0
      [BaseState.\_modules](../src/BaseState.sol#L53) is never initialized. It is used in: - [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L72-L78)

../src/BaseState.sol#L53

- [ ] ID-1
      [BaseState.\_owner](../src/BaseState.sol#L40) is never initialized. It is used in:

../src/BaseState.sol#L40

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-2
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L171-L201) has external calls inside a loop: [moduleSettings\_ = BaseModule(moduleAddress).moduleSettings()](../src/modules/BaseInstaller.sol#L177)

../src/modules/BaseInstaller.sol#L171-L201

- [ ] ID-3
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L126-L160) has external calls inside a loop: [moduleSettings*.moduleVersion <= IBaseModule(\_modules[moduleSettings*.moduleId]).moduleVersion()](../src/modules/BaseInstaller.sol#L144)

../src/modules/BaseInstaller.sol#L126-L160

- [ ] ID-4
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L126-L160) has external calls inside a loop: [! IBaseModule(_modules[moduleSettings_.moduleId]).moduleUpgradeable()](../src/modules/BaseInstaller.sol#L140)

../src/modules/BaseInstaller.sol#L126-L160

- [ ] ID-5
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L126-L160) has external calls inside a loop: [moduleSettings\_ = BaseModule(moduleAddress).moduleSettings()](../src/modules/BaseInstaller.sol#L134)

../src/modules/BaseInstaller.sol#L126-L160

- [ ] ID-6
      [BaseInstaller.addModules(address[])](../src/modules/BaseInstaller.sol#L92-L115) has external calls inside a loop: [moduleSettings\_ = BaseModule(moduleAddress).moduleSettings()](../src/modules/BaseInstaller.sol#L98)

../src/modules/BaseInstaller.sol#L92-L115

## assembly

Impact: Informational
Confidence: High

- [ ] ID-7
      [Base.\_unpackMessageSender()](../src/internals/Base.sol#L84-L89) uses assembly - [INLINE ASM](../src/internals/Base.sol#L86-L88)

../src/internals/Base.sol#L84-L89

- [ ] ID-8
      [BaseProxy.sentinel()](../src/internals/BaseProxy.sol#L76-L91) uses assembly - [INLINE ASM](../src/internals/BaseProxy.sol#L83-L86)

../src/internals/BaseProxy.sol#L76-L91

- [ ] ID-9
      [Base.\_unpackProxyAddress()](../src/internals/Base.sol#L95-L100) uses assembly - [INLINE ASM](../src/internals/Base.sol#L97-L99)

../src/internals/Base.sol#L95-L100

- [ ] ID-10
      [Base.\_revertBytes(bytes)](../src/internals/Base.sol#L106-L114) uses assembly - [INLINE ASM](../src/internals/Base.sol#L108-L110)

../src/internals/Base.sol#L106-L114

- [ ] ID-11
      [BaseDispatcher.dispatch()](../src/BaseDispatcher.sol#L71-L119) uses assembly - [INLINE ASM](../src/BaseDispatcher.sol#L88-L118)

../src/BaseDispatcher.sol#L71-L119

- [ ] ID-12
      [BaseProxy.\_fallback()](../src/internals/BaseProxy.sol#L100-L197) uses assembly - [INLINE ASM](../src/internals/BaseProxy.sol#L106-L151) - [INLINE ASM](../src/internals/BaseProxy.sol#L154-L195)

../src/internals/BaseProxy.sol#L100-L197

## costly-loop

Impact: Informational
Confidence: Medium

- [ ] ID-13
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L171-L201) has costly operations inside a loop: - [delete _modules[moduleSettings_.moduleId]](../src/modules/BaseInstaller.sol#L193)

../src/modules/BaseInstaller.sol#L171-L201

- [ ] ID-14
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L171-L201) has costly operations inside a loop: - [delete _proxies[moduleSettings_.moduleId]](../src/modules/BaseInstaller.sol#L191)

../src/modules/BaseInstaller.sol#L171-L201

- [ ] ID-15
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L171-L201) has costly operations inside a loop: - [delete \_relations[proxyAddress]](../src/modules/BaseInstaller.sol#L185)

../src/modules/BaseInstaller.sol#L171-L201

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-16
      Low level call in [BaseProxy.implementation()](../src/internals/BaseProxy.sol#L60-L70): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR,\_moduleId))](../src/internals/BaseProxy.sol#L61-L63)

../src/internals/BaseProxy.sol#L60-L70

- [ ] ID-17
      Low level call in [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L72-L78): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/internals/Base.sol#L73)

../src/internals/Base.sol#L72-L78

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-18
      Variable [BaseState.\_modules](../src/BaseState.sol#L53) is not in mixedCase

../src/BaseState.sol#L53

- [ ] ID-19
      Variable [BaseState.\_relations](../src/BaseState.sol#L67) is not in mixedCase

../src/BaseState.sol#L67

- [ ] ID-20
      Variable [BaseState.\_pendingOwner](../src/BaseState.sol#L46) is not in mixedCase

../src/BaseState.sol#L46

- [ ] ID-21
      Variable [BaseModule.\_moduleId](../src/BaseModule.sol#L22) is not in mixedCase

../src/BaseModule.sol#L22

- [ ] ID-22
      Variable [BaseState.\_proxies](../src/BaseState.sol#L60) is not in mixedCase

../src/BaseState.sol#L60

- [ ] ID-23
      Variable [BaseState.\_owner](../src/BaseState.sol#L40) is not in mixedCase

../src/BaseState.sol#L40

- [ ] ID-24
      Variable [BaseState.\_reentrancyLock](../src/BaseState.sol#L34) is not in mixedCase

../src/BaseState.sol#L34

- [ ] ID-25
      Variable [BaseProxy.\_deployer](../src/internals/BaseProxy.sol#L35) is not in mixedCase

../src/internals/BaseProxy.sol#L35

- [ ] ID-26
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is not in mixedCase

../src/BaseModule.sol#L27

- [ ] ID-27
      Variable [BaseProxy.\_moduleId](../src/internals/BaseProxy.sol#L30) is not in mixedCase

../src/internals/BaseProxy.sol#L30

- [ ] ID-28
      Variable [BaseState.\_\_gap](../src/BaseState.sol#L76) is not in mixedCase

../src/BaseState.sol#L76

- [ ] ID-29
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is not in mixedCase

../src/BaseModule.sol#L32

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-30
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [Base._createProxy(uint32,uint16).moduleType_](../src/internals/Base.sol#L48)

../src/BaseModule.sol#L27

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-31
      [BaseProxy.\_fallback()](../src/internals/BaseProxy.sol#L100-L197) uses literals with too many digits: - [mstore(uint256,uint256)(0x00,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/internals/BaseProxy.sol#L158-L162)

../src/internals/BaseProxy.sol#L100-L197
