{ pkgs, ... }:
pkgs.writeScriptBin "transcode-opus" ''
  ${pkgs.parallel}/bin/parallel ${pkgs.opusTools}/bin/opusenc --bitrate 128 {} {.}.opus ::: "$@"
''
