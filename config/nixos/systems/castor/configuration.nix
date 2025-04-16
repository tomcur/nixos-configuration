{ config, pkgs, lib, ... }:
{
  imports = [
    ../../common.nix
    ../../audio-pipewire.nix
    ../../modules/sway.nix
    ../../modules/hyprland.nix
    ../../modules/river.nix
    ../../modules/probe-rs-udev
    ./music.nix
    ./secret.nix
    ./wireguard-network.nix
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelPackages = pkgs.linuxPackages_6_14;
  # boot.kernelPackages = pkgs.linuxPackages_5_11;
  # boot.kernelPackages = pkgs.linuxPackages_5_10.extend (self: super: {
  #   nvidia_x11 = unstable.pkgs.linuxPackages_5_10.nvidia_x11;
  #   broadcom_sta = unstable.pkgs.linuxPackages_5_10.broadcom_sta;
  # });
  # boot.kernelPackages = pkgs.linuxPackages_5_10.extend (self: super: {
  #   # nvidia_x11 = unstable.pkgs.linuxPackages_5_10.nvidia_x11;
  #   # # See:
  #   # # https://github.com/NixOS/nixpkgs/issues/101040
  #   # broadcom_sta = super.broadcom_sta.overrideAttrs (oA: {
  #   #   meta.broken = false;
  #   #   # patches = oA.patches ++ [ ../patches/broadcom-sta-5.9.patch ] ++ oA.patches;
  #   #   patches = [
  #   #     ../patches/broadcom-sta/i686-build-failure.patch
  #   #     ../patches/broadcom-sta/license.patch
  #   #     ../patches/broadcom-sta/linux-4.7.patch
  #   #     # source: https://git.archlinux.org/svntogit/community.git/tree/trunk/004-linux48.patch?h=packages/broadcom-wl-dkms
  #   #     ../patches/broadcom-sta/linux-4.8.patch
  #   #     # source: https://aur.archlinux.org/cgit/aur.git/tree/linux411.patch?h=broadcom-wl
  #   #     ../patches/broadcom-sta/linux-4.11.patch
  #   #     # source: https://aur.archlinux.org/cgit/aur.git/tree/linux412.patch?h=broadcom-wl
  #   #     ../patches/broadcom-sta/linux-4.12.patch
  #   #     ../patches/broadcom-sta/linux-4.15.patch
  #   #     ../patches/broadcom-sta/linux-5.1.patch
  #   #     # source: https://salsa.debian.org/Herrie82-guest/broadcom-sta/-/commit/247307926e5540ad574a17c062c8da76990d056f
  #   #     ../patches/broadcom-sta/linux-5.6.patch
  #   #     # source: https://gist.github.com/joanbm/5c640ac074d27fd1d82c74a5b67a1290
  #   #     ../patches/broadcom-sta/linux-5.9.patch
  #   #     ../patches/broadcom-sta/null-pointer-fix.patch
  #   #     ../patches/broadcom-sta/gcc.patch
  #   #   ];
  #   # });
  # });

  # Enable fcitx5 for ui testing purposes
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-chinese-addons
      fcitx5-nord
    ];
  };

  hardware.enableRedistributableFirmware = true;
  hardware.probe-rs-udev.enable = true;

  # Enable architecture emulation for native compilation of foreign binaries.
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    # "armv6l-linux"
    # "armv7l-linux"
  ];
  # boot.binfmt.registrations."armv6l-linux".fixBinary = true;

  # Enable gvt-g to allow sharing iGPU between host and VM.
  # boot.kernelParams = [ "intel_iommu=on" "kvm.ignore_msrs=1" ];
  # boot.kernelModules = [ "vfio" "vfio_pci" ];
  # boot.blacklistedKernelModules = [ "nouveau" ];
  # virtualisation.kvmgt.enable = true;

  # Disable onboard audio and set vfio pci.
  # options snd slots=snd-hda-intel
  # options snd_hda_intel enable=0,0
  # options vfio-pci ids=8086:1912
  boot.extraModprobeConfig = ''
  '';

  fileSystems = {
    "/mnt/d" = {
      device = "/dev/disk/by-uuid/a11521e0-ebda-44a5-8a62-fb452081c11a";
    };
    # NTFS drive.
    "/mnt/q" = {
      device = "/dev/disk/by-uuid/0E3CC6AE3CC6905F";
      fsType = "ntfs-3g";
    };
  };

  networking = {
    hostName = "castor";
    interfaces.tap0 = {
      virtual = true;
      ipv4.addresses = [{
        address = "192.168.240.100";
        prefixLength = 24;
      }];
    };
    nat.enable = true;
    nat.externalInterface = "wlo1";
    nat.internalInterfaces = [ "tap0" "ve-+" ];
    firewall = {
      # extraCommands = ''
      #   iptables -A INPUT -i tap0 -j ACCEPT
      #   iptables -A FORWARD -i tap0 -o wlo1 -j ACCEPT
      #   iptables -A FORWARD -i wlo1 -o tap0 -j ACCEPT
      #   iptables -t nat -A POSTROUTING -s 192.168.240.100/24 -o wlo1 -j MASQUERADE
      #   iptables -t nat -A PREROUTING -i wlo1 -p tcp --dport 6667  -j DNAT --to-destination 192.168.240.5:6667
      #   iptables -t nat -A PREROUTING -i wlo1 -p tcp --dport 28910 -j DNAT --to-destination 192.168.240.5:28910
      #   iptables -t nat -A PREROUTING -i wlo1 -p tcp --dport 29900 -j DNAT --to-destination 192.168.240.5:29900
      #   iptables -t nat -A PREROUTING -i wlo1 -p tcp --dport 29920 -j DNAT --to-destination 192.168.240.5:29920
      #   iptables -t nat -A PREROUTING -i wlo1 -p udp --dport 4321  -j DNAT --to-destination 192.168.240.5:4321
      #   iptables -t nat -A PREROUTING -i wlo1 -p udp --dport 16000 -j DNAT --to-destination 192.168.240.5:16000
      #   iptables -t nat -A PREROUTING -i wlo1 -p udp --dport 27900 -j DNAT --to-destination 192.168.240.5:27900
      # '';
      allowedTCPPorts = [
        80
        443
        61167
        1883 # MQTT
        8000
        8080 # Alternative HTML
        22000 # Syncthing listening
        8800 # Calibre server
      ];
      allowedUDPPorts = [
        34197 # Factorio
        21027 # Syncthing ipv4 discovery and ipv6 multicasts
      ];
    };
  };

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    # Drives.
    gparted
    hd-idle
    # Big applications.
    # teamviewer
    # Virtalisation.
    # virt-viewer
    # virt-manager
    # AMD GPU management
  ];

  environment.variables = {
    XKB_DEFAULT_OPTIONS = "compose:ralt,grp:menu_toggle";
    XKB_DEFAULT_LAYOUT = "us,ru";
    # xkbOptions = "compose:ralt,grp:menu_toggle"; # ,grp_led:caps,caps:backspace";
  };

  programs.corectrl.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = [
    pkgs.amdvlk
  ];

  programs.my-river-env.enable = true;
  programs.noisetorch.enable = true;
  programs.extra-container.enable = true;

  # Set monitor position and force compositor pipeline to prevent screen tearing (nvidia).
  # hardware.nvidia.modesetting.enable = true;
  services = {
    xserver = {
      # Use non-free Nvidia drivers.

      # Specifying both nivida and intel as drivers suddenly started segfaulting xserver on startup
      # videoDrivers = [ "nvidia" "intel" ];
      videoDrivers = [ "amdgpu" ];
      xrandrHeads = [ "DP-2" "DP-4" ];

      # Option "MetaModes" "DP-2: nvidia-auto-select +0+240 { }, DP-4: nvidia-auto-select +2560+0 { Rotation = Left }"
      screenSection = ''
        Option "MetaModes" "DP-4: nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
        Option "FlatPanelProperties" "Dithering = Disabled"
        Option "TripleBuffer" "On"
        Option "Coolbits" "12"
      '';

      # extraConfig = ''
      #   Section "Extensions"
      #     Option "MIT-SHM" "Disable"
      #   EndSection
      # '';

      # config = ''
      #   Section "Device"
      #     Identifier "nvidia0"
      #     Driver "nvidia"
      #     BusID "PCI:1:0:0"
      #     Screen 0
      #   EndSection

      #   Section "Device"
      #     Identifier "nvidia1"
      #     Driver "nvidia"
      #     BusID "PCI:1:0:0"
      #     Screen 1
      #   EndSection

      #   Section "Screen"
      #     Identifier "Screen0"
      #     Device "nvidia0"
      #     Monitor "Monitor0"
      #     DefaultDepth 24
      #     Subsection "Display"
      #       Depth 24
      #       Modes "2560x1440" "1920x1080"
      #     EndSubsection
      #   EndSection

      #   Section "Screen"
      #     Identifier "Screen1"
      #     Device "nvidia1"
      #     Monitor "Monitor1"
      #     DefaultDepth 24
      #     Subsection "Display"
      #       Depth 24
      #       Modes "1920x1080"
      #     EndSubsection
      #   EndSection

      #   Section "Monitor"
      #     Identifier "multihead1"
      #     Option "Primary" "true"
      #   EndSection

      #   Section "Monitor"
      #     Identifier "multihead2"
      #     Option "RightOf" "multihead1"
      #   EndSection

      #   Section "ServerLayout"
      #     Identifier "Layout[all]"

      #     Screen         0 "Screen0" 
      #     Screen         1 "Screen1" rightOf "Screen0"
      #   EndSection
      # '';
    };

    nginx = {
      enable = true;
      # user = "thomas";
      # group = "users";
      virtualHosts = {
        "castor.uint.one" = {
          # addSSL = true;
          # enableACME = true;
          root = "/var/lib/www";
          extraConfig = ''
            autoindex on;
          '';
        };
      };
    };

    mysql = {
      package = pkgs.mariadb;
      enable = true;
    };

    # postgresql = {
    #   enable = true;
    #   ensureUsers = [
    #     { name = "thomas"; }
    #   ];
    # };

    # teamviewer.enable = true;
    ratbagd.enable = true;
  };
  systemd.services.postgresql.postStart = lib.mkAfter ''
    $PSQL service1 -c 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "thomas"'
  '';

  systemd.user.services.gammastep =
    {
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      description = "Control display color temperature";
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
        ExecStart = ''
          ${pkgs.gammastep}/bin/gammastep -l 54.5:4.0 -t 6500:3400
        '';
      };
    };

  location = {
    latitude = 52.0;
    longitude = 5.5;
  };

  # security.acme.acceptTerms = true;
  # security.acme.certs = {
  #   "castor.uint.one".email = "thomas@kepow.org";
  # };

  # Idle hdd automatically.
  systemd.services.hd-idle-boot = {
    description = "HD spin-down on boot";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.hd-idle}/bin/hd-idle -t /dev/disk/by-id/wwn-0x50014ee0aebd0c5f";
    };
  };
  systemd.services.hd-idle = {
    description = "HD spin-down";
    wantedBy = [ "multi-user.target" ];
    after = [ "hd-idle-boot.service" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 0 -a /dev/disk/by-id/wwn-0x50014ee0aebd0c5f -i 450";
    };
  };

  systemd.services.dynamic-dns = {
    description = "Update Dynamic DNS entry";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    startLimitIntervalSec = 300;
    startLimitBurst = 3;
    script = ''
      ${pkgs.curl}/bin/curl -6 "https://castor.dyn.uint.one:$DYNDNS_PASS@dyn.dns.he.net/nic/update?hostname=castor.dyn.uint.one"
      ${pkgs.curl}/bin/curl -4 "https://castor.dyn.uint.one:$DYNDNS_PASS@dyn.dns.he.net/nic/update?hostname=castor.dyn.uint.one"
    '';
    serviceConfig = {
      EnvironmentFile = "/run/agenix/dyndns-castor";
    };
  };

  systemd.timers.dynamic-dns = {
    wantedBy = [ "timers.target" ];
    partOf = [ "dynamic-dns.service" ];
    timerConfig.OnCalendar = "hourly";
  };

  # Virtualisation.
  # virtualisation.virtualbox.host = { enable = true; };
  virtualisation.docker.enable = true;
  # virtualisation.docker.enableNvidia = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.verbatimConfig = ''
      seccomp_sandbox = 0
    '';
  };

  boot.loader.systemd-boot.memtest86.enable = true;

  age.secrets.email-thomas-churchman-nl = {
    file = ../../../../secrets/email-thomas-churchman-nl.age;
    owner = "thomas";
  };
  age.secrets.email-thomas-kepow-org = {
    file = ../../../../secrets/email-thomas-churchman-nl.age;
    owner = "thomas";
  };
  age.secrets.dyndns-castor = {
    file = ../../../../secrets/dyndns-castor.age;
    owner = "root";
  };

  # Remote-build user.
  users.users.remote-builder = {
    isSystemUser = true;
    useDefaultShell = true;
    openssh.authorizedKeys.keyFiles = [
      ../../keys/castor-remote-builder.pub
      ../../keys/root_argo_ed25519_key.pub
    ];
  };
  nix.settings.trusted-users = [ "remote-builder" ];

  # nix.sshServe.enable = true;
  # nix.sshServe.keys = [ ];
  # nix.extraOptions = ''
  #   secret-key-files = /root/keys/nix_cache_ed25519_key
  # '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.05"; # Did you read the comment?
}
