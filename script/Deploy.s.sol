// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {Script} from "forge-std/Script.sol";

// Interfaces
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Sources
import {ReflexConstants} from "../src/ReflexConstants.sol";

// Implementations
import {ImplementationDispatcher} from "../test/implementations/ImplementationDispatcher.sol";
import {ImplementationInstaller} from "../test/implementations/ImplementationInstaller.sol";
import {ImplementationModule} from "../test/implementations/ImplementationModule.sol";

/**
 * @title Deploy Constants
 */
abstract contract DeployConstants is ReflexConstants {
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
 * @title Deploy Script
 */
contract DeployScript is Script, DeployConstants {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_EXAMPLE = 2;
    uint32 internal constant _MODULE_VERSION_EXAMPLE = 1;
    bool internal constant _MODULE_UPGRADEABLE_EXAMPLE = true;
    bool internal constant _MODULE_REMOVEABLE_EXAMPLE = true;

    // =======
    // Storage
    // =======

    ImplementationInstaller public installerImplementation;
    ImplementationInstaller public installerProxy;
    ImplementationDispatcher public dispatcher;
    ImplementationModule public exampleModuleImplementation;
    ImplementationModule public exampleModuleProxy;

    // ===
    // Run
    // ===

    function run() external {
        vm.startBroadcast();

        installerImplementation = new ImplementationInstaller(
            IReflexModule.ModuleSettings({
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
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_EXAMPLE,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: _MODULE_VERSION_EXAMPLE,
                moduleUpgradeable: _MODULE_UPGRADEABLE_EXAMPLE,
                moduleRemoveable: _MODULE_REMOVEABLE_EXAMPLE
            })
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(exampleModuleImplementation);
        installerProxy.addModules(moduleAddresses);

        vm.stopBroadcast();

        exampleModuleProxy = ImplementationModule(dispatcher.moduleIdToProxy(_MODULE_ID_EXAMPLE));
    }
}
