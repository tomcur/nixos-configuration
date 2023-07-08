{ pkgs, stablePkgs, unstablePkgs, patchedPkgs, neovimPkg, neovimPlugins, ... }:
let
  runtime = pkgs.buildEnv {
    name = "helix-runtime";
    paths = with pkgs; [
      nodePackages.typescript-language-server
    ];
  };
  wrappedHelix = pkgs.symlinkJoin {
    name = "helix";
    paths = [ pkgs.helix ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/hx \
        --prefix PATH : "${runtime}/bin"
    '';
  };
in
{
  home.packages = [
    wrappedHelix
  ];

  home.file = {
    # ".config/helix/config.toml".source = ./rc.vim;
  };
}
