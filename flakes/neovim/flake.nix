{
  description = "A Neovim package and some Neovim plugins";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nvimMonochrome = {
      url = "github:fxn/vim-monochrome";
      flake = false;
    };
    nvimVimColorsPencil = {
      url = "github:reedes/vim-colors-pencil";
      flake = false;
    };
    nvimPhoton = {
      url = "github:axvr/photon.vim";
      flake = false;
    };
  };

  outputs = input @ { flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        plugins = with input; {
          inherit nvimMonochrome nvimVimColorsPencil nvimPhoton;
        };
      }
    );
}
