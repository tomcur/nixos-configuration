{ config, pkgs, ... }:

let
  background = "#bb000000";
  background-alt = "#424242";
  foreground = "#eee";
  foreground-alt = "#888";
  border = "#333";
  line = "#a0a0a0";
  red = "#dc322f";
  yellow = "#b58900";
  violet = "#6c71c5";
  cyan = "#2aa198";
  redshift-info = import ./scripts/redshift-info.nix;
  redshift-toggle = import ./scripts/redshift-toggle.nix;
in {
  config.home.packages = [ redshift-info ];
  config.services.polybar = {
    enable = true;
    config = {
      "bar/top" = {
        monitor = "\${env:MONITOR}";
        width = "100%";
        height = 30;
        background = background;
        foreground = foreground;
        overline-size = 2;
        underline-size = 0;
        line-color = line;
        border-bottom-size = 2;
        border-bottom-color = border;
        spacing = 0;
        padding-left = 1;
        padding-right = 1;
        module-margin-left = 1;
        module-margin-right = 1;
        font-0 = "Source Code Pro:pixelsize=10;2";
        font-1 = "DejaVu Sans:pixelsize=11;3";
        font-2 = "Siji:pixelsize=10;2";
        font-3 = "Unifont:size=9:antialias=false;3";
        font-4 = "Twitter Color Emoji:scale=10;2";
        modules-left = "volume redshift bspwm";
        modules-center = "xwindow";
        # modules-right is handled through system-specific configuration
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        wm-restack = "bspwm";
      };
      "module/bspwm" = {
        type = "internal/bspwm";
        pin-workspaces = true;
        enable-click = true;
        format = "<label-monitor>: <label-state> <label-mode>";
        label-separator = "";
        label-focused = " %name% ";
        label-focused-background = background-alt;
        label-focused-overline = line;
        label-urgent = " %name% ";
        label-urgent-foreground = red;
        label-urgent-overline = red;
        label-occupied = " %name% ";
        label-empty = "";
      };
      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%{T2}%title:0:40:...%%{T-}";
        label-padding = 2;
      };
      "module/date" = {
        type = "internal/date";
        interval = "1.0";
        date = "%b %d";
        time = "%H:%M";
        label = "%date% %time%";
      };
      "module/volume" = {
        type = "internal/alsa";
        format-volume = "<label-volume> <bar-volume>";
        label-volume = "";
        label-volume-foreground = foreground-alt;
        format-muted-prefix = " ";
        format-muted-foreground = foreground-alt;
        label-muted = "sound muted";

        bar-volume-width = 10;
        bar-volume-foreground-0 = "#55aa55";
        bar-volume-foreground-1 = "#55aa55";
        bar-volume-foreground-2 = "#55aa55";
        bar-volume-foreground-3 = "#55aa55";
        bar-volume-foreground-4 = "#55aa55";
        bar-volume-foreground-5 = "#f5a70a";
        bar-volume-foreground-6 = "#ff5555";
        bar-volume-gradient = false;
        bar-volume-indicator = "|";
        bar-volume-indicator-font = 4;
        bar-volume-fill = "─";
        bar-volume-fill-font = 4;
        bar-volume-empty = "─";
        bar-volume-empty-font = 4;
        bar-volume-empty-foreground = foreground-alt;
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format-prefix = " ";
        format-prefix-foreground = foreground-alt;
        label = "%percentage:2%%";
      };
      "module/memory" = {
        type = "internal/memory";
        interval = 3;
        format-prefix = " ";
        format-prefix-foreground = foreground-alt;
        label = "%percentage_used%%";
      };
      "module/wlan" = {
        type = "internal/network";
        #interface = "wlp3s0";
        interval = "3.0";

        format-connected = "<ramp-signal> <label-connected>";
        label-connected = "%essid% %downspeed:8% %upspeed:8%";

        format-disconnected = "";
        ramp-signal-0 = "";
        ramp-signal-1 = "";
        ramp-signal-2 = "";
        ramp-signal-3 = "";
        ramp-signal-4 = "";
        ramp-signal-foreground = foreground-alt;
      };
      "module/battery" = {
        type = "internal/battery";
        full-at = 99;
        battery = "BAT0";
        adapter = "ADP1";
        poll-interval = 5;
        time-format = "%H:%M";
        format-charging-overline = line;
        format-discharging-overline = red;
        format-charging = "<animation-charging> <label-charging>";
        format-discharging = "<ramp-capacity> <label-discharging>";
        label-charging = "Charging %percentage%%";
        label-discharging = "%percentage%% (%time%)";
        label-full = "Fully charged";
        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
        ramp-capcity-foreground = foreground-alt;
        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-framerate = 750;
        animation-charging-foreground = foreground;
      };
      "module/xmonad" = {
        type = "custom/script";
        exec = "${pkgs.xmonad-log}/bin/xmonad-log";
        tail = true;
      };
      "module/redshift" = {
        type = "custom/script";
        exec = "${redshift-info}/bin/redshift-info";
        click-left = "${redshift-toggle}/bin/redshift-toggle";
        interval = 5;
        format-prefix = " ";
        format-prefix-foreground = foreground-alt;
      };
    };
  };
}
