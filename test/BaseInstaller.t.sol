// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

// Interfaces
import {TBaseInstaller} from "../src/interfaces/IBaseInstaller.sol";

// Fixtures
import {Fixture} from "./fixtures/Fixture.sol";

// Mocks
import {MockModule} from "./mocks/MockModule.sol";

/**
 * @title Base Installer Test
 */
contract BaseInstallerTest is TBaseInstaller, Fixture {
    // =========
    // Constants
    // =========

    uint32 internal constant _MODULE_ID_MOCK_MODULE = 100;
    uint16 internal constant _MODULE_ID_MOCK_MODULE_VERSION_V1 = 1;
    uint16 internal constant _MODULE_ID_MOCK_MODULE_VERSION_V2 = 2;

    // =======
    // Storage
    // =======

    MockModule public moduleV1;
    MockModule public moduleV2;

    // =====
    // Setup
    // =====

    function setUp() public virtual override {
        super.setUp();

        moduleV1 = new MockModule(
            _MODULE_ID_MOCK_MODULE,
            _MODULE_ID_MOCK_MODULE_VERSION_V1
        );

        moduleV2 = new MockModule(
            _MODULE_ID_MOCK_MODULE,
            _MODULE_ID_MOCK_MODULE_VERSION_V2
        );
    }

    // =====
    // Tests
    // =====

    function testTransferOwnership() public {
        installerProxy.transferOwnership(_ALICE);

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _ALICE);
    }

    function testAcceptOwnership() external {
        assertEq(installerProxy.pendingOwner(), address(0));

        installerProxy.transferOwnership(_ALICE);

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _ALICE);

        vm.startPrank(_ALICE);

        installerProxy.acceptOwnership();

        vm.stopPrank();

        assertEq(installerProxy.owner(), _ALICE);
        assertEq(installerProxy.pendingOwner(), address(0));
    }

    function testRevertTransferOwnershipNotPendingOwner() external {
        assertEq(installerProxy.pendingOwner(), address(0));

        installerProxy.transferOwnership(_ALICE);

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _ALICE);

        vm.startPrank(_BOB);

        vm.expectRevert(Unauthorized.selector);
        installerProxy.acceptOwnership();

        vm.stopPrank();

        assertEq(installerProxy.owner(), address(this));
        assertEq(installerProxy.pendingOwner(), _ALICE);
    }

    function testRevertTransferOwnershipZeroAddress() external {
        vm.expectRevert(ZeroAddress.selector);
        installerProxy.transferOwnership(address(0));
    }

    function testModuleId() external {
        assertEq(moduleV1.moduleId(), _MODULE_ID_MOCK_MODULE);
    }

    function testModuleVersion() external {
        assertEq(moduleV1.moduleVersion(), _MODULE_ID_MOCK_MODULE_VERSION_V1);
    }

    function testAddModules() public {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(moduleV1);

        vm.expectEmit(true, true, false, false);
        emit ModuleAdded(
            _MODULE_ID_MOCK_MODULE,
            address(moduleV1),
            _MODULE_ID_MOCK_MODULE_VERSION_V1
        );
        installerProxy.addModules(moduleAddresses);

        address moduleV1Implementation = reflex.moduleIdToImplementation(
            _MODULE_ID_MOCK_MODULE
        );
        address moduleProxy = reflex.moduleIdToProxy(_MODULE_ID_MOCK_MODULE);

        assertEq(moduleV1Implementation, address(moduleV1));
        assertTrue(moduleProxy != address(0));
        assertTrue(
            reflex.proxyAddressToTrust(moduleProxy).moduleId ==
                _MODULE_ID_MOCK_MODULE
        );
        assertTrue(
            reflex.proxyAddressToTrust(moduleProxy).moduleImplementation ==
                moduleV1Implementation
        );
    }

    function testAddModulesMultiProxy() external {
        address[] memory moduleAddresses = new address[](2);
        moduleAddresses[0] = address(
            new MockModule(_EXTERNAL_SINGLE_PROXY_DELIMITER + 1, 1)
        );
        moduleAddresses[1] = address(
            new MockModule(_EXTERNAL_SINGLE_PROXY_DELIMITER + 2, 1)
        );
        installerProxy.addModules(moduleAddresses);

        assertEq(
            reflex.moduleIdToProxy(_EXTERNAL_SINGLE_PROXY_DELIMITER + 1),
            reflex.moduleIdToProxy(_EXTERNAL_SINGLE_PROXY_DELIMITER + 2)
        );
        assertTrue(
            reflex.moduleIdToImplementation(
                _EXTERNAL_SINGLE_PROXY_DELIMITER + 1
            ) !=
                reflex.moduleIdToImplementation(
                    _EXTERNAL_SINGLE_PROXY_DELIMITER + 2
                )
        );
    }

    function testRevertAddNonContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(1);

        vm.expectRevert();
        installerProxy.addModules(moduleAddresses);
    }

    function testRevertNonModuleIdContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(reflex);

        vm.expectRevert();
        installerProxy.addModules(moduleAddresses);
    }

    function testUpgradeModules() external {
        testAddModules();

        address moduleV1Implementation = reflex.moduleIdToImplementation(
            _MODULE_ID_MOCK_MODULE
        );
        address moduleProxy = reflex.moduleIdToProxy(_MODULE_ID_MOCK_MODULE);

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(moduleV2);

        vm.expectEmit(true, true, false, false);
        emit ModuleUpgraded(
            _MODULE_ID_MOCK_MODULE,
            address(moduleV2),
            _MODULE_ID_MOCK_MODULE_VERSION_V1
        );
        installerProxy.upgradeModules(moduleAddresses);

        address moduleV2Implementation = reflex.moduleIdToImplementation(
            _MODULE_ID_MOCK_MODULE
        );

        assertEq(moduleProxy, reflex.moduleIdToProxy(_MODULE_ID_MOCK_MODULE));
        assertTrue(moduleV1Implementation != moduleV2Implementation);
        assertEq(moduleV2Implementation, address(moduleV2));
        assertTrue(
            reflex.proxyAddressToTrust(moduleProxy).moduleId ==
                _MODULE_ID_MOCK_MODULE
        );
        assertTrue(
            reflex.proxyAddressToTrust(moduleProxy).moduleImplementation ==
                moduleV2Implementation
        );
    }

    function testRevertUpgradeModulesModuleNonexistent() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(new MockModule(777, 2));

        vm.expectRevert(ModuleNonexistent.selector);
        installerProxy.upgradeModules(moduleAddresses);
    }

    function testRevertUpgradeModulesNonContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(1);

        vm.expectRevert();
        installerProxy.upgradeModules(moduleAddresses);
    }

    function testRevertUpgradeModulesNonModuleIdContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(reflex);

        vm.expectRevert();
        installerProxy.upgradeModules(moduleAddresses);
    }

    function testRemoveModules() external {
        testAddModules();

        address moduleProxy = reflex.moduleIdToProxy(_MODULE_ID_MOCK_MODULE);

        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(moduleV1);

        vm.expectEmit(true, true, false, false);
        emit ModuleRemoved(
            _MODULE_ID_MOCK_MODULE,
            address(moduleV1),
            _MODULE_ID_MOCK_MODULE_VERSION_V1
        );
        installerProxy.removeModules(moduleAddresses);

        assertEq(reflex.moduleIdToProxy(_MODULE_ID_MOCK_MODULE), address(0));
        assertEq(
            reflex.moduleIdToImplementation(_MODULE_ID_MOCK_MODULE),
            address(0)
        );
        assertEq(reflex.proxyAddressToTrust(moduleProxy).moduleId, uint32(0));
        assertEq(
            reflex.proxyAddressToTrust(moduleProxy).moduleImplementation,
            address(0)
        );
    }

    function testRevertRemoveModulesModuleNonexistent() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(new MockModule(777, 2));

        vm.expectRevert(ModuleNonexistent.selector);
        installerProxy.removeModules(moduleAddresses);
    }

    function testRevertRemoveModulesAddNonContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(1);

        vm.expectRevert();
        installerProxy.removeModules(moduleAddresses);
    }

    function testRevertRemoveModulesNonModuleIdContract() external {
        address[] memory moduleAddresses = new address[](1);
        moduleAddresses[0] = address(reflex);

        vm.expectRevert();
        installerProxy.removeModules(moduleAddresses);
    }
}
