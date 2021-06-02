{
  description = "Tom's systems configurations";

  inputs = {
    stable.url = "github:NixOS/nixpkgs/nixos-21.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    patched.url = "path:./nixpkgs";
    home-manager = {
      url = "github:rycee/home-manager/release-21.05";
      inputs.nixpkgs.follows = "stable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    neovim = {
      url = "path:./flakes/neovim";
      inputs.nixpkgs.follows = "stable";
    };
    awesome = {
      url = "path:./flakes/awesome";
      inputs.nixpkgs.follows = "stable";
    };
    thingshare = {
      url = "path:./flakes/thingshare";
      inputs.nixpkgs.follows = "stable";
    };
    phone-camera-upload = {
      url = "path:./flakes/phone-camera-upload";
      inputs.nixpkgs.follows = "stable";
    };
    musnix = {
      url = "github:musnix/musnix";
      flake = false;
    };
    renoise = {
      url = "/home/thomas/music-production/renoise";
      flake = false;
    };
    harrisonAva = {
      url = "/home/thomas/music-production/plugins/harrison-ava";
      flake = false;
    };
  };

  outputs = inputs @ { unstable, patched, nixos-hardware, neovim, awesome, ... }:
    let lib = inputs.stable.lib;
    in
    {
      nixosConfigurations = {
        castor =
          let
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs system;
              unstablePkgs = import unstable { inherit system; config = { allowUnfree = true; }; };
              patchedPkgs = import patched { inherit system; config = { allowUnfree = true; }; };
              neovimPkg = neovim.defaultPackage.${system};
              neovimPlugins = neovim.plugins.${system};
              awesomePlugins = awesome.plugins.${system};
            };
            modules = [
              {
                nixpkgs.overlays = [ ];
                nixpkgs.config.allowUnfree = true;
              }
              (import ./config/nixos/systems/castor)
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.users.thomas = import ./config/home/systems/castor/default.nix;
              }
              inputs.stable.nixosModules.notDetected
            ];
          in
          lib.nixosSystem {
            inherit system specialArgs modules;
          };
        argo =
          let
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs system;
              unstablePkgs = import unstable { inherit system; config = { allowUnfree = true; }; };
              patchedPkgs = import patched { inherit system; config = { allowUnfree = true; }; };
              neovimPkg = neovim.defaultPackage.${system};
              neovimPlugins = neovim.plugins.${system};
              awesomePlugins = awesome.plugins.${system};
            };
            modules = [
              {
                nixpkgs.overlays = [ ];
                nixpkgs.config.allowUnfree = true;
              }
              (import ./config/nixos/systems/argo)
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.users.thomas = import ./config/home/systems/argo/default.nix;
              }
              nixos-hardware.nixosModules.dell-xps-15-7590
              inputs.stable.nixosModules.notDetected
            ];
          in
          lib.nixosSystem {
            inherit system specialArgs modules;
          };
      };
    };
}
