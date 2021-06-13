{ unstablePkgs, ... }:
{
  # programs.kitty = {
  #   enable = true;

  # };
  home.packages = with unstable; [ kitty ]

    xdg.configFile."kitty/kitty.conf".text = ''
    font_family iosevka
    font_size 11.0

    color0:   #0x272822
    color8:   #0x75715E
    color1:   #0xF92672
    color9:   #0xF92672
    color2:   #0xA6E22E
    color10:  #0xA6E22E
    color3:   #0xF4BF75
    color11:  #0xF4BF75
    color4:   #0x66D9EF
    color12:  #0x66D9EF
    color5:   #0xAE81FF
    color13:  #0xAE81FF
    color6:   #0xA1EFE4
    color14:  #0xA1EFE4
    color7:   #0xF8F8F2
    color15:  #0xF9F8F5
  '';
}
