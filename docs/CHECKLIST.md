# Checklist

## Adding modules

Prior to adding a module you have to deploy the module.
Make sure that the module inherits the latest version of the application `State`.
Make sure to not introduce any new storage variables inside of the module itself.

Ask oneself:

- Am I adding a new module or upgrading a module?
- Which module id am I going to use?
- Which module type am I going to use?
- Which module version am I going to use?
- Should the module be able to be upgraded?
- Should the module be able to be deprecated? If so, it must be upgradeable.
- Is my storage layout still compatible?

It is best practice to use `1` as your first module version for a new module.

In order to add one or more modules call `addModules()` on the `Installer`'s proxy.
If your module is of the type `single-proxy` the proxy will be created for you.

## Upgrading modules

Prior to upgrading a module you have to deploy the upgraded module.
Make sure that the module inherits the latest version of the application `State`.
Make sure to not introduce any new storage variables inside of the module itself.

Ask oneself:

- Am I adding a new module or upgrading a module?
- Which next module version am I going to use?
- Should the module be able to be upgraded?
- Should the module be able to be deprecated? If so, it must be upgradeable.
- Is my storage layout still compatible?

It is best practice to incremeby by `1` when updating the version for a new module.

In order to upgrade one or more modules call `upgradeModules()` on the `Installer`'s proxy.
