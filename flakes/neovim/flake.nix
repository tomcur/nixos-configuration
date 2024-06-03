{
  description = "A Neovim package and some Neovim plugins";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nvimPlenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    nvimPopup = {
      url = "github:nvim-lua/popup.nvim";
      flake = false;
    };
    nvimTelescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
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
    nvimCompletionNvim = {
      url = "github:nvim-lua/completion-nvim";
      flake = false;
    };
    nvimColorizerLua = {
      url = "github:norcalli/nvim-colorizer.lua";
      flake = false;
    };
    nvimMinimapVim = {
      url = "github:wfxr/minimap.vim";
      flake = false;
    };
    nvimRegistersNvim = {
      url = "github:tversteeg/registers.nvim";
      flake = false;
    };
    nvimTroubleNvim = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };
    nvimGitsignsNvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    nvimLeapNvim = {
      url = "github:ggandor/leap.nvim";
      flake = false;
    };
  };

  outputs = input @ { flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        plugins = with input; {
          inherit nvimPlenary nvimPopup nvimTelescope
            nvimMonochrome nvimVimColorsPencil nvimPhoton nvimColorizerLua nvimMinimapVim nvimRegistersNvim
            nvimCompletionNvim nvimTroubleNvim nvimGitsignsNvim nvimLeapNvim;
        };
      }
    );
}
