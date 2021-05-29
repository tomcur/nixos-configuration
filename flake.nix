{
  description = "Tom's systems configurations";

  inputs = {
    stable.url = "github:NixOS/nixpkgs/release-21.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    musnix.url = "github:musnix/musnix";
    musnix.flake = false;
  };

  outputs = inputs:
    let lib = inputs.stable.lib;
    in
    {
      nixosConfigurations = {
        castor = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs.overlays = [ ];
            }
            (import ./config/nixos/systems/castor)
            # (import ./config/home/systems/castor.nix)
            # inputs.home-manager.nixosModules.home-manager
            inputs.stable.nixosModules.notDetected
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
