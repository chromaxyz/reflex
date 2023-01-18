// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

// Interfaces
import {IBaseModule} from "../src/interfaces/IBaseModule.sol";

// Sources
import {BaseConstants} from "../src/BaseConstants.sol";

// Implementations
import {ImplementationDispatcher} from "../test/implementations/ImplementationDispatcher.sol";
import {ImplementationInstaller} from "../test/implementations/ImplementationInstaller.sol";
import {ImplementationModule} from "../test/implementations/ImplementationModule.sol";
import {ImplementationMaliciousModule} from "../test/implementations/ImplementationMaliciousModule.sol";

/**
 * @title Deploy Constants
 */
abstract contract DeployConstants is BaseConstants {
    /**
     * @dev Module version of built-in upgradeable installer module.
     */
    uint32 internal constant _MODULE_VERSION_INSTALLER = 1;

    /**
     * @dev Module upgradeability setting of built-in upgradeable installer module.
     */
    bool internal constant _MODULE_UPGRADEABLE_INSTALLER = true;

    /**
     * @dev Module removeability setting of built-in upgradeable installer module.
     */
    bool internal constant _MODULE_REMOVEABLE_INSTALLER = false;
}

/**
 * @title Integration Test
 */
contract IntegrationTest is Script, Test, DeployConstants {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_EXAMPLE = 2;
    uint32 internal constant _MODULE_VERSION_EXAMPLE = 1;
    bool internal constant _MODULE_UPGRADEABLE_EXAMPLE = true;
    bool internal constant _MODULE_REMOVEABLE_EXAMPLE = true;

    uint32 internal constant _MODULE_ID_MALICIOUS = 3;
    uint32 internal constant _MODULE_VERSION_MALICIOUS = 1;
    bool internal constant _MODULE_UPGRADEABLE_MALICIOUS = true;
    bool internal constant _MODULE_REMOVEABLE_MALICIOUS = true;

    // =======
    // Storage
    // =======

    ImplementationInstaller public installerImplementation;
    ImplementationInstaller public installerProxy;
    ImplementationDispatcher public dispatcher;
    ImplementationModule public exampleModuleImplementation;
    ImplementationModule public exampleModuleProxy;
    ImplementationMaliciousModule public maliciousModuleImplementation;
    ImplementationMaliciousModule public maliciousModuleProxy;

    // ===
    // Run
    // ===

    function run() external {
        _prepareTest();

        console2.log(address(exampleModuleProxy));
        console2.log(address(maliciousModuleProxy));

        vm.startBroadcast();

        maliciousModuleProxy.setImplementationState1(777);

        vm.stopBroadcast();

        assertEq(maliciousModuleProxy.getImplementationState1(), 777);

        vm.startBroadcast();

        maliciousModuleProxy.destroy();

        vm.stopBroadcast();

        assertEq(maliciousModuleProxy.getImplementationState1(), 777);

        console2.log(maliciousModuleProxy.getImplementationState1());
    }

    // ================
    // Internal methods
    // ================

    function _prepareTest() internal {
        vm.startBroadcast();

        installerImplementation = new ImplementationInstaller(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: _MODULE_VERSION_INSTALLER,
                moduleUpgradeable: _MODULE_UPGRADEABLE_INSTALLER,
                moduleRemoveable: _MODULE_REMOVEABLE_INSTALLER
            })
        );

        dispatcher = new ImplementationDispatcher(msg.sender, address(installerImplementation));

        installerProxy = ImplementationInstaller(dispatcher.moduleIdToProxy(_MODULE_ID_INSTALLER));

        exampleModuleImplementation = new ImplementationModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_ID_EXAMPLE,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: _MODULE_VERSION_EXAMPLE,
                moduleUpgradeable: _MODULE_UPGRADEABLE_EXAMPLE,
                moduleRemoveable: _MODULE_REMOVEABLE_EXAMPLE
            })
        );

        maliciousModuleImplementation = new ImplementationMaliciousModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_ID_MALICIOUS,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: _MODULE_VERSION_MALICIOUS,
                moduleUpgradeable: _MODULE_UPGRADEABLE_MALICIOUS,
                moduleRemoveable: _MODULE_REMOVEABLE_MALICIOUS
            })
        );

        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(exampleModuleImplementation);
        moduleAddresses[1] = address(maliciousModuleImplementation);
        installerProxy.addModules(moduleAddresses);

        vm.stopBroadcast();

        exampleModuleProxy = ImplementationModule(dispatcher.moduleIdToProxy(_MODULE_ID_EXAMPLE));
        maliciousModuleProxy = ImplementationMaliciousModule(dispatcher.moduleIdToProxy(_MODULE_ID_MALICIOUS));
    }

    function _verifyStorageLayout() internal {}
}
