{ config, pkgs, ... }:
{
  imports = [ ../../common.nix ../../audio-pipewire.nix ./secret.nix ];

  # boot.kernelPackages = unstable.pkgs.linuxPackages-rt_5_11;
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

  # Enable gvt-g
  # boot.kernelParams = [ "intel_iommu=on" "kvm.ignore_msrs=1" ];
  # boot.kernelModules = [ "vfio" "vfio_pci" ];

  # Disable onboard audio and set vfio pci.
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
    options snd_hda_intel enable=0,0
  '';
  # options vfio-pci ids=8086:1912

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
    firewall = {
      extraCommands = ''
        iptables -A INPUT -i tap0 -j ACCEPT
        iptables -A FORWARD -i tap0 -o wlp3s0 -j ACCEPT
        iptables -A FORWARD -i wlp3s0 -o tap0 -j ACCEPT
        iptables -t nat -A POSTROUTING -s 192.168.240.100/24 -o wlp3s0 -j MASQUERADE
        iptables -t nat -A PREROUTING -i wlp3s0 -p tcp --dport 6667  -j DNAT --to-destination 192.168.240.5:6667
        iptables -t nat -A PREROUTING -i wlp3s0 -p tcp --dport 28910 -j DNAT --to-destination 192.168.240.5:28910
        iptables -t nat -A PREROUTING -i wlp3s0 -p tcp --dport 29900 -j DNAT --to-destination 192.168.240.5:29900
        iptables -t nat -A PREROUTING -i wlp3s0 -p tcp --dport 29920 -j DNAT --to-destination 192.168.240.5:29920
        iptables -t nat -A PREROUTING -i wlp3s0 -p udp --dport 4321  -j DNAT --to-destination 192.168.240.5:4321
        iptables -t nat -A PREROUTING -i wlp3s0 -p udp --dport 16000 -j DNAT --to-destination 192.168.240.5:16000
        iptables -t nat -A PREROUTING -i wlp3s0 -p udp --dport 27900 -j DNAT --to-destination 192.168.240.5:27900
      '';
      allowedTCPPorts = [
        80
        61167
        1883 # MQTT
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
    teamviewer
    # Virtalisation.
    # virt-viewer
    # virt-manager
  ];

  # Set monitor position and force compositor pipeline to prevent screen tearing (nvidia).
  services = {
    xserver = {
      # Use non-free Nvidia drivers.
      videoDrivers = [ "nvidia" ];
      xrandrHeads = [ "DP-2" "DP-4" ];

      # Option "MetaModes" "DP-2: nvidia-auto-select +0+240 { }, DP-4: nvidia-auto-select +2560+0 { Rotation = Left }"
      screenSection = ''
        Option "MetaModes" "DP-4: nvidia-auto-select +0+0 { }"
        Option "FlatPanelProperties" "Dithering = Disabled"
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
      user = "thomas";
      virtualHosts = {
        "84.85.215.83" = {
          root = "/home/thomas/web";
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

    # teamviewer.enable = true;
    ratbagd.enable = true;
  };

  # Idle hdd automatically after timeout.
  systemd.services.hd-idle = {
    description = "HD spin-down";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 0 -a sdb -i 450";
    };
  };

  systemd.services.dynamic-dns = {
    description = "Update Dynamic DNS entry";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    startLimitIntervalSec = 300;
    startLimitBurst = 3;
    script = ''
      ${pkgs.curl}/bin/curl -6 "https://castor.he.uint.one:RaMgXhIWYQ2mCp3h8rRa@dyn.dns.he.net/nic/update?hostname=castor.he.uint.one"
    '';
  };

  systemd.timers.dynamic-dns = {
    wantedBy = [ "timers.target" ];
    partOf = [ "dynamic-dns.service" ];
    timerConfig.OnCalendar = "hourly";
  };

  # Virtualisation.
  # virtualisation.virtualbox.host = { enable = true; };
  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;
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

  # Remote-build user.
  users.users.remote-builder = {
    isSystemUser = true;
    useDefaultShell = true;
    openssh.authorizedKeys.keyFiles = [
      ../../keys/castor-remote-builder.pub
      ../../keys/root_argo_ed25519_key.pub
    ];
  };
  nix.trustedUsers = [ "remote-builder" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
