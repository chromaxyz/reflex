Summary

- [uninitialized-state](#uninitialized-state) (1 results) (High)
- [locked-ether](#locked-ether) (1 results) (Medium)
- [calls-loop](#calls-loop) (6 results) (Low)
- [assembly](#assembly) (4 results) (Informational)
- [costly-loop](#costly-loop) (3 results) (Informational)
- [naming-convention](#naming-convention) (6 results) (Informational)
- [similar-names](#similar-names) (2 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-0
      [BaseState.\_owner](../src/abstracts/BaseState.sol#L38) is never initialized. It is used in:

../src/abstracts/BaseState.sol#L38

## locked-ether

Impact: Medium
Confidence: High

- [ ] ID-1
      Contract locking ether found:
      Contract [Proxy](../src/internals/Proxy.sol#L12-L149) has payable functions: - [Proxy.fallback()](../src/internals/Proxy.sol#L33-L148)
      But does not have a function to withdraw the ether

../src/internals/Proxy.sol#L12-L149

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-2
      [BaseInstaller.removeModules(address[])](../src/abstracts/BaseInstaller.sol#L160-L192) has external calls inside a loop: [existingModuleVersion = BaseModule(moduleAddress).moduleVersion()](../src/abstracts/BaseInstaller.sol#L166-L167)

../src/abstracts/BaseInstaller.sol#L160-L192

- [ ] ID-3
      [BaseInstaller.upgradeModules(address[])](../src/abstracts/BaseInstaller.sol#L121-L150) has external calls inside a loop: [existingModuleId = BaseModule(moduleAddress).moduleId()](../src/abstracts/BaseInstaller.sol#L126)

../src/abstracts/BaseInstaller.sol#L121-L150

- [ ] ID-4
      [BaseInstaller.removeModules(address[])](../src/abstracts/BaseInstaller.sol#L160-L192) has external calls inside a loop: [existingModuleId = BaseModule(moduleAddress).moduleId()](../src/abstracts/BaseInstaller.sol#L165)

../src/abstracts/BaseInstaller.sol#L160-L192

- [ ] ID-5
      [BaseInstaller.upgradeModules(address[])](../src/abstracts/BaseInstaller.sol#L121-L150) has external calls inside a loop: [existingModuleVersion = BaseModule(moduleAddress).moduleVersion()](../src/abstracts/BaseInstaller.sol#L127-L128)

../src/abstracts/BaseInstaller.sol#L121-L150

- [ ] ID-6
      [BaseInstaller.addModules(address[])](../src/abstracts/BaseInstaller.sol#L92-L111) has external calls inside a loop: [newModuleVersion = BaseModule(moduleAddress).moduleVersion()](../src/abstracts/BaseInstaller.sol#L96)

../src/abstracts/BaseInstaller.sol#L92-L111

- [ ] ID-7
      [BaseInstaller.addModules(address[])](../src/abstracts/BaseInstaller.sol#L92-L111) has external calls inside a loop: [newModuleId = BaseModule(moduleAddress).moduleId()](../src/abstracts/BaseInstaller.sol#L95)

../src/abstracts/BaseInstaller.sol#L92-L111

## assembly

Impact: Informational
Confidence: High

- [ ] ID-8
      [Base.\_unpackMessageSender()](../src/internals/Base.sol#L47-L56) uses assembly - [INLINE ASM](../src/internals/Base.sol#L53-L55)

../src/internals/Base.sol#L47-L56

- [ ] ID-9
      [Proxy.fallback()](../src/internals/Proxy.sol#L33-L148) uses assembly - [INLINE ASM](../src/internals/Proxy.sol#L39-L102) - [INLINE ASM](../src/internals/Proxy.sol#L105-L146)

../src/internals/Proxy.sol#L33-L148

- [ ] ID-10
      [Base.\_unpackParameters()](../src/internals/Base.sol#L61-L71) uses assembly - [INLINE ASM](../src/internals/Base.sol#L67-L70)

../src/internals/Base.sol#L61-L71

- [ ] ID-11
      [Dispatcher.dispatch()](../src/abstracts/Dispatcher.sol#L82-L132) uses assembly - [INLINE ASM](../src/abstracts/Dispatcher.sol#L101-L131)

../src/abstracts/Dispatcher.sol#L82-L132

## costly-loop

Impact: Informational
Confidence: Medium

- [ ] ID-12
      [BaseInstaller.removeModules(address[])](../src/abstracts/BaseInstaller.sol#L160-L192) has costly operations inside a loop: - [delete \_trusts[proxyAddress]](../src/abstracts/BaseInstaller.sol#L174)

../src/abstracts/BaseInstaller.sol#L160-L192

- [ ] ID-13
      [BaseInstaller.removeModules(address[])](../src/abstracts/BaseInstaller.sol#L160-L192) has costly operations inside a loop: - [delete \_proxies[existingModuleId]](../src/abstracts/BaseInstaller.sol#L178)

../src/abstracts/BaseInstaller.sol#L160-L192

- [ ] ID-14
      [BaseInstaller.removeModules(address[])](../src/abstracts/BaseInstaller.sol#L160-L192) has costly operations inside a loop: - [delete \_modules[existingModuleId]](../src/abstracts/BaseInstaller.sol#L180)

../src/abstracts/BaseInstaller.sol#L160-L192

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-15
      Variable [BaseState.\_trusts](../src/abstracts/BaseState.sol#L50) is not in mixedCase

../src/abstracts/BaseState.sol#L50

- [ ] ID-16
      Variable [BaseState.\_modules](../src/abstracts/BaseState.sol#L44) is not in mixedCase

../src/abstracts/BaseState.sol#L44

- [ ] ID-17
      Variable [BaseState.\_pendingOwner](../src/abstracts/BaseState.sol#L41) is not in mixedCase

../src/abstracts/BaseState.sol#L41

- [ ] ID-18
      Variable [BaseState.\_proxies](../src/abstracts/BaseState.sol#L47) is not in mixedCase

../src/abstracts/BaseState.sol#L47

- [ ] ID-19
      Variable [BaseState.\_owner](../src/abstracts/BaseState.sol#L38) is not in mixedCase

../src/abstracts/BaseState.sol#L38

- [ ] ID-20
      Variable [BaseState.\_name](../src/abstracts/BaseState.sol#L35) is not in mixedCase

../src/abstracts/BaseState.sol#L35

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-21
      Variable [BaseModule.\_moduleVersion](../src/abstracts/BaseModule.sol#L27) is too similar to [BaseModule.constructor(uint32,uint16).moduleVersion\_](../src/abstracts/BaseModule.sol#L52)

../src/abstracts/BaseModule.sol#L27

- [ ] ID-22
      Variable [BaseModule.\_moduleVersion](../src/abstracts/BaseModule.sol#L27) is too similar to [BaseInstaller.constructor(uint16).moduleVersion\_](../src/abstracts/BaseInstaller.sol#L23)

../src/abstracts/BaseModule.sol#L27

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-23
      [Proxy.fallback()](../src/internals/Proxy.sol#L33-L148) uses literals with too many digits: - [mstore(uint256,uint256)(0,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/internals/Proxy.sol#L111-L114)

../src/internals/Proxy.sol#L33-L148
