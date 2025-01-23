{ buildVimPluginFrom2Nix, neovimPlugins }:
{
  vim-monochrome = buildVimPluginFrom2Nix rec {
    pname = "vim-monochrome";
    version = neovimPlugins.nvimMonochrome.lastModifiedDate;
    src = neovimPlugins.nvimMonochrome;
    meta.homepage = "https://github.com/fxn/vim-monochrome";
  };
}
