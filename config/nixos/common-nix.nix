{ inputs, pkgs, ... }:
{
  environment.etc."nix-channels/stable".source = inputs.stable;
  environment.etc."nix-channels/unstable".source = inputs.unstable;

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    registry = {
      # nixpkgs.flake = inputs.unstable;
      stable.flake = inputs.stable;
      unstable.flake = inputs.unstable;
    };
    nixPath = [
      "nixpkgs=/etc/nix-channels/unstable"
      "stable=/etc/nix-channels/stable"
      "unstable=/etc/nix-channels/unstable"
    ];
  };
}
