{ inputs, config, pkgs, unstablePkgs, patchedPkgs, ... }:
{
  # Common packages.
  home.packages = [
    (pkgs.callPackage ./my-programs/brightness-control { })
    (pkgs.callPackage ./my-programs/volume-control { })
    inputs.thingshare.defaultPackage.${pkgs.stdenv.hostPlatform.system}
    (pkgs.callPackage ./my-programs/extract { })
    (pkgs.callPackage ./my-programs/paper {
      buildPythonPackage = pkgs.python3Packages.buildPythonPackage;
    })
  ] ++ (with pkgs; [
    # Font tools.
    gnome3.gucharmap
    # Tools.
    gnome3.gnome-system-monitor
    libnotify
    filelight
    ark
    calc
    leafpad
    transmission-gtk
    # Documents.
    nomacs
    okular
    zathura
    libreoffice
    # Reference management.
    zotero
    # Cloud.
    seafile-client
    # Compiling.
    gcc
    gnumake
    # Debugging.
    ltrace
    gdb
    lldb
    gdbgui
    # TeX.
    (texlive.combine {
      inherit (texlive)
        amsmath# Math
        amsfonts# Math
        logreq# Automation, necessary for biblatex
        biblatex biblatex-ieee# References
        # psfonts # textcomp
        cm-super scheme-small apacite floatflt wrapfig# Figures
        enumitem courier# Font
        hyperref capt-of;
    })
    biber # For LaTeX.
  ]) ++ (with unstablePkgs; [
    # Fuzzy finder.
    fzf
    # Dotfiles manager.
    yadm
    # Editor.
    # The basics.
    firefox
    chromium
    thunderbird
    # Tools.
    direnv
    nox
    ripgrep
    # Structured data tools.
    nushell
    xsv
    # Password manager.
    keepassxc
    # File formatting.
    nixpkgs-fmt
    (python3.withPackages (python-packages: with python-packages; [ numpy ]))
    # Chat.
    element-desktop
    discord
    # Music.
    spotify
    # Mapping.
    josm
    # Databases.
    dbeaver
  ]) ++ (with patchedPkgs; [
  ]) ++ [ inputs.agenix.defaultPackage.x86_64-linux ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
      "text/plain" = [ "nvim-qt.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/octet-stream" = [ "firefox.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "image/svg+xml" = [ "org.nomacs.ImageLounge.desktop" ];
      "image/png" = [ "org.nomacs.ImageLounge.desktop" ];
      "image/tiff" = [ "org.nomacs.ImageLounge.desktop" ];
      "image/gif" = [ "org.nomacs.ImageLounge.desktop" ];
      "image/jpeg" = [ "org.nomacs.ImageLounge.desktop" ];
      "image/bmp" = [ "org.nomacs.ImageLounge.desktop" ];
      "video/mp4" = [ "mpv.desktop" ];
      "video/mpeg" = [ "mpv.desktop" ];
      "video/mkv" = [ "mpv.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" ];
      "video/flv" = [ "mpv.desktop" ];
      "audio/aac" = [ "mpv.desktop" ];
      "audio/ac3" = [ "mpv.desktop" ];
      "audio/mp4" = [ "mpv.desktop" ];
      "audio/mpeg" = [ "mpv.desktop" ];
      "audio/ogg" = [ "mpv.desktop" ];
      "audio/vorbis" = [ "mpv.desktop" ];
      "audio/wav" = [ "mpv.desktop" ];
      "audio/x-wav" = [ "mpv.desktop" ];
      "audio/mp3" = [ "mpv.desktop" ];
      "audio/x-mp3" = [ "mpv.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      "x-scheme-handler/magnet" = [ "deluge.desktop" ];
    };
    associations.added = {
      "image/svg+xml" = [ "nvim-qt.desktop" ];
    };
  };
  xdg.dataFile."dbus-1/services/org.freedesktop.FileManager1.service".text = ''
    [D-BUS Service]
    Name=org.freedesktop.FileManager1
    Exec=dolphin
  '';

  services.unclutter.enable = true;
  services.unclutter.timeout = 3;

  services.syncthing = { enable = true; };

  # Nix direnv handler.
  services.lorri = { enable = true; };

  programs.mpv = {
    enable = true;
    config = {
      # OSD.
      "--osd-on-seek" = "msg-bar";
      # Fuzzy sub name matching for autoload.
      sub-auto = "fuzzy";
    };

    bindings = {
      MBTN_LEFT = "cycle pause";
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
    };
  };

  # A systemd target to hook other units onto.
  # This is supposed to run when the window manager has started.
  systemd.user.targets.window-manager = {
    Unit = {
      PartOf = [ "graphical-session.target" ];
      Description = "window manager";
    };
  };

  systemd.user.sessionVariables = config.home.sessionVariables;

  imports = [
    ./cfg/zsh
    ./cfg/picom
    ./cfg/alacritty
    ./cfg/kitty
    ./cfg/nvim
    ./cfg/vscode
    ./cfg/gtk.nix
    ./cfg/xresources
    ./cfg/dunst.nix
    ./cfg/redshift
    ./cfg/rofi
  ];
}
