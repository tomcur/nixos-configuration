{ lib, pkgs, ... }: {
  home.file.".config/bspwm/bspwmrc".executable = true;
  home.file.".config/bspwm/bspwmrc".text = ''
    #!/usr/bin/env sh

    sxhkd &
    feh --randomize --bg-fill ~/Backgrounds/* &

    # Set desktop 0 to monocle.
    bspc desktop 0 -l monocle

    # FIXME: loop through attached monitors, and create desktops 1, 2, ...,
    # to ensure monitors don't start with an anonymous desktop.
    # Primary monitor.
    # bspc monitor DP-4 -d 1

    # Secondary monitor.
    # bspc monitor DVI-D-0 -d 2
    bspc monitor -d 1 2 3 4 5 6 7 8 9 0 d m

    bspc config focus_follows_pointer true

    bspc config border_width 2
    bspc config window_gap 12

    bspc config split_ratio 0.525
    bspc config single_monocle true
    bspc config borderless_monocle true
    bspc config gapless_monocle true

    bspc config initial_polarity first_child

    # Multihead.
    bspc config remove_disabled_monitors true
    bspc config remove_unplugged_monitors true

    # Per-application rules.
    bspc rule -a Emacs state=tiled

    # Notify window manager has started.
    systemctl --user import-environment PATH DBUS_SESSION_BUS_ADDRESS && \
      systemctl --no-block --user start window-manager.target

    case $HOSTNAME in
      (castor)
        (bspc rule -a \* -o desktop=0 && thunderbird) &
        (bspc rule -a \* -o desktop=0 && keepassxc) &
        (bspc rule -a \* -o desktop=0 && seafile-applet) &
        sleep 2
        (bspc rule -a \* -o desktop=m && alacritty -e ncmpcpp) &
        sleep 1
        (bspc rule -a \* -o desktop=m && cool-retro-term -e vis) &
        sleep 2
        bspc node @m:/ --rotate 270
        bspc config -d m window_gap 0
        (bspc rule -a \* -o desktop=6 && Discord) &
      ;;
      (pollux)
        (bspc rule -a Daily -o desktop=0 && thunderbird) &
        (bspc rule -a keepassxc -o desktop=0 && keepassxc) &
        (bspc rule -a seafile-applet -o desktop=0 && seafile-applet) &
      ;;
        (*)   echo "unknown host"
      ;;
    esac
  '';

  home.file.".config/sxhkd/sxhkdrc".text = ''
    ##########################
    # Hotkeys.
    ##########################

    # Terminal emulator.
    super + Return
        alacritty

    # Application launcher.
    super + p
        rofi -modi drun,run -show drun -show-icons

    super + w
        firefox

    super + f
        dolphin

    ctrl + shift + 1
        thingshare_screenshot full

    ctrl + shift + 2
        thingshare_screenshot display

    ctrl + shift + 3
        thingshare_screenshot window

    ctrl + shift + 4
        thingshare_screenshot region

    # Reload sxhkd configuration.
    super + Escape
        pkill -USR1 -x sxhkd

    ##########################
    # Media keys.
    ##########################

    XF86MonBrightnessUp
        brightness-control up

    XF86MonBrightnessDown
        brightness-control down

    XF86AudioLowerVolume
        volume-control down

    XF86AudioMute
        volume-control toggle-mute

    XF86AudioRaiseVolume
        volume-control up

    XF86AudioPlay
        playerctl play-pause

    XF86AudioStop
        playerctl stop

    XF86AudioPrev
        playerctl previous

    XF86AudioNext
        playerctl next

    ##########################
    # General bspwm.
    ##########################

    # Quit/restart bspwm.
    super + alt + {q,r}
        bspc {quit,wm -r}

    # Close/kill program.
    super + shift + {_,alt + }c
        bspc node -{c,k}

    # Switch between tiled and monocle layout.
    super + shift + f
        bspc desktop -l next

    ##########################
    # Monitors and desktops.
    ##########################

    # Focus given desktop on focused monitor.
    super + {0-9,d,m}
        desktop="{0-9,d,m}"; \
        bspc desktop "$desktop" --to-monitor focused; \
        bspc desktop -f "$desktop"; \
        bspc monitor focused -o $(bspc query -D -m focused --names | sort  | paste -d ' ' -s)

    # Move node to given desktop.
    super + shift + {0-9,d,m}
        bspc node --to-desktop {0-9,d,m}; \
        bspc monitor focused -o $(bspc query -D -m focused --names | sort  | paste -d ' ' -s)

    # Swap focused desktop with that on the next monitor.
    super + shift + s
        bspc desktop focused:focused -s next:focused --follow; \
        bspc monitor focused -o $(bspc query -D -m focused --names | sort  | paste -d ' ' -s); \
        bspc monitor prev -o $(bspc query -D -m prev --names | sort  | paste -d ' ' -s)

    # Focus given monitor or send node to given monitor.
    super + {_,shift + }{w,e}
        bspc {monitor -f,node -m} ^{1,2}

    # Dynamic gaps.
    super + {minus,equal}
        new_gap="$(($(bspc config -d focused window_gap) {-,+} 5))"; \
        clamped="$((new_gap < 0 ? 0 : new_gap))"; \
        bspc config -d focused window_gap "$clamped"

    ##########################
    # Window state.
    ##########################

    super + {t,shift + t,s,alt + f}
        bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

    super + ctrl + {m,x,y,z}
        bspc node -g {marked,locked,sticky,private}

    ##########################
    # Movement.
    ##########################

    # Focus / swap node direction.
    super + {_,shift + }{h,j,k,l}
        bspc node -{f,s} {west,south,north,east}

    # Focus previous/next window on this desktop.
    super + {comma,period}
        bspc node -f {prev,next}.local

    # Focus path jump.
    super + shift + {p,b,comma,period}
        bspc node -f @{parent,brother,first,second}

    # Swap current node and the biggest node on this desktop.
    super + shift + Return
        bspc node -s biggest.local

    # Move a floating window.
    super + {Left,Down,Up,Right}
        bspc node -v {-20 0,0 20,0 -20,20 0}

    # Rotate 90 degrees.
    super + r
        bspc node @parent --rotate 90

    # Send the focused node / newest marked node to the newest preselected node.
    super + {_,ctrl + }y
        bspc node {_,newest.marked.local }-n newest.!automatic.local

    ##########################
    # Preselect.
    ##########################

    # Preselect the direction.
    super + ctrl + {h,j,k,l}
        bspc node -p {west,south,north,east}

    # Preselect the ratio.
    super + ctrl + {1-9}
        bspc node -o 0.{1-9}

    # Cancel the preselection for the focused node.
    super + ctrl + space
        bspc node -p cancel

    # Cancel the preselection for the focused desktop.
    super + ctrl + shift + space
        bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

    ##########################
    # Resize.
    ##########################

    # Expand a node by moving one of its sides outward.
    super + alt + {h, j,k,l}
        bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

    super + alt + shift + {h,j,k,l}
        bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

    # Equalize from root node (reset layout).
    super + space
        bspc node @/ --equalize

    # Balance from root node (let everything take the same area).
    super + b
        bspc node @/ --balance

  '';

  systemd.user.services.bspwm-floating-desktop = let
    start-script = pkgs.writeScript "bspwm-floating-desktop" ''
      #!${pkgs.bash}/bin/bash

      ${pkgs.bspwm}/bin/bspc subscribe node | while read -a msg ; do
        FLOATING_DESKTOP_ID=$(${pkgs.bspwm}/bin/bspc query -D -d 'd')
        desk_id=''${msg[2]}
        wid=''${msg[3]}
        [ "$FLOATING_DESKTOP_ID" = "$desk_id" ] && ${pkgs.bspwm}/bin/bspc node "$wid" -t floating
      done
    '';
  in {
    Unit = { Description = "BSPWM floating desktop"; };

    Install = { WantedBy = [ "window-manager.target" ]; };

    Service = { ExecStart = "${start-script}"; };
  };
  home.file.".config/autorandr/postswitch".executable = true;
  home.file.".config/autorandr/postswitch".text = ''
    #!/usr/bin/env bash

    i=1
    IFS=:;
    for monitor in $AUTORANDR_MONITORS;
    do
      i=$((i+1))
      echo $monitor >>bspwm_test
      MONITOR=$monitor polybar top &
      disown
    done

    feh --randomize --bg-fill ~/Backgrounds/*
  '';
}
