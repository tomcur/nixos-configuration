{ config, pkgs, ... }:

{
  # Allow unfree software.
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use explicit kernel version.
  # boot.kernelPackages = pkgs.linuxPackages_4_19;

  # Kernel params.
  # boot.kernelParams = [];
  # boot.crashDump.enable = true;

  boot.kernel.sysctl = { "kernel.sysrq" = 1; };

  networking = {
    networkmanager.enable = true; # Enables network manager.
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Virtual console settings.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Nix.
    nix-index
    patchelf
    niv
    # Terminal.
    zsh
    # Terminal emulator.
    rxvt_unicode
    alacritty
    # Tools
    wget
    neovim # (vim_configurable.override {})
    git
    git-crypt
    file
    tree
    usbutils
    rename # regex bulk file rename
    ripgrep
    fd
    # Process management.
    killall
    htop
    # Archives.
    cabextract
    zip
    unzip
    # Data.
    mime-types
    # Network.
    pciutils
    dhcp
    whois
    # Drives.
    ntfs3g
    sshfs
    hdparm
    smartmontools
    # XRandR.
    arandr
    # X.
    xclip
    # Desktop things.
    playerctl # Control media players.
    xmonad-log
    polybar
    feh
    # Authentication management.
    polkit_gnome # GUI authentication.
    # Themes.
    gtk2
    gtk3
    gnome-themes-standard # Required by Vertex.
    gtk-engine-murrine # Required by Vertex.
    theme-vertex
    paper-icon-theme
    gnome3.defaultIconTheme
    gnome3.adwaita-icon-theme
    # GUI stuff.
    xfce.thunar
    xfce.thunar-volman
    xfce.exo
  ] ++ (with pkgs.kdeApplications; [
    pkgs.kde-cli-tools
    dolphin
    dolphin-plugins
    kio-extras
    ffmpegthumbs
    kdegraphics-thumbnailers
  ]) ++ (with pkgs.kdeFrameworks; [
    kinit
    breeze-icons
    # frameworkintegration
    # kactivities
    # kcoreaddons
    kio
    # krunner
    # kservice
  ]) ++ (with pkgs.plasma5; [
    breeze-qt5
  ]);

  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];

  # Global shell variables.
  environment.sessionVariables = {
    # Enable GTK to find themes.
    GTK_DATA_PREFIX = [ "${config.system.path}" ];
    # Allow Java programs to work with non-reparenting Window Managers (XMonad).
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # Global shell variables.
  environment.variables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
    VISUAL = "${pkgs.neovim}/bin/nvim";
  };

  # Place mime.types data in /etc.
  environment.etc."mime.types".source = "${pkgs.mime-types}/etc/mime.types";

  fonts.fonts = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    # Unicode coverage.
    unifont
    # Monospace fonts. (There are never enough.)
    source-code-pro
    anonymousPro
    terminus_font
    hack-font
    fira-code
    fira-code-symbols
    (iosevka.override {
      set = "code";
      privateBuildPlan = {
        family = "Iosevka";
        design = [
          "no-ligation"
          "sp-force-monospace"
          "v-l-tailed"
          "v-i-hooky"
          "v-zero-dotted"
          "v-at-long"
          "v-numbersign-upright"
        ];
        weights.regular = {
          shape = 400;
          menu = 400;
          css = 400;
        };
        weights.book = {
          shape = 450;
          menu = 450;
          css = 450;
        };
        weights.bold = {
          shape = 700;
          menu = 700;
          css = 700;
        };
        slants = {
          upright = "normal";
          italic = "italic";
        };
      };
    })
    inconsolata
    kawkab-mono-font
    # Icons.
    twemoji-color-font
    siji
    font-awesome_5
    emacs-all-the-icons-fonts
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "Source Code Pro" "Noto Color Emoji" ];
      sansSerif = [ "DejaVu Sans" "Noto Color Emoji" ];
      serif = [ "DejaVu Serif" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Configurable QT themes without a desktop manager.
  programs.qt5ct.enable = true;

  # Gnome GSettings backend.
  programs.dconf.enable = true;

  # Start the SSH agent on login.
  programs.ssh.startAgent = true;

  programs.gnupg = {
    agent.enable = true;
    agent.pinentryFlavor = "gtk2";
  };

  # Configure tmux.
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    clock24 = true;
    escapeTime = 10;
    historyLimit = 5000;
    keyMode = "vi";
    extraConfig = ''
      set -ga terminal-overrides ",alacritty:Tc,*-256col*:Tc"
      set -g status-style "fg=colour8 bg=colour3 dim"
      set -g message-style "fg=colour3 bg=colour8"
    '';
  };

  # Configure zshell.
  programs.zsh.enable = true;
  programs.zsh.promptInit = ''
    if [ "$TERM" != dumb ]; then
      autoload -Uz add-zsh-hook

      setprompt() {
        setopt noxtrace localoptions
        local prompt_newline
        local p_user p_host
        local base_prompt_count base_prompt_path_count prompt_length space_left
        local base_prompt path_prompt cont_prompt

        prompt_newline=$'\n%{\r%}'
        p_user='%(!.%F{red}%n%f.%F{yellow}%n%f)'

        if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
          p_host='%F{cyan}%M%f'
        else
          p_host='%F{yellow}%M%f'
        fi

        if [[ -n "$IN_NIX_SHELL" ]]; then
          p_nix_shell=' (nix)'
        else
          p_nix_shell='''
        fi

        # Base prompt without colors.
        base_prompt_count=$(print -P "%n@%M")
        # Base prompt with path without colors.
        base_prompt_path_count=$(print -P "%n@%M %~ >")

        # Length of expanded base prompt with path.
        prompt_length=''${#base_prompt_path_count}

        base_prompt="''${p_user}%F{yellow}@%f''${p_host}''${p_nix_shell}"
        cont_prompt=""
        if [[ $prompt_length -lt 40 ]]; then
          path_prompt="%B%~%b"
          cont_prompt="$base_prompt $path_prompt"
        else
          # Truncate path if neccesary. Ensure to keep distance
          # to right margin of shell window.
          # Place a newline after the path.
          space_left=$(( $COLUMNS - $#base_prompt_count - 1 ))
          path_prompt="%B%F{white}%''${space_left}<...<%~%<<%f%b$prompt_newline"
        fi

        PS1="$base_prompt $path_prompt %B%F{white}%#%f%b "
        PS2="$cont_prompt %B%F{white}%_>%f%b "
        PS3="$cont_prompt %B%F{white}?#%f%b "
        PS4=" %B%F{white}+%f%b "
      }
      add-zsh-hook precmd setprompt
    fi
  '';
  programs.zsh.shellAliases = {
    vi = "nvim";
    ns = "nix-shell --command zsh";
  };
  programs.zsh.histSize = 40000;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.autosuggestions.extraConfig = {
    ZSH_AUTOSUGGEST_USE_ASYNC = "1";
  };
  programs.zsh.setOptions = [
    "HIST_IGNORE_SPACE"
  ];

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark; # The default is wireshark-cli.

  services = {
    # Useful for Wireshark.
    geoip-updater.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;
    openssh.forwardX11 = true;

    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      layout = "us,ru";
      xkbOptions = "compose:ralt,grp:menu_toggle,grp_led:caps,caps:backspace";
      autoRepeatDelay = 250;
      autoRepeatInterval = 1000 / 40;

      desktopManager.xterm.enable = true;

      # Enable SVG icons.
      gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

    };

    # Compositing.
    compton = {
      enable = false;
      fade = true;
      fadeDelta = 3;
      shadow = true;
      shadowExclude = [ "window_type *= 'menu'" "name ~= 'Firefox$'" ];
      settings = {
        no-dock-shadow = true;
        clear-shadow = true;
        xinerama-shadow-crop = true;
      };
    };

    # Nixops DNS.
    nixops-dns = {
      enable = true;
      user = "thomas";
    };

    gvfs.enable = true;
    bamf.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;
    printing.drivers = [ pkgs.gutenprint pkgs.gutenprintBin pkgs.epson-escpr ];
  };

  # Support 3D acceleration for 32-bit programs.
  hardware.opengl.driSupport32Bit = true;

  # Set default systemd services timeout.
  # Note services can extend their stop time by signalling
  # 'EXTEND_TIMEOUT_USEC'.
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=30s
  '';

  security.pam.loginLimits = [
    {
      domain = "thomas";
      type = "hard";
      item = "nofile";
      value = "1048576";
    }
    {
      domain = "thomas";
      type = "soft";
      item = "nofile";
      value = "1048576";
    }
  ];

  users.defaultUserShell = pkgs.zsh;
  users.users.thomas = {
    isNormalUser = true;
    home = "/home/thomas";
    extraGroups = [ "wheel" "networkmanager" "video" "docker" "wireshark" ];
    openssh.authorizedKeys.keyFiles = [ ./keys/thomas.pub ];
  };
  nix.trustedUsers = [ "root" "thomas" ];
}
