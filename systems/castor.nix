{ config, pkgs, ...}:

{
  imports = [
    ../common.nix
  ];

  # NTFS drive.
  fileSystems."/mnt/q" = {
    device = "/dev/disk/by-uuid/0E3CC6AE3CC6905F";
    fsType = "ntfs-3g";
  };

  networking = {
    hostName = "castor";
  };

  environment.systemPackages = with pkgs; [
    # Drives.
    gparted
    hd-idle
    # Big applications.
    teamviewer
  ];

  # Set monitor position and force compositor pipeline to prevent screen tearing (nvidia).
  services.xserver = {
    # Use non-free Nvidia drivers.
    videoDrivers = [ "nvidiaBeta" ];
    xrandrHeads = [ "DP-4" "DVI-D-0" ];

    screenSection = ''
      Option "metamodes" "DP-4: nvidia-auto-select +0+0 { ForceCompositionPipeline = On }, DVI-D-0: nvidia-auto-select +1920+150 { ForceCompositionPipeline = On }"
    '';
  };

  # services.teamviewer.enable = true;

  # Idle hdd automatically after timeout.
  systemd.services.hd-idle = {
    description = "HD spin-down";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 0 -a sdb -i 450";
    };
  };

  # Disable onboard audio.
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
    options snd_hda_intel enable=0,0
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
