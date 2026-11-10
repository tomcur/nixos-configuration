{
  description = "Configuration for macOS";

  # Separate from the top-level flake, as that one has some inputs that only
  # exist on those NixOS machines.
  #
  # Activate this flake from this directory as follows:
  #
  # ```
  # nix run github:nix-community/home-manager -- switch --flake .#tomch
  # ```
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    stable.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hi-nvim-rs = {
      url = "github:tomcur/hi-nvim-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, stable, home-manager, ... }:
    let
      system = "aarch64-darwin";
      config = { allowUnfree = true; };
      pkgs = import nixpkgs { inherit system config; };
      stablePkgs = import stable { inherit system config; };
    in
    {
      homeConfigurations.tomch = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs system stablePkgs;
          unstablePkgs = pkgs;
          patchedPkgs = pkgs;
          neovimPkg = pkgs.neovim-unwrapped;
        };
        modules = [ ../../config/home/systems/mac ];
      };
    };
}
