# Checklist

TODO: add deployment checklist

## Module deployment

### Adding modules

Prior to adding a module you have to deploy the module.
Make sure that the module inherits the latest version of the application `State`.

Ask oneself:

- Am I adding a new module or upgrading a module?
- Which module id am I going to use?
- Which module type am I going to use?
- Which module version am I going to use?
- Should the module be able to be upgraded?
- Is my storage compatible?

It is best practice to use `1` as your first module version for a new module.

In order to add one or more modules call `addModules()` on the `Installer`'s proxy.
If your module is of the type `single-proxy` the proxy will be created for you.

### Upgrading modules

Prior to upgrading a module you have to deploy the upgraded module.
Make sure that the module inherits the latest version of the application `State`.

Ask oneself:

- Am I adding a new module or upgrading a module?
- Which next module version am I going to use?
- Should the module be able to be upgraded?
- Is my storage compatible?

In order to upgrade one or more modules call `upgradeModules()` on the `Installer`'s proxy.
