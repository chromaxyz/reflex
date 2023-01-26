// SPDX-License-Identifier: AGPL-3.0-only
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
    uint256 internal constant _MODULE_VERSION_INSTALLER = 1;

    /**
     * @dev Module upgradeability setting of built-in upgradeable installer module.
     */
    bool internal constant _MODULE_UPGRADEABLE_INSTALLER = true;
}

/**
 * @title Deploy Script
 */
contract DeployScript is Script, DeployConstants {
    // =========
    // Constants
    // =========

    uint256 internal constant _MODULE_ID_EXAMPLE = 2;
    uint256 internal constant _MODULE_VERSION_EXAMPLE = 1;
    bool internal constant _MODULE_UPGRADEABLE_EXAMPLE = true;

    // =======
    // Storage
    // =======

    MockImplementationInstaller public installerImplementation;
    MockImplementationInstaller public installerProxy;
    MockImplementationDispatcher public dispatcher;
    MockImplementationModule public exampleModuleImplementation;
    MockImplementationModule public exampleModuleProxy;

    // ===
    // Run
    // ===

    function run() external {
        vm.startBroadcast();

        installerImplementation = new MockImplementationInstaller(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: _MODULE_VERSION_INSTALLER,
                moduleUpgradeable: _MODULE_UPGRADEABLE_INSTALLER
            })
        );

        dispatcher = new MockImplementationDispatcher(msg.sender, address(installerImplementation));

        installerProxy = MockImplementationInstaller(dispatcher.moduleIdToProxy(_MODULE_ID_INSTALLER));

        exampleModuleImplementation = new MockImplementationModule(
            IReflexModule.ModuleSettings({
                moduleId: _MODULE_ID_EXAMPLE,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: _MODULE_VERSION_EXAMPLE,
                moduleUpgradeable: _MODULE_UPGRADEABLE_EXAMPLE
            })
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(exampleModuleImplementation);
        installerProxy.addModules(moduleAddresses);

        vm.stopBroadcast();

        exampleModuleProxy = MockImplementationModule(dispatcher.moduleIdToProxy(_MODULE_ID_EXAMPLE));
    }
}
