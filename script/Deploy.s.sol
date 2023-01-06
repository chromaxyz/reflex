// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {Script} from "forge-std/Script.sol";

// Interfaces
import {IBaseModule} from "../src/interfaces/IBaseModule.sol";

// Sources
import {BaseConstants} from "../src/BaseConstants.sol";

// Implementations
import {ImplementationDispatcher} from "../test/implementations/ImplementationDispatcher.sol";
import {ImplementationInstaller} from "../test/implementations/ImplementationInstaller.sol";
import {ImplementationModule} from "../test/implementations/ImplementationModule.sol";

abstract contract DeployConstants is BaseConstants {
    uint32 internal constant _MODULE_ID_EXAMPLE = 2;
}

/**
 * @title Deploy Script
 */
contract DeployScript is Script, DeployConstants {
    ImplementationInstaller public installerImplementation;
    ImplementationInstaller public installerProxy;
    ImplementationDispatcher public dispatcher;
    ImplementationModule public exampleModuleImplementation;
    ImplementationModule public exampleModuleProxy;

    function run() external {
        vm.startBroadcast();

        installerImplementation = new ImplementationInstaller(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_ID_INSTALLER,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: 1,
                moduleUpgradeable: true,
                moduleRemoveable: false
            })
        );

        dispatcher = new ImplementationDispatcher(
            msg.sender,
            address(installerImplementation)
        );

        installerProxy = ImplementationInstaller(
            dispatcher.moduleIdToProxy(_MODULE_ID_INSTALLER)
        );

        exampleModuleImplementation = new ImplementationModule(
            IBaseModule.ModuleSettings({
                moduleId: _MODULE_ID_EXAMPLE,
                moduleType: _MODULE_TYPE_SINGLE_PROXY,
                moduleVersion: 1,
                moduleUpgradeable: true,
                moduleRemoveable: true
            })
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(exampleModuleImplementation);
        installerProxy.addModules(moduleAddresses);

        vm.stopBroadcast();

        exampleModuleProxy = ImplementationModule(
            dispatcher.moduleIdToProxy(_MODULE_ID_EXAMPLE)
        );
    }
}
