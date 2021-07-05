{ buildVimPluginFrom2Nix, neovimPlugins }:
{
  popup = buildVimPluginFrom2Nix rec {
    pname = "popup";
    version = neovimPlugins.nvimPopup.lastModifiedDate;
    src = neovimPlugins.nvimPopup;
    meta.homepage = "https://github.com/nvim-lua/popup.nvim";
  };
  plenary = buildVimPluginFrom2Nix rec {
    pname = "plenary";
    version = neovimPlugins.nvimPlenary.lastModifiedDate;
    src = neovimPlugins.nvimPlenary;
    meta.homepage = "https://github.com/nvim-lua/plenary.nvim";
  };
  lsp-extensions = buildVimPluginFrom2Nix rec {
    pname = "lsp-extensions";
    version = neovimPlugins.nvimLspExtensions.lastModifiedDate;
    src = neovimPlugins.nvimLspExtensions;
    meta.homepage = "https://github.com/nvim-lua/lsp_extensions.nvim";
  };
  telescope = buildVimPluginFrom2Nix rec {
    pname = "telescope";
    version = neovimPlugins.nvimTelescope.lastModifiedDate;
    src = neovimPlugins.nvimTelescope;
    meta.homepage = "https://github.com/nvim-lua/telescope.nvim";
  };
  nvim-treesitter = buildVimPluginFrom2Nix rec {
    pname = "nvim-treesitter";
    version = neovimPlugins.nvimTreesitter.lastModifiedDate;
    src = neovimPlugins.nvimTreesitter;
    meta.homepage = "https://github.com/nvim-treesitter/nvim-treesitter/";
  };
  nvim-treesitter-textobjects = buildVimPluginFrom2Nix rec {
    pname = "nvim-treesitter-textobjects";
    version = neovimPlugins.nvimTreesitterTextobjects.lastModifiedDate;
    src = neovimPlugins.nvimTreesitterTextobjects;
    meta.homepage = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects/";
  };
  vim-monochrome = buildVimPluginFrom2Nix rec {
    pname = "vim-monochrome";
    version = neovimPlugins.nvimMonochrome.lastModifiedDate;
    src = neovimPlugins.nvimMonochrome;
    meta.homepage = "https://github.com/fxn/vim-monochrome";
  };
  vim-colors-pencil = buildVimPluginFrom2Nix rec {
    pname = "vim-colors-pencil";
    version = neovimPlugins.nvimVimColorsPencil.lastModifiedDate;
    src = neovimPlugins.nvimVimColorsPencil;
    meta.homepage = "https://github.com/reedes/vim-colors-pencil";
  };
  vim-photon = buildVimPluginFrom2Nix rec {
    pname = "photon.vim";
    version = neovimPlugins.nvimPhoton.lastModifiedDate;
    src = neovimPlugins.nvimPhoton;
    meta.homepage = "https://github.com/axvr/photon.vim";
  };
  completion-nvim = buildVimPluginFrom2Nix rec {
    pname = "completion-nvim";
    version = neovimPlugins.nvimCompletionNvim.lastModifiedDate;
    src = neovimPlugins.nvimCompletionNvim;
    meta.homepage = "https://github.com/nvim-lua/completion-nvim";
  };
  vim-loclist-follow = buildVimPluginFrom2Nix rec {
    pname = "vim-loclist-follow";
    version = neovimPlugins.nvimVimLoclistFollow.lastModifiedDate;
    src = neovimPlugins.nvimVimLoclistFollow;
    meta.homepage = "https://github.com/elbeardmorez/vim-loclist-follow";
  };
  nvim-colorizer-lua = buildVimPluginFrom2Nix rec {
    pname = "colorizer.lua";
    version = neovimPlugins.nvimColorizerLua.lastModifiedDate;
    src = neovimPlugins.nvimColorizerLua;
    meta.homepage = "https://github.com/norcalli/nvim-colorizer.lua";
  };
  minimap-vim = buildVimPluginFrom2Nix rec {
    pname = "minimap.vim";
    version = neovimPlugins.nvimMinimapVim.lastModifiedDate;
    src = neovimPlugins.nvimMinimapVim;
    meta.homepage = "https://github.com/wfxr/minimap.vim";
  };
  registers-nvim = buildVimPluginFrom2Nix rec {
    pname = "registers.nvim";
    version = neovimPlugins.nvimRegistersNvim.lastModifiedDate;
    src = neovimPlugins.nvimRegistersNvim;
    meta.homepage = "https://github.com/tversteeg/registers.nvim";
  };
  trouble-nvim = buildVimPluginFrom2Nix rec {
    pname = "trouble.nvim";
    version = neovimPlugins.nvimTroubleNvim.lastModifiedDate;
    src = neovimPlugins.nvimTroubleNvim;
    meta.homepage = "https://github.com/folke/trouble.nvim";
  };
  gitsigns-nvim = buildVimPluginFrom2Nix rec {
    pname = "gitsigns.nvim";
    version = neovimPlugins.nvimGitsignsNvim.lastModifiedDate;
    src = neovimPlugins.nvimGitsignsNvim;
    meta.homepage = "https://github.com/lewis6991/gitsigns.nvim";
  };
  hop-nvim = buildVimPluginFrom2Nix rec {
    pname = "hop.nvim";
    version = neovimPlugins.nvimHopNvim.lastModifiedDate;
    src = neovimPlugins.nvimHopNvim;
    meta.homepage = "https://github.com/phaazon/hop.nvim";
  };
}
