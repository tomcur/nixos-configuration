{ pkgs, ... }:

{
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.gnome3.adwaita-icon-theme;
      name = "Adwaita";
    };
    settings = {
      global = {
        markup = true;
        sort = false;
        alignment = "left";
        vertical_alignment = "center";
        word_wrap = true;
        ignore_newline = false;
        geometry = "680x5-24+49";
        shrink = false;
        show_indicators = true;
        line_height = 1;
        separator_height = 2;
        separator_color = "frame";
        dmenu = "rofi -dmenu -p dunst";
        browser = "firefox -new-tab";
        icon_position = "right";
        max_icon_size = 256;
        frame_width = 1;
        frame_color = "#BABABA";
        font = "Noto Sans 11";
        allow_markup = true;
        format = "<b>%a</b>\\n%s\\n%b";
        padding = 24;
        horizontal_padding = 24;
        # not yet in released version:
        # text_icon_padding = 16;
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
      urgency_low = {
        background = "#FAFAFAC0";
        foreground = "#595959";
        timeout = 5;
      };
      urgency_normal = {
        background = "#FAFAFAC0";
        foreground = "#595959";
        timeout = 15;
      };
      urgency_critical = {
        background = "#FAFAFAC0";
        foreground = "#895959";
        timeout = 0;
      };
      fullscreen_delay_everything = {
        fullscreen = "delay";
      };
    };
  };
}
