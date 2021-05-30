{
  description = "AwesomeWM plugins";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
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

  outputs = input @ { flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: 
      rec {
        plugins = with input; {
          inherit sharedtags lain freedesktop;
        };
      }
    );
}
