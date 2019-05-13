# NixOS configuration
My NixOS system configurations.

Activate a specific system configuration by updating your `configuration.nix`, e.g. assuming this repository is in `./config` relative to the main configuration file:

```nix
{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./config/systems/castor.nix
    ];
}
```

Also see my [Nix user home configuration](https://github.com/beskhue/nix-home).

## Secrets
Some secrets in this repository are managed by git-crypt.
Unlocking the secrets requires access to the repository encryption key, e.g. through the GPG-encrpyted keyfiles stored in the repository.
To unlock the repository and reveal the secrets, do:

```shell
$ git-crypt unlock
```
