Summary

- [uninitialized-state](#uninitialized-state) (2 results) (High)
- [shadowing-local](#shadowing-local) (3 results) (Low)
- [calls-loop](#calls-loop) (4 results) (Low)
- [reentrancy-benign](#reentrancy-benign) (2 results) (Low)
- [assembly](#assembly) (6 results) (Informational)
- [costly-loop](#costly-loop) (3 results) (Informational)
- [low-level-calls](#low-level-calls) (2 results) (Informational)
- [naming-convention](#naming-convention) (11 results) (Informational)
- [similar-names](#similar-names) (1 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)
- [unused-state](#unused-state) (4 results) (Informational)

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-0
      [BaseState.\_modules](../src/BaseState.sol#L52) is never initialized. It is used in: - [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L81-L92)

../src/BaseState.sol#L52

- [ ] ID-1
      [BaseState.\_owner](../src/BaseState.sol#L40) is never initialized. It is used in:

../src/BaseState.sol#L40

## shadowing-local

Impact: Low
Confidence: High

- [ ] ID-2
      [BaseInstaller.addModules(address[]).moduleSettings](../src/modules/BaseInstaller.sol#L99-L101) shadows: - [BaseModule.moduleSettings()](../src/BaseModule.sol#L129-L144) (function) - [IBaseModule.moduleSettings()](../src/interfaces/IBaseModule.sol#L70) (function)

../src/modules/BaseInstaller.sol#L99-L101

- [ ] ID-3
      [BaseInstaller.upgradeModules(address[]).moduleSettings](../src/modules/BaseInstaller.sol#L142-L144) shadows: - [BaseModule.moduleSettings()](../src/BaseModule.sol#L129-L144) (function) - [IBaseModule.moduleSettings()](../src/interfaces/IBaseModule.sol#L70) (function)

../src/modules/BaseInstaller.sol#L142-L144

- [ ] ID-4
      [BaseInstaller.removeModules(address[]).moduleSettings](../src/modules/BaseInstaller.sol#L193-L195) shadows: - [BaseModule.moduleSettings()](../src/BaseModule.sol#L129-L144) (function) - [IBaseModule.moduleSettings()](../src/interfaces/IBaseModule.sol#L70) (function)

../src/modules/BaseInstaller.sol#L193-L195

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-5
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L136-L177) has external calls inside a loop: [moduleSettings.moduleVersion <= BaseModule(\_modules[moduleSettings.moduleId]).moduleVersion()](../src/modules/BaseInstaller.sol#L153-L154)

../src/modules/BaseInstaller.sol#L136-L177

- [ ] ID-6
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L187-L228) has external calls inside a loop: [moduleSettings = BaseModule(moduleAddress).moduleSettings()](../src/modules/BaseInstaller.sol#L193-L195)

../src/modules/BaseInstaller.sol#L187-L228

- [ ] ID-7
      [BaseInstaller.addModules(address[])](../src/modules/BaseInstaller.sol#L93-L126) has external calls inside a loop: [moduleSettings = BaseModule(moduleAddress).moduleSettings()](../src/modules/BaseInstaller.sol#L99-L101)

../src/modules/BaseInstaller.sol#L93-L126

- [ ] ID-8
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L136-L177) has external calls inside a loop: [moduleSettings = BaseModule(moduleAddress).moduleSettings()](../src/modules/BaseInstaller.sol#L142-L144)

../src/modules/BaseInstaller.sol#L136-L177

## reentrancy-benign

Impact: Low
Confidence: Medium

- [ ] ID-9
      Reentrancy in [DeployScript.run()](../script/Deploy.s.sol#L32-L73):
      External calls: - [vm.startBroadcast()](../script/Deploy.s.sol#L33)
      State variables written after the call(s): - [dispatcher = new ImplementationDispatcher(msg.sender,address(installerImplementation))](../script/Deploy.s.sol#L45-L48) - [exampleModuleImplementation = new ImplementationModule(IBaseModule.ModuleSettings(\_MODULE_ID_EXAMPLE,\_MODULE_TYPE_SINGLE_PROXY,1,true,true))](../script/Deploy.s.sol#L54-L62) - [installerImplementation = new ImplementationInstaller(IBaseModule.ModuleSettings(\_MODULE_ID_INSTALLER,\_MODULE_TYPE_SINGLE_PROXY,1,true,false))](../script/Deploy.s.sol#L35-L43) - [installerProxy = ImplementationInstaller(dispatcher.moduleIdToProxy(\_MODULE_ID_INSTALLER))](../script/Deploy.s.sol#L50-L52)

../script/Deploy.s.sol#L32-L73

- [ ] ID-10
      Reentrancy in [DeployScript.run()](../script/Deploy.s.sol#L32-L73):
      External calls: - [vm.startBroadcast()](../script/Deploy.s.sol#L33) - [installerProxy.addModules(moduleAddresses)](../script/Deploy.s.sol#L66) - [vm.stopBroadcast()](../script/Deploy.s.sol#L68)
      State variables written after the call(s): - [exampleModuleProxy = ImplementationModule(dispatcher.moduleIdToProxy(\_MODULE_ID_EXAMPLE))](../script/Deploy.s.sol#L70-L72)

../script/Deploy.s.sol#L32-L73

## assembly

Impact: Informational
Confidence: High

- [ ] ID-11
      [Proxy.sentinel()](../src/internals/Proxy.sol#L71-L88) uses assembly - [INLINE ASM](../src/internals/Proxy.sol#L78-L81)

../src/internals/Proxy.sol#L71-L88

- [ ] ID-12
      [BaseDispatcher.dispatch()](../src/BaseDispatcher.sol#L117-L170) uses assembly - [INLINE ASM](../src/BaseDispatcher.sol#L139-L169)

../src/BaseDispatcher.sol#L117-L170

- [ ] ID-13
      [Base.\_unpackMessageSender()](../src/internals/Base.sol#L98-L108) uses assembly - [INLINE ASM](../src/internals/Base.sol#L105-L107)

../src/internals/Base.sol#L98-L108

- [ ] ID-14
      [Base.\_unpackProxyAddress()](../src/internals/Base.sol#L114-L124) uses assembly - [INLINE ASM](../src/internals/Base.sol#L121-L123)

../src/internals/Base.sol#L114-L124

- [ ] ID-15
      [Base.\_revertBytes(bytes)](../src/internals/Base.sol#L130-L138) uses assembly - [INLINE ASM](../src/internals/Base.sol#L132-L134)

../src/internals/Base.sol#L130-L138

- [ ] ID-16
      [Proxy.\_fallback()](../src/internals/Proxy.sol#L97-L212) uses assembly - [INLINE ASM](../src/internals/Proxy.sol#L103-L166) - [INLINE ASM](../src/internals/Proxy.sol#L169-L210)

../src/internals/Proxy.sol#L97-L212

## costly-loop

Impact: Informational
Confidence: Medium

- [ ] ID-17
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L187-L228) has costly operations inside a loop: - [delete \_trusts[proxyAddress]](../src/modules/BaseInstaller.sol#L208)

../src/modules/BaseInstaller.sol#L187-L228

- [ ] ID-18
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L187-L228) has costly operations inside a loop: - [delete \_proxies[moduleSettings.moduleId]](../src/modules/BaseInstaller.sol#L214)

../src/modules/BaseInstaller.sol#L187-L228

- [ ] ID-19
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L187-L228) has costly operations inside a loop: - [delete \_modules[moduleSettings.moduleId]](../src/modules/BaseInstaller.sol#L216)

../src/modules/BaseInstaller.sol#L187-L228

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-20
      Low level call in [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L81-L92): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/internals/Base.sol#L85-L87)

../src/internals/Base.sol#L81-L92

- [ ] ID-21
      Low level call in [Proxy.implementation()](../src/internals/Proxy.sol#L50-L65): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_PROXY_ADDRESS_TO_MODULE_IMPLEMENTATION_SELECTOR,address(this)))](../src/internals/Proxy.sol#L53-L58)

../src/internals/Proxy.sol#L50-L65

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-22
      Variable [BaseState.\_trusts](../src/BaseState.sol#L64) is not in mixedCase

../src/BaseState.sol#L64

- [ ] ID-23
      Variable [BaseState.\_modules](../src/BaseState.sol#L52) is not in mixedCase

../src/BaseState.sol#L52

- [ ] ID-24
      Variable [BaseState.\_pendingOwner](../src/BaseState.sol#L46) is not in mixedCase

../src/BaseState.sol#L46

- [ ] ID-25
      Variable [BaseModule.\_moduleId](../src/BaseModule.sol#L22) is not in mixedCase

../src/BaseModule.sol#L22

- [ ] ID-26
      Variable [BaseState.\_proxies](../src/BaseState.sol#L58) is not in mixedCase

../src/BaseState.sol#L58

- [ ] ID-27
      Variable [BaseState.\_owner](../src/BaseState.sol#L40) is not in mixedCase

../src/BaseState.sol#L40

- [ ] ID-28
      Variable [BaseState.\_reentrancyLock](../src/BaseState.sol#L34) is not in mixedCase

../src/BaseState.sol#L34

- [ ] ID-29
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is not in mixedCase

../src/BaseModule.sol#L27

- [ ] ID-30
      Variable [BaseState.\_\_gap](../src/BaseState.sol#L80) is not in mixedCase

../src/BaseState.sol#L80

- [ ] ID-31
      Variable [Proxy.\_deployer](../src/internals/Proxy.sol#L31) is not in mixedCase

../src/internals/Proxy.sol#L31

- [ ] ID-32
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is not in mixedCase

../src/BaseModule.sol#L32

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-33
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [Base._createProxy(uint32,uint16).moduleType_](../src/internals/Base.sol#L51)

../src/BaseModule.sol#L27

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-34
      [Proxy.\_fallback()](../src/internals/Proxy.sol#L97-L212) uses literals with too many digits: - [mstore(uint256,uint256)(0x00,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/internals/Proxy.sol#L173-L177)

../src/internals/Proxy.sol#L97-L212

## unused-state

Impact: Informational
Confidence: High

- [ ] ID-35
      [BaseConstants.\_REENTRANCY_LOCK_UNLOCKED](../src/BaseConstants.sol#L16) is never used in [DeployScript](../script/Deploy.s.sol#L25-L74)

../src/BaseConstants.sol#L16

- [ ] ID-36
      [BaseConstants.\_MODULE_TYPE_MULTI_PROXY](../src/BaseConstants.sol#L31) is never used in [DeployScript](../script/Deploy.s.sol#L25-L74)

../src/BaseConstants.sol#L31

- [ ] ID-37
      [BaseConstants.\_REENTRANCY_LOCK_LOCKED](../src/BaseConstants.sol#L21) is never used in [DeployScript](../script/Deploy.s.sol#L25-L74)

../src/BaseConstants.sol#L21

- [ ] ID-38
      [BaseConstants.\_MODULE_TYPE_INTERNAL](../src/BaseConstants.sol#L36) is never used in [DeployScript](../script/Deploy.s.sol#L25-L74)

../src/BaseConstants.sol#L36
