{ lib, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  # macOS (CoreText) sees a single "Iosevka" family with width
  # and weight in the style name.
  font =
    if isDarwin then {
      family = "Iosevka";
      size = 14; # Points.
      normal = "Book Extended";
      bold = "Bold Extended";
      italic = "Book Extended Italic";
      boldItalic = "Bold Extended Italic";
    } else {
      family = "Iosevka Extended";
      size = 10.5;
      normal = "Book";
      bold = "Bold";
      italic = "Italic";
      boldItalic = "Bold Italic";
    };
in
{
  programs.ghostty = {
    enable = true;
    # The source-built package doesn't support macOS.
    package = if isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    # Would pull in bat.
    installBatSyntax = false;

    settings = {
      font-family = font.family;
      font-size = font.size;
      font-style = font.normal;
      font-style-bold = font.bold;
      font-style-italic = font.italic;
      font-style-bold-italic = font.boldItalic;

      theme = "monokai";
      background-opacity = 0.9;
      scrollback-limit = 50000 * 1024; # Bytes.

      # Minimal UI, also removes the window frame on mac to get square
      # corners.
      window-decoration = "none";
      window-show-tab-bar = "never";
      resize-overlay = "never";
      window-padding-x = 4;
      window-padding-y = 4;
      window-padding-balance = true;
      confirm-close-surface = false;
      mouse-hide-while-typing = true;
      cursor-style-blink = false;

      macos-option-as-alt = "left";

      # Spawn new windows in the current working directory.
      window-inherit-working-directory = true;

      keybind = [
        "ctrl+enter=new_window"
        "ctrl+alt+c=copy_to_clipboard"
        "ctrl+alt+v=paste_from_clipboard"
      ];
    };

    # Monokai dark.
    themes.monokai = {
      background = "272822";
      foreground = "F8F8F2";
      cursor-color = "F8F8F2";
      cursor-text = "272822";
      palette = [
        "0=#272822"
        "1=#F92672"
        "2=#A6E22E"
        "3=#F4BF75"
        "4=#66D9EF"
        "5=#AE81FF"
        "6=#A1EFE4"
        "7=#F8F8F2"
        "8=#75715E"
        "9=#F92672"
        "10=#A6E22E"
        "11=#F4BF75"
        "12=#66D9EF"
        "13=#AE81FF"
        "14=#A1EFE4"
        "15=#F9F8F5"
      ];
    };
  };
}
