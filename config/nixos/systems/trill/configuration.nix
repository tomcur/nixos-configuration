{ config, pkgs, ... }: {
  imports = [
    ../../common.nix
    ../../audio-pipewire.nix
    ../../eduroam.nix
    ../../modules/river.nix
  ];

  programs.my-river-env.enable = true;

  networking = {
    hostName = "trill";
    firewall = {
      allowedTCPPorts = [
        22000 # Syncthing listening
      ];
      allowedUDPPorts = [
        21027 # Syncthing ipv4 discovery and ipv6 multicasts
      ];
    };
  };

  time.timeZone = "Europe/Amsterdam";

  zramSwap = {
    enable = true;
  };
  # TODO: also use swap partition? If so, encrypt that swap at boot with a random key.
  # swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  environment.systemPackages = with pkgs; [ ];

  # services.xserver = {
  #   # Enable touchpad support.
  #   libinput.enable = true;
  #   videoDrivers = [ "intel" ];
  #   xrandrHeads = [ "eDP1" "DP1" ];
  #   deviceSection = ''
  #     Option "TearFree" "true"
  #   '';
  # };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "24.11"; # Did you read the comment?
}
