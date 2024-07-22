{ buildVimPluginFrom2Nix, neovimPlugins }:
{
  plenary = buildVimPluginFrom2Nix rec {
    pname = "plenary";
    version = neovimPlugins.nvimPlenary.lastModifiedDate;
    src = neovimPlugins.nvimPlenary;
    meta.homepage = "https://github.com/nvim-lua/plenary.nvim";
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
}
