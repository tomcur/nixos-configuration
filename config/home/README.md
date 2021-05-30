# Nix home
My Nix home. Managed by [home-manager](https://github.com/rycee/home-manager).

This configuration assumes there are two sources of `nixpkgs`: 
* `<nixpkgs>` is assumed to be stable; and
* `<unstable>` is assumed to be unstable.

Achieve this through e.g. nix-channels by setting `nixos` to a stable channel and add the unstable channel as `unstable`.

The nixpkgs repository is added as a submodule in order to have direct access to the master of nixpkgs for packages that need to be able to be updated on short notice. 

## Example initialization

```shell
$ nix-channel --add https://nixos.org/channels/nixos-unstable unstable
$ git submodule --init
```
