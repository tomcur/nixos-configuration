{ config, pkgs, ... }: {
  imports = [ ../common.nix ../audio-jack.nix ./castor-secret.nix ];

  # Enable gvt-g
  boot.kernelParams = [ "intel_iommu=on" "kvm.ignore_msrs=1" ];
  boot.kernelModules = [ "vfio" "vfio_pci" ];

  # Disable onboard audio and set vfio pci.
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
    options snd_hda_intel enable=0,0
    options vfio-pci ids=8086:1912
  '';

  # NTFS drive.
  fileSystems."/mnt/q" = {
    device = "/dev/disk/by-uuid/0E3CC6AE3CC6905F";
    fsType = "ntfs-3g";
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
        22000 # Syncthing listening
      ];
      allowedUDPPorts = [
        21027 # Syncthing ipv4 discovery and ipv6 multicasts
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    # Drives.
    gparted
    hd-idle
    # Big applications.
    teamviewer
  ];

  # Set monitor position and force compositor pipeline to prevent screen tearing (nvidia).
  services = {
    xserver = {
      # Use non-free Nvidia drivers.
      videoDrivers = [ "nvidia" ];
      xrandrHeads = [ "DP-4" "DVI-D-0" ];

      screenSection = ''
        Option "MetaModes" "DP-4: nvidia-auto-select +0+0 { ForceCompositionPipeline = On }, DVI-D-0: nvidia-auto-select +1920+150 { ForceCompositionPipeline = On }"
        Option "FlatPanelProperties" "Dithering = Disabled"
      '';
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

  # Virtualisation.
  virtualisation.virtualbox.host = { enable = true; };
  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;
  virtualisation.libvirtd = {
    enable = true;
    qemuVerbatimConfig = ''
      seccomp_sandbox = 0
    '';
  };

  boot.loader.systemd-boot.memtest86.enable = true;


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
