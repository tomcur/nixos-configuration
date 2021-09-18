{
  description = "AwesomeWM plugins";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    awesome = {
      url = "github:awesomeWM/awesome";
      flake = false;
    };
    sharedtags = {
      url = "github:Drauthius/awesome-sharedtags";
      flake = false;
    };
    lain = {
      url = "github:lcpz/lain";
      flake = false;
    };
    freedesktop = {
      url = "github:lcpz/awesome-freedesktop";
      flake = false;
    };
  };

  outputs = input @ { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        packages.awesome = pkgs.callPackage ./awesome.nix {
          awesomeSrc = input.awesome;
          cairo = pkgs.cairo.override { xcbSupport = true; };
          inherit (pkgs.texFunctions) fontsConf;
        };
        defaultPackage = packages.awesome;
        plugins = with input; {
          inherit sharedtags lain freedesktop;
        };
      }
    );
}
