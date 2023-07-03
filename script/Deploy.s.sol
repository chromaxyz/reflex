// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

// Vendor
// solhint-disable-next-line no-console
import {console2} from "forge-std/console2.sol";
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
 * @title Deploy Script
 */
contract DeployScript is Script, ReflexConstants {
    /* solhint-disable no-console */

    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_VERSION_INSTALLER = 1;
    bool internal constant _MODULE_UPGRADEABLE_INSTALLER = true;

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
                moduleVersion: _MODULE_VERSION_INSTALLER,
                moduleUpgradeable: _MODULE_UPGRADEABLE_INSTALLER
            })
        );

        dispatcher = new MockImplementationDispatcher(msg.sender, address(installerImplementation));

        installerEndpoint = MockImplementationInstaller(dispatcher.getEndpoint(_MODULE_ID_INSTALLER));

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

        exampleModuleEndpoint = MockImplementationModule(dispatcher.getEndpoint(_MODULE_ID_EXAMPLE));

        console2.log("Installer implementation     :", address(installerImplementation));
        console2.log("Dispatcher                   :", address(dispatcher));
        console2.log("Installer endpoint           :", address(installerEndpoint));
        console2.log("Example module implementation:", address(exampleModuleImplementation));
        console2.log("Example module endpoint      :", address(exampleModuleEndpoint));

        /* solhint-enable no-console */
    }
}
