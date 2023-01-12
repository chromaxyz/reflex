Summary

- [uninitialized-state](#uninitialized-state) (2 results) (High)
- [uninitialized-local](#uninitialized-local) (2 results) (Medium)
- [shadowing-local](#shadowing-local) (3 results) (Low)
- [calls-loop](#calls-loop) (5 results) (Low)
- [reentrancy-benign](#reentrancy-benign) (2 results) (Low)
- [assembly](#assembly) (6 results) (Informational)
- [costly-loop](#costly-loop) (3 results) (Informational)
- [low-level-calls](#low-level-calls) (2 results) (Informational)
- [naming-convention](#naming-convention) (13 results) (Informational)
- [similar-names](#similar-names) (2 results) (Informational)
- [too-many-digits](#too-many-digits) (1 results) (Informational)
- [unused-state](#unused-state) (8 results) (Informational)

## uninitialized-state

Impact: High
Confidence: High

- [ ] ID-0
      [BaseState.\_modules](../src/BaseState.sol#L53) is never initialized. It is used in: - [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L74-L80)

../src/BaseState.sol#L53

- [ ] ID-1
      [BaseState.\_owner](../src/BaseState.sol#L40) is never initialized. It is used in:

../src/BaseState.sol#L40

## uninitialized-local

Impact: Medium
Confidence: Medium

- [ ] ID-2
      [Proxy.implementation().response](../src/internals/Proxy.sol#L73) is a local variable never initialized

../src/internals/Proxy.sol#L73

- [ ] ID-3
      [Proxy.implementation().success](../src/internals/Proxy.sol#L72) is a local variable never initialized

../src/internals/Proxy.sol#L72

## shadowing-local

Impact: Low
Confidence: High

- [ ] ID-4
      [BaseInstaller.addModules(address[]).moduleSettings](../src/modules/BaseInstaller.sol#L98) shadows: - [BaseModule.moduleSettings()](../src/BaseModule.sol#L127-L136) (function) - [IBaseModule.moduleSettings()](../src/interfaces/IBaseModule.sol#L65) (function)

../src/modules/BaseInstaller.sol#L98

- [ ] ID-5
      [BaseInstaller.upgradeModules(address[]).moduleSettings](../src/modules/BaseInstaller.sol#L134) shadows: - [BaseModule.moduleSettings()](../src/BaseModule.sol#L127-L136) (function) - [IBaseModule.moduleSettings()](../src/interfaces/IBaseModule.sol#L65) (function)

../src/modules/BaseInstaller.sol#L134

- [ ] ID-6
      [BaseInstaller.removeModules(address[]).moduleSettings](../src/modules/BaseInstaller.sol#L177) shadows: - [BaseModule.moduleSettings()](../src/BaseModule.sol#L127-L136) (function) - [IBaseModule.moduleSettings()](../src/interfaces/IBaseModule.sol#L65) (function)

../src/modules/BaseInstaller.sol#L177

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-7
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L126-L160) has external calls inside a loop: [moduleSettings.moduleVersion <= IBaseModule(\_modules[moduleSettings.moduleId]).moduleVersion()](../src/modules/BaseInstaller.sol#L144)

../src/modules/BaseInstaller.sol#L126-L160

- [ ] ID-8
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L126-L160) has external calls inside a loop: [moduleSettings = BaseModule(moduleAddress).moduleSettings()](../src/modules/BaseInstaller.sol#L134)

../src/modules/BaseInstaller.sol#L126-L160

- [ ] ID-9
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L126-L160) has external calls inside a loop: [! IBaseModule(\_modules[moduleSettings.moduleId]).moduleUpgradeable()](../src/modules/BaseInstaller.sol#L140)

../src/modules/BaseInstaller.sol#L126-L160

- [ ] ID-10
      [BaseInstaller.addModules(address[])](../src/modules/BaseInstaller.sol#L92-L115) has external calls inside a loop: [moduleSettings = BaseModule(moduleAddress).moduleSettings()](../src/modules/BaseInstaller.sol#L98)

../src/modules/BaseInstaller.sol#L92-L115

- [ ] ID-11
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L171-L201) has external calls inside a loop: [moduleSettings = BaseModule(moduleAddress).moduleSettings()](../src/modules/BaseInstaller.sol#L177)

../src/modules/BaseInstaller.sol#L171-L201

## reentrancy-benign

Impact: Low
Confidence: Medium

- [ ] ID-12
      Reentrancy in [DeployScript.run()](../script/Deploy.s.sol#L65-L99):
      External calls: - [vm.startBroadcast()](../script/Deploy.s.sol#L66)
      State variables written after the call(s): - [dispatcher = new ImplementationDispatcher(msg.sender,address(installerImplementation))](../script/Deploy.s.sol#L78) - [exampleModuleImplementation = new ImplementationModule(IBaseModule.ModuleSettings(\_MODULE_ID_EXAMPLE,\_MODULE_TYPE_SINGLE_PROXY,\_MODULE_VERSION_EXAMPLE,\_MODULE_UPGRADEABLE_EXAMPLE,\_MODULE_REMOVEABLE_EXAMPLE))](../script/Deploy.s.sol#L82-L90) - [installerImplementation = new ImplementationInstaller(IBaseModule.ModuleSettings(\_MODULE_ID_INSTALLER,\_MODULE_TYPE_SINGLE_PROXY,\_MODULE_VERSION_INSTALLER,\_MODULE_UPGRADEABLE_INSTALLER,\_MODULE_REMOVEABLE_INSTALLER))](../script/Deploy.s.sol#L68-L76) - [installerProxy = ImplementationInstaller(dispatcher.moduleIdToProxy(\_MODULE_ID_INSTALLER))](../script/Deploy.s.sol#L80)

../script/Deploy.s.sol#L65-L99

- [ ] ID-13
      Reentrancy in [DeployScript.run()](../script/Deploy.s.sol#L65-L99):
      External calls: - [vm.startBroadcast()](../script/Deploy.s.sol#L66) - [installerProxy.addModules(moduleAddresses)](../script/Deploy.s.sol#L94) - [vm.stopBroadcast()](../script/Deploy.s.sol#L96)
      State variables written after the call(s): - [exampleModuleProxy = ImplementationModule(dispatcher.moduleIdToProxy(\_MODULE_ID_EXAMPLE))](../script/Deploy.s.sol#L98)

../script/Deploy.s.sol#L65-L99

## assembly

Impact: Informational
Confidence: High

- [ ] ID-14
      [Proxy.sentinel()](../src/internals/Proxy.sol#L96-L111) uses assembly - [INLINE ASM](../src/internals/Proxy.sol#L103-L106)

../src/internals/Proxy.sol#L96-L111

- [ ] ID-15
      [Base.\_unpackProxyAddress()](../src/internals/Base.sol#L97-L102) uses assembly - [INLINE ASM](../src/internals/Base.sol#L99-L101)

../src/internals/Base.sol#L97-L102

- [ ] ID-16
      [Proxy.\_fallback()](../src/internals/Proxy.sol#L120-L217) uses assembly - [INLINE ASM](../src/internals/Proxy.sol#L126-L171) - [INLINE ASM](../src/internals/Proxy.sol#L174-L215)

../src/internals/Proxy.sol#L120-L217

- [ ] ID-17
      [Base.\_revertBytes(bytes)](../src/internals/Base.sol#L108-L116) uses assembly - [INLINE ASM](../src/internals/Base.sol#L110-L112)

../src/internals/Base.sol#L108-L116

- [ ] ID-18
      [Base.\_unpackMessageSender()](../src/internals/Base.sol#L86-L91) uses assembly - [INLINE ASM](../src/internals/Base.sol#L88-L90)

../src/internals/Base.sol#L86-L91

- [ ] ID-19
      [BaseDispatcher.dispatch()](../src/BaseDispatcher.sol#L89-L137) uses assembly - [INLINE ASM](../src/BaseDispatcher.sol#L106-L136)

../src/BaseDispatcher.sol#L89-L137

## costly-loop

Impact: Informational
Confidence: Medium

- [ ] ID-20
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L171-L201) has costly operations inside a loop: - [delete \_modules[moduleSettings.moduleId]](../src/modules/BaseInstaller.sol#L193)

../src/modules/BaseInstaller.sol#L171-L201

- [ ] ID-21
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L171-L201) has costly operations inside a loop: - [delete \_trusts[proxyAddress]](../src/modules/BaseInstaller.sol#L185)

../src/modules/BaseInstaller.sol#L171-L201

- [ ] ID-22
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L171-L201) has costly operations inside a loop: - [delete \_proxies[moduleSettings.moduleId]](../src/modules/BaseInstaller.sol#L191)

../src/modules/BaseInstaller.sol#L171-L201

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-23
      Low level call in [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L74-L80): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/internals/Base.sol#L75)

../src/internals/Base.sol#L74-L80

- [ ] ID-24
      Low level call in [Proxy.implementation()](../src/internals/Proxy.sol#L71-L90): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_PROXY_TO_MODULE_IMPLEMENTATION_SELECTOR,address(this)))](../src/internals/Proxy.sol#L76-L78) - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_MODULE_ID_TO_MODULE_IMPLEMENTATION_SELECTOR,\_moduleId))](../src/internals/Proxy.sol#L80-L82)

../src/internals/Proxy.sol#L71-L90

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-25
      Variable [Proxy.\_moduleType](../src/internals/Proxy.sol#L41) is not in mixedCase

../src/internals/Proxy.sol#L41

- [ ] ID-26
      Variable [BaseState.\_trusts](../src/BaseState.sol#L67) is not in mixedCase

../src/BaseState.sol#L67

- [ ] ID-27
      Variable [BaseState.\_modules](../src/BaseState.sol#L53) is not in mixedCase

../src/BaseState.sol#L53

- [ ] ID-28
      Variable [BaseState.\_pendingOwner](../src/BaseState.sol#L46) is not in mixedCase

../src/BaseState.sol#L46

- [ ] ID-29
      Variable [Proxy.\_moduleId](../src/internals/Proxy.sol#L36) is not in mixedCase

../src/internals/Proxy.sol#L36

- [ ] ID-30
      Variable [BaseModule.\_moduleId](../src/BaseModule.sol#L22) is not in mixedCase

../src/BaseModule.sol#L22

- [ ] ID-31
      Variable [BaseState.\_proxies](../src/BaseState.sol#L60) is not in mixedCase

../src/BaseState.sol#L60

- [ ] ID-32
      Variable [BaseState.\_owner](../src/BaseState.sol#L40) is not in mixedCase

../src/BaseState.sol#L40

- [ ] ID-33
      Variable [BaseState.\_reentrancyLock](../src/BaseState.sol#L34) is not in mixedCase

../src/BaseState.sol#L34

- [ ] ID-34
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is not in mixedCase

../src/BaseModule.sol#L27

- [ ] ID-35
      Variable [BaseState.\_\_gap](../src/BaseState.sol#L76) is not in mixedCase

../src/BaseState.sol#L76

- [ ] ID-36
      Variable [Proxy.\_deployer](../src/internals/Proxy.sol#L46) is not in mixedCase

../src/internals/Proxy.sol#L46

- [ ] ID-37
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is not in mixedCase

../src/BaseModule.sol#L32

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-38
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [Base._createProxy(uint32,uint16).moduleType_](../src/internals/Base.sol#L49)

../src/BaseModule.sol#L27

- [ ] ID-39
      Variable [Proxy.\_moduleType](../src/internals/Proxy.sol#L41) is too similar to [Proxy.constructor(uint32,uint16).moduleType\_](../src/internals/Proxy.sol#L56)

../src/internals/Proxy.sol#L41

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-40
      [Proxy.\_fallback()](../src/internals/Proxy.sol#L120-L217) uses literals with too many digits: - [mstore(uint256,uint256)(0x00,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/internals/Proxy.sol#L178-L182)

../src/internals/Proxy.sol#L120-L217

## unused-state

Impact: Informational
Confidence: High

- [ ] ID-41
      [BaseConstants.\_REENTRANCY_LOCK_UNLOCKED](../src/BaseConstants.sol#L16) is never used in [DeployScript](../script/Deploy.s.sol#L41-L100)

../src/BaseConstants.sol#L16

- [ ] ID-42
      [BaseConstants.\_MODULE_TYPE_MULTI_PROXY](../src/BaseConstants.sol#L35) is never used in [DeployScript](../script/Deploy.s.sol#L41-L100)

../src/BaseConstants.sol#L35

- [ ] ID-43
      [BaseConstants.\_MODULE_ID_INSTALLER](../src/BaseConstants.sol#L49) is never used in [Proxy](../src/internals/Proxy.sol#L18-L229)

../src/BaseConstants.sol#L49

- [ ] ID-44
      [BaseConstants.\_REENTRANCY_LOCK_LOCKED](../src/BaseConstants.sol#L21) is never used in [DeployScript](../script/Deploy.s.sol#L41-L100)

../src/BaseConstants.sol#L21

- [ ] ID-45
      [BaseConstants.\_MODULE_TYPE_INTERNAL](../src/BaseConstants.sol#L40) is never used in [DeployScript](../script/Deploy.s.sol#L41-L100)

../src/BaseConstants.sol#L40

- [ ] ID-46
      [BaseConstants.\_MODULE_TYPE_INTERNAL](../src/BaseConstants.sol#L40) is never used in [Proxy](../src/internals/Proxy.sol#L18-L229)

../src/BaseConstants.sol#L40

- [ ] ID-47
      [BaseConstants.\_REENTRANCY_LOCK_LOCKED](../src/BaseConstants.sol#L21) is never used in [Proxy](../src/internals/Proxy.sol#L18-L229)

../src/BaseConstants.sol#L21

- [ ] ID-48
      [BaseConstants.\_REENTRANCY_LOCK_UNLOCKED](../src/BaseConstants.sol#L16) is never used in [Proxy](../src/internals/Proxy.sol#L18-L229)

../src/BaseConstants.sol#L16
