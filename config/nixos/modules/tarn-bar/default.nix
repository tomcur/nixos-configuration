{ lib
, runCommand
, writeShellApplication
, tarn
, eww
, jq
, util-linux
, coreutils
, gnugrep
}:
let
  get-workspaces = writeShellApplication {
    name = "tarn-get-workspaces";
    runtimeInputs = [ tarn jq ];
    text = builtins.readFile ./get-workspaces;
  };

  ewwConfig = runCommand "tarn-eww-config" { } ''
    mkdir -p $out
    cp ${./eww.scss} $out/eww.scss
    substitute ${./eww.yuck} $out/eww.yuck \
      --subst-var-by tarn ${lib.getExe tarn} \
      --subst-var-by tarnTitle ${lib.getExe' tarn "tarn-title"} \
      --subst-var-by getWorkspaces ${lib.getExe get-workspaces}
  '';
in
writeShellApplication {
  name = "tarn-launch-bars";
  runtimeInputs = [ tarn eww jq util-linux coreutils gnugrep ];
  # No errexit: a failing eww call must not end the loop that keeps bars open.
  bashOptions = [ "nounset" "pipefail" ];
  runtimeEnv.TARN_EWW_CONFIG = ewwConfig;
  text = builtins.readFile ./launch-bars;
  passthru = { inherit ewwConfig; };
}
