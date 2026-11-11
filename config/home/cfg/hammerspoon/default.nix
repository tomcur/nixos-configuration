{ ... }:

# Hammerspoon isn't in nixpkgs, this expects it to be installed in /Applications.
{
  xdg.configFile."hammerspoon/init.lua".source = ./init.lua;
  targets.darwin.defaults."org.hammerspoon.Hammerspoon".MJConfigFile = "~/.config/hammerspoon/init.lua";

  launchd.agents.hammerspoon = {
    enable = true;
    config = {
      ProgramArguments = [ "/usr/bin/open" "-a" "Hammerspoon" ];
      RunAtLoad = true;
    };
  };
}
