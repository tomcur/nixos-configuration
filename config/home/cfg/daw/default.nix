{ inputs, pkgs, stablePkgs, config, ... }:
let
  # systemLibOverlay = self: super: {
  #   pulseaudio = pkgs.pulseaudio;
  #   libjack2 = pkgs.libjack2;
  #   jack2 = pkgs.jack2;
  #   # gtk2 = pkgs.gtk2;
  #   # gtk3 = pkgs.gtk3;
  #   # qt5 = pkgs.qt5;
  #   # qt5.qtbase = pkgs.qt5.qtbase;
  #   # python2 = pkgs.python2;
  #   # python2Packages = pkgs.python2Packages;
  #   # python3 = pkgs.python3;
  #   # python3Packages = pkgs.python3Packages;
  # };
  bitwigOverlay = self: super: {
    bitwig-studio4 = super.pkgs.callPackage ./bitwig-studio4.nix { };
  };
  pkgsWithBitwig = import inputs.stable {
    system = pkgs.stdenv.hostPlatform.system;
    overlays = [ bitwigOverlay ];
    inherit (pkgs) config;
  };
  # unstable = import inputs.unstable {
  #   system = pkgs.stdenv.hostPlatform.system;
  #   overlays = [ systemLibOverlay ];
  #   inherit (pkgs) config;
  # };
  # master = import inputs.patched {
  #   system = pkgs.stdenv.hostPlatform.system;
  #   overlays = [ systemLibOverlay ];
  #   inherit (pkgs) config;
  # };
in
{
  home.sessionVariables =
    let genPath = dir: "$HOME/.${dir}:$HOME/.nix-profile/lib/${dir}:/etc/profiles/per-user/$USERNAME/lib/${dir}:/run/current-system/sw/lib/${dir}";
    in
    {
      DSSI_PATH = genPath "dssi";
      LADSPA_PATH = genPath "ladspa";
      LV2_PATH = genPath "lv2";
      LXVST_PATH = genPath "lxvst";
      VST_PATH = genPath "vst";
      VST3_PATH = genPath "vst3";
    };
  home.packages = (with pkgsWithBitwig; [
    # Generic LV2
    jalv
    lilv
    # Synths
    stablePkgs.surge
    helm
    qsynth
    (zynaddsubfx.override {
      guiModule = "zest";
    })
    # LV2
    avldrums-lv2
    drumkv1
    fmsynth
    # LADSPA
    autotalent
    # DSSI
    xsynth_dssi
    # Collections
    zam-plugins
    lsp-plugins
    distrho
    (callPackage ./harrison-ava.nix { inherit inputs; })
    # Music programming language
    supercollider
    # DAW
    ardour
    bitwig-studio4
    (renoise.override {
      releasePath = "${inputs.renoise}/rns_331_linux_x86_64.tar.gz";
    })
    # Plugin host
    carla
  ]);
}
