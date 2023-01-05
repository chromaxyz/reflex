Summary

- [controlled-delegatecall](#controlled-delegatecall) (1 results) (High)
- [uninitialized-state](#uninitialized-state) (2 results) (High)
- [locked-ether](#locked-ether) (1 results) (Medium)
- [calls-loop](#calls-loop) (9 results) (Low)
- [assembly](#assembly) (5 results) (Informational)
- [costly-loop](#costly-loop) (3 results) (Informational)
- [low-level-calls](#low-level-calls) (2 results) (Informational)
- [naming-convention](#naming-convention) (8 results) (Informational)
- [similar-names](#similar-names) (10 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)

## controlled-delegatecall

Impact: High
Confidence: Medium

- [ ] ID-0
      [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L80-L91) uses delegatecall to a input-controlled function id - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/internals/Base.sol#L84-L86)

../src/internals/Base.sol#L80-L91

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-1
      [BaseState.\_modules](../src/BaseState.sol#L63) is never initialized. It is used in: - [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L80-L91)

../src/BaseState.sol#L63

- [ ] ID-2
      [BaseState.\_owner](../src/BaseState.sol#L51) is never initialized. It is used in:

../src/BaseState.sol#L51

## locked-ether

Impact: Medium
Confidence: High

- [ ] ID-3
      Contract locking ether found:
      Contract [Proxy](../src/internals/Proxy.sol#L15-L191) has payable functions: - [Proxy.constructor()](../src/internals/Proxy.sol#L37-L39) - [Proxy.fallback()](../src/internals/Proxy.sol#L76-L190)
      But does not have a function to withdraw the ether

../src/internals/Proxy.sol#L15-L191

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-4
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L167-L199) has external calls inside a loop: [moduleType\_ = BaseModule(moduleAddress).moduleType()](../src/modules/BaseInstaller.sol#L176)

../src/modules/BaseInstaller.sol#L167-L199

- [ ] ID-5
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L133-L157) has external calls inside a loop: [moduleId\_ = BaseModule(moduleAddress).moduleId()](../src/modules/BaseInstaller.sol#L138)

../src/modules/BaseInstaller.sol#L133-L157

- [ ] ID-6
      [BaseInstaller.addModules(address[])](../src/modules/BaseInstaller.sol#L98-L123) has external calls inside a loop: [moduleType\_ = BaseModule(moduleAddress).moduleType()](../src/modules/BaseInstaller.sol#L107)

../src/modules/BaseInstaller.sol#L98-L123

- [ ] ID-7
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L133-L157) has external calls inside a loop: [moduleType\_ = BaseModule(moduleAddress).moduleType()](../src/modules/BaseInstaller.sol#L139)

../src/modules/BaseInstaller.sol#L133-L157

- [ ] ID-8
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L133-L157) has external calls inside a loop: [moduleVersion\_ = BaseModule(moduleAddress).moduleVersion()](../src/modules/BaseInstaller.sol#L140)

../src/modules/BaseInstaller.sol#L133-L157

- [ ] ID-9
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L167-L199) has external calls inside a loop: [moduleVersion\_ = BaseModule(moduleAddress).moduleVersion()](../src/modules/BaseInstaller.sol#L177)

../src/modules/BaseInstaller.sol#L167-L199

- [ ] ID-10
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L167-L199) has external calls inside a loop: [moduleId\_ = BaseModule(moduleAddress).moduleId()](../src/modules/BaseInstaller.sol#L175)

../src/modules/BaseInstaller.sol#L167-L199

- [ ] ID-11
      [BaseInstaller.addModules(address[])](../src/modules/BaseInstaller.sol#L98-L123) has external calls inside a loop: [moduleVersion\_ = BaseModule(moduleAddress).moduleVersion()](../src/modules/BaseInstaller.sol#L108)

../src/modules/BaseInstaller.sol#L98-L123

- [ ] ID-12
      [BaseInstaller.addModules(address[])](../src/modules/BaseInstaller.sol#L98-L123) has external calls inside a loop: [moduleId\_ = BaseModule(moduleAddress).moduleId()](../src/modules/BaseInstaller.sol#L106)

../src/modules/BaseInstaller.sol#L98-L123

## assembly

Impact: Informational
Confidence: High

- [ ] ID-13
      [Base.\_unpackMessageSender()](../src/internals/Base.sol#L97-L107) uses assembly - [INLINE ASM](../src/internals/Base.sol#L104-L106)

../src/internals/Base.sol#L97-L107

- [ ] ID-14
      [Proxy.fallback()](../src/internals/Proxy.sol#L76-L190) uses assembly - [INLINE ASM](../src/internals/Proxy.sol#L82-L145) - [INLINE ASM](../src/internals/Proxy.sol#L148-L188)

../src/internals/Proxy.sol#L76-L190

- [ ] ID-15
      [Base.\_unpackProxyAddress()](../src/internals/Base.sol#L113-L123) uses assembly - [INLINE ASM](../src/internals/Base.sol#L120-L122)

../src/internals/Base.sol#L113-L123

- [ ] ID-16
      [Base.\_revertBytes(bytes)](../src/internals/Base.sol#L129-L137) uses assembly - [INLINE ASM](../src/internals/Base.sol#L131-L133)

../src/internals/Base.sol#L129-L137

- [ ] ID-17
      [BaseDispatcher.dispatch()](../src/BaseDispatcher.sol#L119-L172) uses assembly - [INLINE ASM](../src/BaseDispatcher.sol#L141-L171)

../src/BaseDispatcher.sol#L119-L172

## costly-loop

Impact: Informational
Confidence: Medium

- [ ] ID-18
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L167-L199) has costly operations inside a loop: - [delete \_trusts[proxyAddress]](../src/modules/BaseInstaller.sol#L183)

../src/modules/BaseInstaller.sol#L167-L199

- [ ] ID-19
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L167-L199) has costly operations inside a loop: - [delete _modules[moduleId_]](../src/modules/BaseInstaller.sol#L191)

../src/modules/BaseInstaller.sol#L167-L199

- [ ] ID-20
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L167-L199) has costly operations inside a loop: - [delete _proxies[moduleId_]](../src/modules/BaseInstaller.sol#L189)

../src/modules/BaseInstaller.sol#L167-L199

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-21
      Low level call in [Proxy.implementation()](../src/internals/Proxy.sol#L50-L66): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_PROXY_ADDRESS_TO_MODULE_IMPLEMENTATION_SELECTOR,address(this)))](../src/internals/Proxy.sol#L54-L59)

../src/internals/Proxy.sol#L50-L66

- [ ] ID-22
      Low level call in [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L80-L91): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/internals/Base.sol#L84-L86)

../src/internals/Base.sol#L80-L91

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-23
      Variable [BaseState.\_trusts](../src/BaseState.sol#L75) is not in mixedCase

../src/BaseState.sol#L75

- [ ] ID-24
      Variable [BaseState.\_modules](../src/BaseState.sol#L63) is not in mixedCase

../src/BaseState.sol#L63

- [ ] ID-25
      Variable [BaseState.\_pendingOwner](../src/BaseState.sol#L57) is not in mixedCase

../src/BaseState.sol#L57

- [ ] ID-26
      Variable [BaseState.\_proxies](../src/BaseState.sol#L69) is not in mixedCase

../src/BaseState.sol#L69

- [ ] ID-27
      Variable [BaseState.\_owner](../src/BaseState.sol#L51) is not in mixedCase

../src/BaseState.sol#L51

- [ ] ID-28
      Variable [BaseState.\_reentrancyLock](../src/BaseState.sol#L45) is not in mixedCase

../src/BaseState.sol#L45

- [ ] ID-29
      Variable [BaseState.\_\_gap](../src/BaseState.sol#L84) is not in mixedCase

../src/BaseState.sol#L84

- [ ] ID-30
      Variable [Proxy.\_deployer](../src/internals/Proxy.sol#L31) is not in mixedCase

../src/internals/Proxy.sol#L31

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-31
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is too similar to [BaseInstaller.constructor(uint16).moduleVersion\_](../src/modules/BaseInstaller.sol#L23)

../src/BaseModule.sol#L32

- [ ] ID-32
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is too similar to [BaseModule.constructor(uint32,uint16,uint16).moduleVersion\_](../src/BaseModule.sol#L58)

../src/BaseModule.sol#L32

- [ ] ID-33
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is too similar to [BaseInstaller.removeModules(address[]).moduleVersion\_](../src/modules/BaseInstaller.sol#L177)

../src/BaseModule.sol#L32

- [ ] ID-34
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [BaseModule.constructor(uint32,uint16,uint16).moduleType\_](../src/BaseModule.sol#L58)

../src/BaseModule.sol#L27

- [ ] ID-35
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [BaseInstaller.removeModules(address[]).moduleType\_](../src/modules/BaseInstaller.sol#L176)

../src/BaseModule.sol#L27

- [ ] ID-36
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is too similar to [BaseInstaller.addModules(address[]).moduleVersion\_](../src/modules/BaseInstaller.sol#L108)

../src/BaseModule.sol#L32

- [ ] ID-37
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [BaseInstaller.addModules(address[]).moduleType\_](../src/modules/BaseInstaller.sol#L107)

../src/BaseModule.sol#L27

- [ ] ID-38
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is too similar to [BaseInstaller.upgradeModules(address[]).moduleVersion\_](../src/modules/BaseInstaller.sol#L140)

../src/BaseModule.sol#L32

- [ ] ID-39
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [BaseInstaller.upgradeModules(address[]).moduleType\_](../src/modules/BaseInstaller.sol#L139)

../src/BaseModule.sol#L27

- [ ] ID-40
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [Base._createProxy(uint32,uint16).moduleType_](../src/internals/Base.sol#L51)

../src/BaseModule.sol#L27

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-41
      [Proxy.fallback()](../src/internals/Proxy.sol#L76-L190) uses literals with too many digits: - [mstore(uint256,uint256)(0x00,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/internals/Proxy.sol#L152-L155)

../src/internals/Proxy.sol#L76-L190
