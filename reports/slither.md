Summary

- [uninitialized-state](#uninitialized-state) (2 results) (High)
- [shadowing-local](#shadowing-local) (3 results) (Low)
- [calls-loop](#calls-loop) (5 results) (Low)
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
      [BaseState.\_modules](../src/BaseState.sol#L52) is never initialized. It is used in: - [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L79-L90)

../src/BaseState.sol#L52

- [ ] ID-1
      [BaseState.\_owner](../src/BaseState.sol#L40) is never initialized. It is used in:

../src/BaseState.sol#L40

## shadowing-local

Impact: Low
Confidence: High

- [ ] ID-2
      [BaseInstaller.addModules(address[]).moduleSettings](../src/modules/BaseInstaller.sol#L99-L101) shadows: - [BaseModule.moduleSettings()](../src/BaseModule.sol#L129-L144) (function) - [IBaseModule.moduleSettings()](../src/interfaces/IBaseModule.sol#L71) (function)

../src/modules/BaseInstaller.sol#L99-L101

- [ ] ID-3
      [BaseInstaller.upgradeModules(address[]).moduleSettings](../src/modules/BaseInstaller.sol#L144-L146) shadows: - [BaseModule.moduleSettings()](../src/BaseModule.sol#L129-L144) (function) - [IBaseModule.moduleSettings()](../src/interfaces/IBaseModule.sol#L71) (function)

../src/modules/BaseInstaller.sol#L144-L146

- [ ] ID-4
      [BaseInstaller.removeModules(address[]).moduleSettings](../src/modules/BaseInstaller.sol#L200-L202) shadows: - [BaseModule.moduleSettings()](../src/BaseModule.sol#L129-L144) (function) - [IBaseModule.moduleSettings()](../src/interfaces/IBaseModule.sol#L71) (function)

../src/modules/BaseInstaller.sol#L200-L202

## calls-loop

Impact: Low
Confidence: Medium

- [ ] ID-5
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L136-L184) has external calls inside a loop: [! IBaseModule(\_modules[moduleSettings.moduleId]).moduleUpgradeable()](../src/modules/BaseInstaller.sol#L154-L155)

../src/modules/BaseInstaller.sol#L136-L184

- [ ] ID-6
      [BaseInstaller.addModules(address[])](../src/modules/BaseInstaller.sol#L93-L126) has external calls inside a loop: [moduleSettings = BaseModule(moduleAddress).moduleSettings()](../src/modules/BaseInstaller.sol#L99-L101)

../src/modules/BaseInstaller.sol#L93-L126

- [ ] ID-7
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L136-L184) has external calls inside a loop: [moduleSettings.moduleVersion <= IBaseModule(\_modules[moduleSettings.moduleId]).moduleVersion()](../src/modules/BaseInstaller.sol#L160-L161)

../src/modules/BaseInstaller.sol#L136-L184

- [ ] ID-8
      [BaseInstaller.upgradeModules(address[])](../src/modules/BaseInstaller.sol#L136-L184) has external calls inside a loop: [moduleSettings = BaseModule(moduleAddress).moduleSettings()](../src/modules/BaseInstaller.sol#L144-L146)

../src/modules/BaseInstaller.sol#L136-L184

- [ ] ID-9
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L194-L235) has external calls inside a loop: [moduleSettings = BaseModule(moduleAddress).moduleSettings()](../src/modules/BaseInstaller.sol#L200-L202)

../src/modules/BaseInstaller.sol#L194-L235

## reentrancy-benign

Impact: Low
Confidence: Medium

- [ ] ID-10
      Reentrancy in [DeployScript.run()](../script/Deploy.s.sol#L45-L86):
      External calls: - [vm.startBroadcast()](../script/Deploy.s.sol#L46)
      State variables written after the call(s): - [dispatcher = new ImplementationDispatcher(msg.sender,address(installerImplementation))](../script/Deploy.s.sol#L58-L61) - [exampleModuleImplementation = new ImplementationModule(IBaseModule.ModuleSettings(\_MODULE_ID_EXAMPLE,\_MODULE_TYPE_SINGLE_PROXY,\_MODULE_VERSION_EXAMPLE,\_MODULE_UPGRADEABLE_EXAMPLE,\_MODULE_REMOVEABLE_EXAMPLE))](../script/Deploy.s.sol#L67-L75) - [installerImplementation = new ImplementationInstaller(IBaseModule.ModuleSettings(\_MODULE_ID_INSTALLER,\_MODULE_TYPE_SINGLE_PROXY,\_MODULE_VERSION_INSTALLER,\_MODULE_UPGRADEABLE_INSTALLER,\_MODULE_REMOVEABLE_INSTALLER))](../script/Deploy.s.sol#L48-L56) - [installerProxy = ImplementationInstaller(dispatcher.moduleIdToProxy(\_MODULE_ID_INSTALLER))](../script/Deploy.s.sol#L63-L65)

../script/Deploy.s.sol#L45-L86

- [ ] ID-11
      Reentrancy in [DeployScript.run()](../script/Deploy.s.sol#L45-L86):
      External calls: - [vm.startBroadcast()](../script/Deploy.s.sol#L46) - [installerProxy.addModules(moduleAddresses)](../script/Deploy.s.sol#L79) - [vm.stopBroadcast()](../script/Deploy.s.sol#L81)
      State variables written after the call(s): - [exampleModuleProxy = ImplementationModule(dispatcher.moduleIdToProxy(\_MODULE_ID_EXAMPLE))](../script/Deploy.s.sol#L83-L85)

../script/Deploy.s.sol#L45-L86

## assembly

Impact: Informational
Confidence: High

- [ ] ID-12
      [Proxy.\_fallback()](../src/internals/Proxy.sol#L95-L210) uses assembly - [INLINE ASM](../src/internals/Proxy.sol#L101-L164) - [INLINE ASM](../src/internals/Proxy.sol#L167-L208)

../src/internals/Proxy.sol#L95-L210

- [ ] ID-13
      [Proxy.sentinel()](../src/internals/Proxy.sol#L71-L86) uses assembly - [INLINE ASM](../src/internals/Proxy.sol#L78-L81)

../src/internals/Proxy.sol#L71-L86

- [ ] ID-14
      [Base.\_unpackProxyAddress()](../src/internals/Base.sol#L112-L122) uses assembly - [INLINE ASM](../src/internals/Base.sol#L119-L121)

../src/internals/Base.sol#L112-L122

- [ ] ID-15
      [Base.\_unpackMessageSender()](../src/internals/Base.sol#L96-L106) uses assembly - [INLINE ASM](../src/internals/Base.sol#L103-L105)

../src/internals/Base.sol#L96-L106

- [ ] ID-16
      [Base.\_revertBytes(bytes)](../src/internals/Base.sol#L128-L136) uses assembly - [INLINE ASM](../src/internals/Base.sol#L130-L132)

../src/internals/Base.sol#L128-L136

- [ ] ID-17
      [BaseDispatcher.dispatch()](../src/BaseDispatcher.sol#L117-L169) uses assembly - [INLINE ASM](../src/BaseDispatcher.sol#L138-L168)

../src/BaseDispatcher.sol#L117-L169

## costly-loop

Impact: Informational
Confidence: Medium

- [ ] ID-18
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L194-L235) has costly operations inside a loop: - [delete \_proxies[moduleSettings.moduleId]](../src/modules/BaseInstaller.sol#L221)

../src/modules/BaseInstaller.sol#L194-L235

- [ ] ID-19
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L194-L235) has costly operations inside a loop: - [delete \_modules[moduleSettings.moduleId]](../src/modules/BaseInstaller.sol#L223)

../src/modules/BaseInstaller.sol#L194-L235

- [ ] ID-20
      [BaseInstaller.removeModules(address[])](../src/modules/BaseInstaller.sol#L194-L235) has costly operations inside a loop: - [delete \_trusts[proxyAddress]](../src/modules/BaseInstaller.sol#L215)

../src/modules/BaseInstaller.sol#L194-L235

## low-level-calls

Impact: Informational
Confidence: High

- [ ] ID-21
      Low level call in [Base.\_callInternalModule(uint32,bytes)](../src/internals/Base.sol#L79-L90): - [(success,result) = _modules[moduleId_].delegatecall(input\_)](../src/internals/Base.sol#L83-L85)

../src/internals/Base.sol#L79-L90

- [ ] ID-22
      Low level call in [Proxy.implementation()](../src/internals/Proxy.sol#L50-L65): - [(success,response) = \_deployer.staticcall(abi.encodeWithSelector(\_PROXY_ADDRESS_TO_MODULE_IMPLEMENTATION_SELECTOR,address(this)))](../src/internals/Proxy.sol#L53-L58)

../src/internals/Proxy.sol#L50-L65

## naming-convention

Impact: Informational
Confidence: High

- [ ] ID-23
      Variable [BaseState.\_trusts](../src/BaseState.sol#L64) is not in mixedCase

../src/BaseState.sol#L64

- [ ] ID-24
      Variable [BaseState.\_modules](../src/BaseState.sol#L52) is not in mixedCase

../src/BaseState.sol#L52

- [ ] ID-25
      Variable [BaseState.\_pendingOwner](../src/BaseState.sol#L46) is not in mixedCase

../src/BaseState.sol#L46

- [ ] ID-26
      Variable [BaseModule.\_moduleId](../src/BaseModule.sol#L22) is not in mixedCase

../src/BaseModule.sol#L22

- [ ] ID-27
      Variable [BaseState.\_proxies](../src/BaseState.sol#L58) is not in mixedCase

../src/BaseState.sol#L58

- [ ] ID-28
      Variable [BaseState.\_owner](../src/BaseState.sol#L40) is not in mixedCase

../src/BaseState.sol#L40

- [ ] ID-29
      Variable [BaseState.\_reentrancyLock](../src/BaseState.sol#L34) is not in mixedCase

../src/BaseState.sol#L34

- [ ] ID-30
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is not in mixedCase

../src/BaseModule.sol#L27

- [ ] ID-31
      Variable [BaseState.\_\_gap](../src/BaseState.sol#L73) is not in mixedCase

../src/BaseState.sol#L73

- [ ] ID-32
      Variable [Proxy.\_deployer](../src/internals/Proxy.sol#L31) is not in mixedCase

../src/internals/Proxy.sol#L31

- [ ] ID-33
      Variable [BaseModule.\_moduleVersion](../src/BaseModule.sol#L32) is not in mixedCase

../src/BaseModule.sol#L32

## similar-names

Impact: Informational
Confidence: Medium

- [ ] ID-34
      Variable [BaseModule.\_moduleType](../src/BaseModule.sol#L27) is too similar to [Base._createProxy(uint32,uint16).moduleType_](../src/internals/Base.sol#L51)

../src/BaseModule.sol#L27

## too-many-digits

Impact: Informational
Confidence: Medium

- [ ] ID-35
      [Proxy.\_fallback()](../src/internals/Proxy.sol#L95-L210) uses literals with too many digits: - [mstore(uint256,uint256)(0x00,0xe9c4a3ac00000000000000000000000000000000000000000000000000000000)](../src/internals/Proxy.sol#L171-L175)

../src/internals/Proxy.sol#L95-L210

## unused-state

Impact: Informational
Confidence: High

- [ ] ID-36
      [BaseConstants.\_REENTRANCY_LOCK_UNLOCKED](../src/BaseConstants.sol#L16) is never used in [DeployScript](../script/Deploy.s.sol#L21-L87)

../src/BaseConstants.sol#L16

- [ ] ID-37
      [BaseConstants.\_MODULE_TYPE_MULTI_PROXY](../src/BaseConstants.sol#L35) is never used in [DeployScript](../script/Deploy.s.sol#L21-L87)

../src/BaseConstants.sol#L35

- [ ] ID-38
      [BaseConstants.\_REENTRANCY_LOCK_LOCKED](../src/BaseConstants.sol#L21) is never used in [DeployScript](../script/Deploy.s.sol#L21-L87)

../src/BaseConstants.sol#L21

- [ ] ID-39
      [BaseConstants.\_MODULE_TYPE_INTERNAL](../src/BaseConstants.sol#L40) is never used in [DeployScript](../script/Deploy.s.sol#L21-L87)

../src/BaseConstants.sol#L40
