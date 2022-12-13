Summary

- [controlled-delegatecall](#controlled-delegatecall) (1 results) (High)
- [uninitialized-state](#uninitialized-state) (2 results) (High)
- [locked-ether](#locked-ether) (1 results) (Medium)
- [calls-loop](#calls-loop) (9 results) (Low)
- [assembly](#assembly) (5 results) (Informational)
- [costly-loop](#costly-loop) (3 results) (Informational)
- [dead-code](#dead-code) (1 results) (Informational)
- [low-level-calls](#low-level-calls) (1 results) (Informational)
- [naming-convention](#naming-convention) (8 results) (Informational)
- [similar-names](#similar-names) (11 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)

## controlled-delegatecall

Impact: High
Confidence: Medium

- [ ] ID-0
      [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L55-L66) uses delegatecall to a input-controlled function id - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/internals/Base.sol#L59-L61)

../src/internals/Base.sol#L55-L66

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-1
      [BaseState.\_modules](../src/BaseState.sol#L68) is never initialized. It is used in: - [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L55-L66)

../src/BaseState.sol#L68

- [ ] ID-2
      [BaseState.\_owner](../src/BaseState.sol#L56) is never initialized. It is used in:

../src/BaseState.sol#L56

## locked-ether

Impact: Medium
Confidence: High

- [ ] ID-3
      Contract locking ether found:
      Contract [Proxy](../src/internals/Proxy.sol#L12-L151) has payable functions: - [Proxy.constructor()](../src/internals/Proxy.sol#L23-L25) - [Proxy.fallback()](../src/internals/Proxy.sol#L34-L150)
      But does not have a function to withdraw the ether

../src/internals/Proxy.sol#L12-L151

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-4
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L128-L152) has external calls inside a loop: [moduleId\_ = BaseModule(moduleAddress).moduleId()](../src/modules/BaseInstaller.sol#L133)

../src/modules/BaseInstaller.sol#L128-L152

- [ ] ID-5
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L162-L191) has external calls inside a loop: [moduleVersion\_ = BaseModule(moduleAddress).moduleVersion()](../src/modules/BaseInstaller.sol#L169)

../src/modules/BaseInstaller.sol#L162-L191

- [ ] ID-6
      [BaseInstaller.addModules(address[])](../src/modules/BaseInstaller.sol#L96-L118) has external calls inside a loop: [moduleId\_ = BaseModule(moduleAddress).moduleId()](../src/modules/BaseInstaller.sol#L101)

../src/modules/BaseInstaller.sol#L96-L118

- [ ] ID-7
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L162-L191) has external calls inside a loop: [moduleType\_ = BaseModule(moduleAddress).moduleType()](../src/modules/BaseInstaller.sol#L168)

../src/modules/BaseInstaller.sol#L162-L191

- [ ] ID-8
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L128-L152) has external calls inside a loop: [moduleType\_ = BaseModule(moduleAddress).moduleType()](../src/modules/BaseInstaller.sol#L134)

../src/modules/BaseInstaller.sol#L128-L152

- [ ] ID-9
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L162-L191) has external calls inside a loop: [moduleId\_ = BaseModule(moduleAddress).moduleId()](../src/modules/BaseInstaller.sol#L167)

../src/modules/BaseInstaller.sol#L162-L191

- [ ] ID-10
      [BaseInstaller.addModules(address[])](../src/modules/BaseInstaller.sol#L96-L118) has external calls inside a loop: [moduleVersion\_ = BaseModule(moduleAddress).moduleVersion()](../src/modules/BaseInstaller.sol#L103)

../src/modules/BaseInstaller.sol#L96-L118

- [ ] ID-11
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L128-L152) has external calls inside a loop: [moduleVersion\_ = BaseModule(moduleAddress).moduleVersion()](../src/modules/BaseInstaller.sol#L135)

../src/modules/BaseInstaller.sol#L128-L152

- [ ] ID-12
      [BaseInstaller.addModules(address[])](../src/modules/BaseInstaller.sol#L96-L118) has external calls inside a loop: [moduleType\_ = BaseModule(moduleAddress).moduleType()](../src/modules/BaseInstaller.sol#L102)

../src/modules/BaseInstaller.sol#L96-L118

## assembly

Impact: Informational
Confidence: High

- [ ] ID-13
      [BaseDispatcher.dispatch()](../src/BaseDispatcher.sol#L89-L140) uses assembly - [INLINE ASM](../src/BaseDispatcher.sol#L109-L139)

../src/BaseDispatcher.sol#L89-L140

- [ ] ID-14
      [Proxy.fallback()](../src/internals/Proxy.sol#L34-L150) uses assembly - [INLINE ASM](../src/internals/Proxy.sol#L40-L103) - [INLINE ASM](../src/internals/Proxy.sol#L106-L148)

../src/internals/Proxy.sol#L34-L150

- [ ] ID-15
      [Base.\_revertBytes(bytes)](../src/internals/Base.sol#L103-L111) uses assembly - [INLINE ASM](../src/internals/Base.sol#L105-L107)

../src/internals/Base.sol#L103-L111

- [ ] ID-16
      [Base.\_unpackParameters()](../src/internals/Base.sol#L86-L97) uses assembly - [INLINE ASM](../src/internals/Base.sol#L93-L96)

../src/internals/Base.sol#L86-L97

- [ ] ID-17
      [Base.\_unpackMessageSender()](../src/internals/Base.sol#L71-L81) uses assembly - [INLINE ASM](../src/internals/Base.sol#L78-L80)

../src/internals/Base.sol#L71-L81

## costly-loop

Impact: Informational
Confidence: Medium

- [ ] ID-18
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L162-L191) has costly operations inside a loop: - [delete _proxies[moduleId_]](../src/modules/BaseInstaller.sol#L181)

../src/modules/BaseInstaller.sol#L162-L191

- [ ] ID-19
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L162-L191) has costly operations inside a loop: - [delete _modules[moduleId_]](../src/modules/BaseInstaller.sol#L183)

../src/modules/BaseInstaller.sol#L162-L191

- [ ] ID-20
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L162-L191) has costly operations inside a loop: - [delete \_trusts[proxyAddress]](../src/modules/BaseInstaller.sol#L175)

../src/modules/BaseInstaller.sol#L162-L191

## dead-code

Impact: Informational
Confidence: Medium

- [ ] ID-21
      [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L55-L66) is never used and should be removed

../src/internals/Base.sol#L55-L66

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-22
      Low level call in [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L55-L66): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/internals/Base.sol#L59-L61)

../src/internals/Base.sol#L55-L66

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-23
      Variable [BaseState.\_trusts](../src/BaseState.sol#L80) is not in mixedCase

../src/BaseState.sol#L80

- [ ] ID-24
      Variable [BaseState.\_modules](../src/BaseState.sol#L68) is not in mixedCase

../src/BaseState.sol#L68

- [ ] ID-25
      Variable [BaseState.\_pendingOwner](../src/BaseState.sol#L62) is not in mixedCase

../src/BaseState.sol#L62

- [ ] ID-26
      Variable [BaseState.\_proxies](../src/BaseState.sol#L74) is not in mixedCase

../src/BaseState.sol#L74

- [ ] ID-27
      Variable [BaseState.\_owner](../src/BaseState.sol#L56) is not in mixedCase

../src/BaseState.sol#L56

- [ ] ID-28
      Variable [BaseState.\_name](../src/BaseState.sol#L50) is not in mixedCase

../src/BaseState.sol#L50

- [ ] ID-29
      Variable [BaseState.\_\_gap](../src/BaseState.sol#L89) is not in mixedCase

../src/BaseState.sol#L89

- [ ] ID-30
      Variable [Proxy.\_deployer](../src/internals/Proxy.sol#L17) is not in mixedCase

../src/internals/Proxy.sol#L17

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-31
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L27) is too similar to [BaseModule.constructor(uint32,uint16,uint16).moduleVersion\_](../src/BaseModule.sol#L58)

../src/BaseModule.sol#L27

- [ ] ID-32
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L27) is too similar to [BaseInstaller.constructor(uint32,uint16,uint16).moduleVersion\_](../src/modules/BaseInstaller.sol#L27)

../src/BaseModule.sol#L27

- [ ] ID-33
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L27) is too similar to [BaseInstaller.removeModules(address[]).moduleVersion\_](../src/modules/BaseInstaller.sol#L169)

../src/BaseModule.sol#L27

- [ ] ID-34
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L32) is too similar to [BaseModule.constructor(uint32,uint16,uint16).moduleType\_](../src/BaseModule.sol#L58)

../src/BaseModule.sol#L32

- [ ] ID-35
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L32) is too similar to [BaseInstaller.removeModules(address[]).moduleType\_](../src/modules/BaseInstaller.sol#L168)

../src/BaseModule.sol#L32

- [ ] ID-36
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L27) is too similar to [BaseInstaller.addModules(address[]).moduleVersion\_](../src/modules/BaseInstaller.sol#L103)

../src/BaseModule.sol#L27

- [ ] ID-37
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L32) is too similar to [BaseInstaller.addModules(address[]).moduleType\_](../src/modules/BaseInstaller.sol#L102)

../src/BaseModule.sol#L32

- [ ] ID-38
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L32) is too similar to [BaseInstaller.constructor(uint32,uint16,uint16).moduleType\_](../src/modules/BaseInstaller.sol#L26)

../src/BaseModule.sol#L32

- [ ] ID-39
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L27) is too similar to [BaseInstaller.upgradeModules(address[]).moduleVersion\_](../src/modules/BaseInstaller.sol#L135)

../src/BaseModule.sol#L27

- [ ] ID-40
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L32) is too similar to [BaseInstaller.upgradeModules(address[]).moduleType\_](../src/modules/BaseInstaller.sol#L134)

../src/BaseModule.sol#L32

- [ ] ID-41
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L32) is too similar to [Base._createProxy(uint32,uint16).moduleType_](../src/internals/Base.sol#L28)

../src/BaseModule.sol#L32

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-42
      [Proxy.fallback()](../src/internals/Proxy.sol#L34-L150) uses literals with too many digits: - [mstore(uint256,uint256)(0,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/internals/Proxy.sol#L112-L115)

../src/internals/Proxy.sol#L34-L150
