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
      [BaseState.\_owner](../src/BaseState.sol#L25) is never initialized. It is used in:

../src/BaseState.sol#L25

## locked-ether

Impact: Medium
Confidence: High

- [ ] ID-1
      Contract locking ether found:
      Contract [Proxy](../src/internals/Proxy.sol#L12-L151) has payable functions: - [Proxy.constructor()](../src/internals/Proxy.sol#L23-L25) - [Proxy.fallback()](../src/internals/Proxy.sol#L35-L150)
      But does not have a function to withdraw the ether

../src/internals/Proxy.sol#L12-L151

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-2
      [BaseInstaller.addModules(address[])](../src/modules/BaseInstaller.sol#L92-L113) has external calls inside a loop: [newModuleVersion = BaseModule(moduleAddress).moduleVersion()](../src/modules/BaseInstaller.sol#L98)

../src/modules/BaseInstaller.sol#L92-L113

- [ ] ID-3
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L123-L152) has external calls inside a loop: [existingModuleVersion = BaseModule(moduleAddress).moduleVersion()](../src/modules/BaseInstaller.sol#L129-L130)

../src/modules/BaseInstaller.sol#L123-L152

- [ ] ID-4
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L162-L194) has external calls inside a loop: [existingModuleVersion = BaseModule(moduleAddress).moduleVersion()](../src/modules/BaseInstaller.sol#L168-L169)

../src/modules/BaseInstaller.sol#L162-L194

- [ ] ID-5
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L162-L194) has external calls inside a loop: [existingModuleId = BaseModule(moduleAddress).moduleId()](../src/modules/BaseInstaller.sol#L167)

../src/modules/BaseInstaller.sol#L162-L194

- [ ] ID-6
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L123-L152) has external calls inside a loop: [existingModuleId = BaseModule(moduleAddress).moduleId()](../src/modules/BaseInstaller.sol#L128)

../src/modules/BaseInstaller.sol#L123-L152

- [ ] ID-7
      [BaseInstaller.addModules(address[])](../src/modules/BaseInstaller.sol#L92-L113) has external calls inside a loop: [newModuleId = BaseModule(moduleAddress).moduleId()](../src/modules/BaseInstaller.sol#L97)

../src/modules/BaseInstaller.sol#L92-L113

## assembly

Impact: Informational
Confidence: High

- [ ] ID-8
      [Base.\_unpackMessageSender()](../src/internals/Base.sol#L47-L57) uses assembly - [INLINE ASM](../src/internals/Base.sol#L54-L56)

../src/internals/Base.sol#L47-L57

- [ ] ID-9
      [Dispatcher.dispatch()](../src/Dispatcher.sol#L84-L134) uses assembly - [INLINE ASM](../src/Dispatcher.sol#L103-L133)

../src/Dispatcher.sol#L84-L134

- [ ] ID-10
      [Base.\_unpackParameters()](../src/internals/Base.sol#L62-L73) uses assembly - [INLINE ASM](../src/internals/Base.sol#L69-L72)

../src/internals/Base.sol#L62-L73

- [ ] ID-11
      [Proxy.fallback()](../src/internals/Proxy.sol#L35-L150) uses assembly - [INLINE ASM](../src/internals/Proxy.sol#L41-L104) - [INLINE ASM](../src/internals/Proxy.sol#L107-L148)

../src/internals/Proxy.sol#L35-L150

## costly-loop

Impact: Informational
Confidence: Medium

- [ ] ID-12
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L162-L194) has costly operations inside a loop: - [delete \_modules[existingModuleId]](../src/modules/BaseInstaller.sol#L182)

../src/modules/BaseInstaller.sol#L162-L194

- [ ] ID-13
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L162-L194) has costly operations inside a loop: - [delete \_trusts[proxyAddress]](../src/modules/BaseInstaller.sol#L176)

../src/modules/BaseInstaller.sol#L162-L194

- [ ] ID-14
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L162-L194) has costly operations inside a loop: - [delete \_proxies[existingModuleId]](../src/modules/BaseInstaller.sol#L180)

../src/modules/BaseInstaller.sol#L162-L194

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-15
      Variable [BaseState.\_trusts](../src/BaseState.sol#L41) is not in mixedCase

../src/BaseState.sol#L41

- [ ] ID-16
      Variable [BaseState.\_modules](../src/BaseState.sol#L33) is not in mixedCase

../src/BaseState.sol#L33

- [ ] ID-17
      Variable [BaseState.\_pendingOwner](../src/BaseState.sol#L29) is not in mixedCase

../src/BaseState.sol#L29

- [ ] ID-18
      Variable [BaseState.\_proxies](../src/BaseState.sol#L37) is not in mixedCase

../src/BaseState.sol#L37

- [ ] ID-19
      Variable [BaseState.\_owner](../src/BaseState.sol#L25) is not in mixedCase

../src/BaseState.sol#L25

- [ ] ID-20
      Variable [BaseState.\_name](../src/BaseState.sol#L21) is not in mixedCase

../src/BaseState.sol#L21

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-21
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L27) is too similar to [BaseModule.constructor(uint32,uint16).moduleVersion\_](../src/BaseModule.sol#L52)

../src/BaseModule.sol#L27

- [ ] ID-22
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L27) is too similar to [BaseInstaller.constructor(uint16).moduleVersion\_](../src/modules/BaseInstaller.sol#L23)

../src/BaseModule.sol#L27

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-23
      [Proxy.fallback()](../src/internals/Proxy.sol#L35-L150) uses literals with too many digits: - [mstore(uint256,uint256)(0,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/internals/Proxy.sol#L113-L116)

../src/internals/Proxy.sol#L35-L150
