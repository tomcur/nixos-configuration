# NixOS configuration
My NixOS system and user home configurations.

Activate a specific configuration by cloning this repository into `/etc/nixos` (such that `/etc/nixos/flake.nix` exists), perhaps changing `config/nixos/systems/*/hardware-configuration.nix`, and running e.g.:

```sh
$ nixos-rebuild switch --flake '/etc/nixos#castor'
```

## Secrets
Some secrets in this repository are managed by git-crypt.
Unlocking the secrets requires access to the repository encryption key, e.g. through the GPG-encrypted keyfiles stored in the repository.
To unlock the repository and reveal the secrets, do:

```shell
$ git-crypt unlock
```
