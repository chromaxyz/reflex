// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Vendor
import {console2} from "forge-std/console2.sol";
import {Script} from "forge-std/Script.sol";

// Sources
import {BaseConstants} from "../src/BaseConstants.sol";

// Implementations
import {ImplementationDispatcher} from "../test/implementations/ImplementationDispatcher.sol";
import {ImplementationInstaller} from "../test/implementations/ImplementationInstaller.sol";
import {ImplementationModule} from "../test/implementations/ImplementationModule.sol";

abstract contract DeployConstants is BaseConstants {
    uint32 internal constant _MODULE_ID_EXAMPLE = 2;
}

contract DeployScript is Script, DeployConstants {
    ImplementationInstaller public installerImplementation;
    ImplementationInstaller public installerProxy;
    ImplementationDispatcher public dispatcher;
    ImplementationModule public exampleModuleImplementation;
    ImplementationModule public exampleModuleProxy;

    function run() external {
        vm.startBroadcast();

        installerImplementation = new ImplementationInstaller(1);

        dispatcher = new ImplementationDispatcher(
            msg.sender,
            address(installerImplementation)
        );

        installerProxy = ImplementationInstaller(
            dispatcher.moduleIdToProxy(_MODULE_ID_INSTALLER)
        );

        exampleModuleImplementation = new ImplementationModule(
            _MODULE_ID_EXAMPLE,
            _MODULE_TYPE_SINGLE_PROXY,
            1
        );

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(exampleModuleImplementation);
        installerProxy.addModules(moduleAddresses);

        vm.stopBroadcast();

        exampleModuleProxy = ImplementationModule(
            dispatcher.moduleIdToProxy(_MODULE_ID_EXAMPLE)
        );

        console2.log(
            "Installer Implementation",
            address(installerImplementation)
        );
        console2.log("Dispatcher", address(dispatcher));
        console2.log(
            "Example Module Implementation",
            address(exampleModuleImplementation)
        );
        console2.log("Example Module Proxy", address(exampleModuleProxy));
    }
}
