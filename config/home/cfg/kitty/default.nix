{ unstablePkgs, ... }:
{
  # programs.kitty = {
  #   enable = true;

  # };
  home.packages = with unstablePkgs; [ kitty ];

  xdg.configFile."kitty/kitty.conf".text = ''
    font_family iosevka
    font_size 11.0

    color0   #272822
    color8   #75715E
    color1   #F92672
    color9   #F92672
    color2   #A6E22E
    color10  #A6E22E
    color3   #F4BF75
    color11  #F4BF75
    color4   #66D9EF
    color12  #66D9EF
    color5   #AE81FF
    color13  #AE81FF
    color6   #A1EFE4
    color14  #A1EFE4
    color7   #F8F8F2
    color15  #F9F8F5
  '';
}
