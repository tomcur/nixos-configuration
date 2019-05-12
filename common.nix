{ config, pkgs, ... }:

{
  # Allow unfree software.
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use explicit kernel version.
  # boot.kernelPackages = pkgs.linuxPackages_4_19;

  # Kernel params.
  boot.kernelParams = [];

  networking = {
    networkmanager.enable = true; # Enables network manager.
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Nix.
    nix-index
    patchelf
    # Terminal.
    zsh
    # Terminal emulator.
    rxvt_unicode
    # Tools
    wget
    neovim # (vim_configurable.override {})
    git
    tmux
    file
    usbutils
    killall
    rename # regex bulk file rename
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
    # X.
    xclip
    # Desktop things.
    playerctl # Control media players.
    xmonad-log
    polybar
    rofi
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
    gvfs
    xfce.exo
  ];

  environment.sessionVariables = {
    # Enable GTK to find themes.
    GTK_DATA_PREFIX = [
      "${config.system.path}"
    ];
  };

  environment.variables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
    VISUAL = "${pkgs.neovim}/bin/nvim";
    GIO_EXTRA_MODULES = [
    	"${pkgs.gvfs}/lib/gio/modules"
    ];
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
    iosevka-bin
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
      monospace = ["Hack"];
      sansSerif = ["DejaVu Sans"];
      serif = ["DejaVu Serif"];
    };
  };

  # Virtualisation.
  virtualisation.virtualbox.host = {
    enable = true;
  };

  # Configurable QT themes without a desktop manager.
  programs.qt5ct.enable = true; 

  # Gnome GSettings backend.
  programs.dconf.enable = true;

  # Start the SSH agent on login.
  programs.ssh.startAgent = true;

  # Configure zshell.
  programs.zsh.enable = true;
  programs.zsh.promptInit = ''
    if [ "$TERM" != dumb ]; then
      autoload -Uz add-zsh-hook

      alias vi="nvim"

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

        # Base prompt without colors.
        base_prompt_count=$(print -P "%n@%M")
        # Base prompt with path without colors.
        base_prompt_path_count=$(print -P "%n@%M %~ >")

        # Length of expanded base prompt with path.
        prompt_length=''${#base_prompt_path_count}

        base_prompt="''${p_user}%F{yellow}@%f''${p_host}"
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

  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Use (non-free) Nvidia drivers.
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Use non-free Nvidia drivers.
      layout = "us,ru";
      xkbOptions = "compose:ralt,grp:menu_toggle,grp_led:caps,caps:backspace";
      autoRepeatDelay = 250;
      autoRepeatInterval = 1000 / 40;

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.dbus
        ];
      };
      windowManager.default = "xmonad";

      # Enable SVG icons.
      gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    };

    # Compositing.
    compton = {
      enable = true;
    };

    mysql = {
      package = pkgs.mariadb;
      enable = true;
    };

    # Nixops DNS.
    nixops-dns = {
      enable = true;
      user = "thomas";
    };

    # Enable CUPS to print documents.
    printing.enable = true;
    printing.drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
  };

  # Support 3D acceleration for 32-bit programs.
  hardware.opengl.driSupport32Bit = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  users.defaultUserShell = pkgs.zsh;
  users.users.thomas = {
    isNormalUser = true;
    home = "/home/thomas";
    extraGroups = [ "wheel" "networkmanager" ];
  };
}
