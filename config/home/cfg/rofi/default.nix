{ pkgs, ... }:
{
  home.packages = [
    pkgs.rofi
  ];
  xdg.configFile."rofi/config.rasi".source = ./config.rasi;
  xdg.configFile."rofi/theme.rasi".source = ./theme.rasi;
}
