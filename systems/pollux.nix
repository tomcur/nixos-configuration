{ config, pkgs, ...}:

{
  imports = [
    ../common.nix
    ../audio-pulse.nix
  ];

  networking = {
    hostName = "pollux";
    firewall = {
      allowedTCPPorts = [
        22000 # Syncthing listening
      ];
      allowedUDPPorts = [
        21027 # Syncthing ipv4 discovery and ipv6 multicasts
      ];
    };
  };

  # Better for SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/8e7809f3-1c3e-4c8f-b4c1-0ba974202c76";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  environment.systemPackages = with pkgs; [
  ];

  services.xserver = {
    # Enable touchpad support.
    libinput.enable = true;
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';
  };
  services.acpid = {
    enable = true;
    handlers.headphone-hiss = {
      action = ''
        ${pkgs.alsaUtils}/bin/amixer -c0 sset 'Headphone Mic Boost' 10dB
      '';
      event = "jack/headphone HEADPHONE plug";
    };
  };
  hardware.brightnessctl.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
