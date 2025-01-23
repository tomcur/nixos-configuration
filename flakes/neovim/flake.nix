{
  description = "A Neovim package and some Neovim plugins";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nvimMonochrome = {
      url = "github:fxn/vim-monochrome";
      flake = false;
    };
  };

  outputs = input @ { flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        plugins = with input; {
          inherit nvimMonochrome;
        };
      }
    );
}
