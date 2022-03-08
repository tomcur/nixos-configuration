{
  description = "Tom's systems configurations";

  inputs = {
    stable.url = "github:NixOS/nixpkgs/nixos-21.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    patched.url = "git+file:///etc/nixos/nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "unstable";
    };
    home-manager = {
      # url = "github:rycee/home-manager/release-21.05";
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "unstable";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
    neovim = {
      # url = "path:./flakes/neovim";
      url = "path:/etc/nixos/flakes/neovim";
      inputs.nixpkgs.follows = "unstable";
      inputs.flake-utils.follows = "flake-utils";
    };
    awesome = {
      # url = "path:./flakes/awesome";
      url = "path:/etc/nixos/flakes/awesome";
      inputs.nixpkgs.follows = "unstable";
      inputs.flake-utils.follows = "flake-utils";
    };
    thingshare = {
      url = "git+file:///etc/nixos/flakes/thingshare";
      inputs.nixpkgs.follows = "unstable";
      inputs.flake-utils.follows = "flake-utils";
    };
    phone-camera-upload = {
      url = "git+file:///etc/nixos/flakes/phone-camera-upload";
      inputs.nixpkgs.follows = "unstable";
      inputs.flake-utils.follows = "flake-utils";
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

  outputs = inputs @ { self, stable, unstable, patched, nixos-hardware, agenix, neovim, awesome, ... }:
    let lib = unstable.lib;
    in
    {
      nixosConfigurations = {
        castor =
          let
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs system;
              stablePkgs = import stable { inherit system; config = { allowUnfree = true; }; };
              unstablePkgs = import unstable { inherit system; config = { allowUnfree = true; }; };
              patchedPkgs = import patched { inherit system; config = { allowUnfree = true; }; };
              neovimPkg = neovim.defaultPackage.${system};
              neovimPlugins = neovim.plugins.${system};
              awesomePkg = awesome.defaultPackage.${system};
              awesomePlugins = awesome.plugins.${system};
              deployrsPkgs = inputs.deploy-rs.packages.${system};
            };
            modules = [
              {
                nixpkgs.overlays = [
                  (self: super: {
                    notmuch = patched.legacyPackages."x86_64-linux".notmuch;
                  })
                ];
                nixpkgs.config.allowUnfree = true;
              }
              (import ./config/nixos/systems/castor)
              agenix.nixosModules.age
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.users.thomas = import ./config/home/systems/castor/default.nix;
              }
              unstable.nixosModules.notDetected
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
              stablePkgs = import stable { inherit system; config = { allowUnfree = true; }; };
              unstablePkgs = import unstable { inherit system; config = { allowUnfree = true; }; };
              patchedPkgs = import patched { inherit system; config = { allowUnfree = true; }; };
              neovimPkg = neovim.defaultPackage.${system};
              neovimPlugins = neovim.plugins.${system};
              awesomePkg = awesome.defaultPackage.${system};
              awesomePlugins = awesome.plugins.${system};
              deployrsPkgs = inputs.deploy-rs.${system}.packages;
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
              unstable.nixosModules.notDetected
            ];
          in
          lib.nixosSystem {
            inherit system specialArgs modules;
          };
        pollux =
          let
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs system;
              stablePkgs = import stable { inherit system; config = { allowUnfree = true; }; };
              unstablePkgs = import unstable { inherit system; config = { allowUnfree = true; }; };
              patchedPkgs = import patched { inherit system; config = { allowUnfree = true; }; };
              neovimPkg = neovim.defaultPackage.${system};
              neovimPlugins = neovim.plugins.${system};
              awesomePkg = awesome.defaultPackage.${system};
              awesomePlugins = awesome.plugins.${system};
              deployrsPkgs = inputs.deploy-rs.${system}.packages;
            };
            modules = [
              {
                nixpkgs.overlays = [ ];
                nixpkgs.config.allowUnfree = true;
              }
              (import ./config/nixos/systems/pollux)
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.users.thomas = import ./config/home/systems/pollux/default.nix;
              }
              nixos-hardware.nixosModules.dell-xps-13-9360
              unstable.nixosModules.notDetected
            ];
          in
          lib.nixosSystem {
            inherit system specialArgs modules;
          };
        router =
          let
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs system;
              stablePkgs = import stable { inherit system; config = { allowUnfree = true; }; };
              unstablePkgs = import unstable { inherit system; config = { allowUnfree = true; }; };
              patchedPkgs = import patched { inherit system; config = { allowUnfree = true; }; };
              deployrsPkgs = inputs.deploy-rs.${system}.packages;
            };
            modules = [
              {
                nixpkgs.overlays = [ ];
                nixpkgs.config.allowUnfree = true;
              }
              (import ./config/nixos/systems/router)
              # nixos-hardware.nixosModules.dell-xps-13-9360
              unstable.nixosModules.notDetected
            ];
          in
          lib.nixosSystem {
            inherit system specialArgs modules;
          };
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
      deploy.nodes = let deploy-rs = inputs.deploy-rs; in
        {
          router = {
            hostname = "10.0.0.1";
            profilesOrder = [ "system" ];
            profiles.system = {
              user = "root";
              sshUser = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.router;
            };
          };
        };
    };
}
