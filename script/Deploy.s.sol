// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
import {Script} from "forge-std/Script.sol";

// Interfaces
import {IReflexModule} from "../src/interfaces/IReflexModule.sol";

// Sources
import {ReflexConstants} from "../src/ReflexConstants.sol";

// Mocks
import {MockImplementationDispatcher} from "../test/mocks/MockImplementationDispatcher.sol";
import {MockImplementationInstaller} from "../test/mocks/MockImplementationInstaller.sol";
import {MockImplementationModule} from "../test/mocks/MockImplementationModule.sol";

/**
 * @title Deploy Constants
 */
abstract contract DeployConstants is ReflexConstants {
    /**
     * @dev Module version of built-in upgradeable installer module.
     */
    uint32 internal constant _MODULE_VERSION_INSTALLER_V1 = 1;

    /**
     * @dev Next module version of built-in upgradeable installer module.
     */
    uint32 internal constant _MODULE_VERSION_INSTALLER_V2 = 2;

    /**
     * @dev Module upgradeability setting of built-in upgradeable installer module.
     */
    bool internal constant _MODULE_UPGRADEABLE_INSTALLER_V1 = true;

    /**
     * @dev Next module upgradeability setting of built-in upgradeable installer module.
     */
    bool internal constant _MODULE_UPGRADEABLE_INSTALLER_V2 = true;
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

    // =======
    // Storage
    // =======

    MockImplementationInstaller public installerImplementation;
    MockImplementationInstaller public installerEndpoint;

    MockImplementationDispatcher public dispatcher;

    MockImplementationModule public exampleModuleImplementation;
    MockImplementationModule public exampleModuleEndpoint;

    // ===
    // Run
    // ===

    function run() external {
        vm.startBroadcast();

        installerImplementation = new MockImplementationInstaller(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_ENDPOINT,
                moduleVersion: _MODULE_VERSION_INSTALLER_V1,
                moduleUpgradeable: _MODULE_UPGRADEABLE_INSTALLER_V1
            })
        );

        dispatcher = new MockImplementationDispatcher(msg.sender, address(installerImplementation));

        installerEndpoint = MockImplementationInstaller(dispatcher.moduleIdToEndpoint(_MODULE_ID_INSTALLER));

        exampleModuleImplementation = new MockImplementationModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_EXAMPLE,
                moduleType: _MODULE_TYPE_SINGLE_ENDPOINT,
                moduleVersion: _MODULE_VERSION_EXAMPLE,
                moduleUpgradeable: _MODULE_UPGRADEABLE_EXAMPLE
            })
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(exampleModuleImplementation);
        installerEndpoint.addModules(moduleAddresses);

        vm.stopBroadcast();

        exampleModuleEndpoint = MockImplementationModule(dispatcher.moduleIdToEndpoint(_MODULE_ID_EXAMPLE));
    }
}
