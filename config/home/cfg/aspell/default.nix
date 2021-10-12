{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aspell
    aspellDicts.en
  ];

  home.file.".aspell.conf".text = "data-dir ${pkgs.aspell}/lib/aspell";
}
