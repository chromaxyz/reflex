Summary

- [controlled-delegatecall](#controlled-delegatecall) (1 results) (High)
- [uninitialized-state](#uninitialized-state) (2 results) (High)
- [locked-ether](#locked-ether) (1 results) (Medium)
- [calls-loop](#calls-loop) (9 results) (Low)
- [assembly](#assembly) (5 results) (Informational)
- [costly-loop](#costly-loop) (3 results) (Informational)
- [low-level-calls](#low-level-calls) (1 results) (Informational)
- [naming-convention](#naming-convention) (8 results) (Informational)
- [similar-names](#similar-names) (10 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)

## controlled-delegatecall

Impact: High
Confidence: Medium

- [ ] ID-0
      [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L57-L68) uses delegatecall to a input-controlled function id - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/internals/Base.sol#L61-L63)

../src/internals/Base.sol#L57-L68

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-1
      [BaseState.\_modules](../src/BaseState.sol#L70) is never initialized. It is used in: - [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L57-L68)

../src/BaseState.sol#L70

- [ ] ID-2
      [BaseState.\_owner](../src/BaseState.sol#L58) is never initialized. It is used in:

../src/BaseState.sol#L58

## locked-ether

Impact: Medium
Confidence: High

- [ ] ID-3
      Contract locking ether found:
      Contract [Proxy](../src/internals/Proxy.sol#L12-L147) has payable functions: - [Proxy.constructor()](../src/internals/Proxy.sol#L23-L25) - [Proxy.fallback()](../src/internals/Proxy.sol#L32-L146)
      But does not have a function to withdraw the ether

../src/internals/Proxy.sol#L12-L147

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
      [BaseDispatcher.dispatch()](../src/BaseDispatcher.sol#L88-L141) uses assembly - [INLINE ASM](../src/BaseDispatcher.sol#L110-L140)

../src/BaseDispatcher.sol#L88-L141

- [ ] ID-14
      [Base.\_revertBytes(bytes)](../src/internals/Base.sol#L105-L113) uses assembly - [INLINE ASM](../src/internals/Base.sol#L107-L109)

../src/internals/Base.sol#L105-L113

- [ ] ID-15
      [Proxy.fallback()](../src/internals/Proxy.sol#L32-L146) uses assembly - [INLINE ASM](../src/internals/Proxy.sol#L38-L101) - [INLINE ASM](../src/internals/Proxy.sol#L104-L144)

../src/internals/Proxy.sol#L32-L146

- [ ] ID-16
      [Base.\_unpackParameters()](../src/internals/Base.sol#L88-L99) uses assembly - [INLINE ASM](../src/internals/Base.sol#L95-L98)

../src/internals/Base.sol#L88-L99

- [ ] ID-17
      [Base.\_unpackMessageSender()](../src/internals/Base.sol#L73-L83) uses assembly - [INLINE ASM](../src/internals/Base.sol#L80-L82)

../src/internals/Base.sol#L73-L83

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
      Low level call in [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L57-L68): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/internals/Base.sol#L61-L63)

../src/internals/Base.sol#L57-L68

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-22
      Variable [BaseState.\_trusts](../src/BaseState.sol#L82) is not in mixedCase

../src/BaseState.sol#L82

- [ ] ID-23
      Variable [BaseState.\_modules](../src/BaseState.sol#L70) is not in mixedCase

../src/BaseState.sol#L70

- [ ] ID-24
      Variable [BaseState.\_pendingOwner](../src/BaseState.sol#L64) is not in mixedCase

../src/BaseState.sol#L64

- [ ] ID-25
      Variable [BaseState.\_proxies](../src/BaseState.sol#L76) is not in mixedCase

../src/BaseState.sol#L76

- [ ] ID-26
      Variable [BaseState.\_owner](../src/BaseState.sol#L58) is not in mixedCase

../src/BaseState.sol#L58

- [ ] ID-27
      Variable [BaseState.\_name](../src/BaseState.sol#L52) is not in mixedCase

../src/BaseState.sol#L52

- [ ] ID-28
      Variable [BaseState.\_\_gap](../src/BaseState.sol#L91) is not in mixedCase

../src/BaseState.sol#L91

- [ ] ID-29
      Variable [Proxy.\_deployer](../src/internals/Proxy.sol#L17) is not in mixedCase

../src/internals/Proxy.sol#L17

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-30
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is too similar to [BaseInstaller.constructor(uint16).moduleVersion\_](../src/modules/BaseInstaller.sol#L23)

../src/BaseModule.sol#L32

- [ ] ID-31
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is too similar to [BaseModule.constructor(uint32,uint16,uint16).moduleVersion\_](../src/BaseModule.sol#L58)

../src/BaseModule.sol#L32

- [ ] ID-32
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is too similar to [BaseInstaller.removeModules(address[]).moduleVersion\_](../src/modules/BaseInstaller.sol#L177)

../src/BaseModule.sol#L32

- [ ] ID-33
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [BaseModule.constructor(uint32,uint16,uint16).moduleType\_](../src/BaseModule.sol#L58)

../src/BaseModule.sol#L27

- [ ] ID-34
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [BaseInstaller.removeModules(address[]).moduleType\_](../src/modules/BaseInstaller.sol#L176)

../src/BaseModule.sol#L27

- [ ] ID-35
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is too similar to [BaseInstaller.addModules(address[]).moduleVersion\_](../src/modules/BaseInstaller.sol#L108)

../src/BaseModule.sol#L32

- [ ] ID-36
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [BaseInstaller.addModules(address[]).moduleType\_](../src/modules/BaseInstaller.sol#L107)

../src/BaseModule.sol#L27

- [ ] ID-37
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is too similar to [BaseInstaller.upgradeModules(address[]).moduleVersion\_](../src/modules/BaseInstaller.sol#L140)

../src/BaseModule.sol#L32

- [ ] ID-38
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [BaseInstaller.upgradeModules(address[]).moduleType\_](../src/modules/BaseInstaller.sol#L139)

../src/BaseModule.sol#L27

- [ ] ID-39
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [Base._createProxy(uint32,uint16).moduleType_](../src/internals/Base.sol#L28)

../src/BaseModule.sol#L27

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-40
      [Proxy.fallback()](../src/internals/Proxy.sol#L32-L146) uses literals with too many digits: - [mstore(uint256,uint256)(0x00,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/internals/Proxy.sol#L108-L111)

../src/internals/Proxy.sol#L32-L146
