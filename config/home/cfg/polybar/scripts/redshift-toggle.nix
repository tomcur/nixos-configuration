with import <nixpkgs> {};

writeScriptBin "redshift-toggle" ''
  ${systemd}/bin/systemctl --user is-active --quiet redshift

  if [ $? -eq 0 ]; then
    ${systemd}/bin/systemctl --user stop redshift
  else
    ${systemd}/bin/systemctl --user start redshift
  fi
''
