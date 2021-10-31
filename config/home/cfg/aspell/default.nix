{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    aspell
    aspellDicts.en
  ];

  home.file.".aspell.conf".text = "data-dir /etc/profiles/per-user/${config.home.username}/lib/aspell";
}
