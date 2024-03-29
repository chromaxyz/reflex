# Checklist

To help one with safely adding, upgrading and deprecating modules we provide various scripts.

For verifying storage compatibility:

- [scripts/storage.sh](../scripts/storage.sh)
- [scripts/storage-check.sh](../scripts/storage-check.sh)
- [scripts/storage-generate.sh](../scripts/storage-generate.sh)

For highlighting external methods not marked as `nonReentrant()`:

- [scripts/reentrancy-check.sh](../scripts/reentrancy-check.sh)
- [scripts/reentrancy-generate.sh](../scripts/reentrancy-generate.sh)

Please note that this is not fool-proof and it is **REQUIRED** one writes their own integration, migration and compatibility tests.

## Adding modules

Prior to adding a module one has to deploy the module implementation.
Make sure that the module inherits the latest version of the application `State`.
Make sure to not introduce any new storage variables inside of the module itself.

Ask oneself:

- [ ] Am I adding a new module or upgrading a module?

Module id `1` is reserved for the `Installer`.

- [ ] Which module id am I going to use?

It is most common that you will use `single-endpoint` modules.

- [ ] Which module type am I going to use?

It is best practice to use `1` as your first module version for a new module.

- [ ] Which module version am I going to use?
- [ ] Should the module be able to be upgraded?
- [ ] Should the module be able to be deprecated? If so, it must be upgradeable.
- [ ] Is my storage layout still compatible?

In order to add one or more modules call `addModules()` on the `Installer`'s endpoint.
If your module is of the type `single-endpoint` the endpoint will be created for you.

## Upgrading modules

Prior to upgrading a module one has to deploy the upgraded module implementation.
Make sure that the module inherits the latest version of the application `State`.
Make sure to not introduce any new storage variables inside of the module itself.

Ask oneself:

- [ ] Am I adding a new module or upgrading a module?
- [ ] What is the module id of the current implementation?

To upgrade, the new module id must **ALWAYS** be the same as the current module id.

- [ ] What is the module type of the current implementation?

The new module type must **ALWAYS** be the same as the current module type.

- [ ] What is the module version of the current implementation?

The new module version must **ALWAYS** be greater than the current module version.
It is best practice to increment by `1` when updating the version for a new module.

- [ ] Which next module version am I going to use?
- [ ] Should the module be able to be upgraded?
- [ ] Should the module be able to be deprecated? If so, it must be upgradeable.
- [ ] Is my storage layout still compatible?

In order to upgrade one or more modules call `upgradeModules()` on the `Installer`'s endpoint.

## Deprecating modules

In order to deprecate a module one has to upgrade the module to a new version which removes some or all function logic.

Prior to deprecating a module one has to deploy the deprecated module implementation.
Make sure that the module inherits the latest version of the application `State`.
Make sure to not introduce any new storage variables inside of the module itself.

It is best practice to make deprecated modules **NON-UPGRADEABLE**.
The new module version must **ALWAYS** be greater than the current module version.

Ask oneself:

- [ ] Which next module version am I going to use?

The new module version must **ALWAYS** be greater than the current module version.
It is best practice to increment by `1` when updating the version for a new module.

- [ ] Have I marked the module as non-upgradeable?
- [ ] Is my storage layout still compatible?

In order to deprecate one or more modules call `upgradeModules()` on the `Installer`'s endpoint.
