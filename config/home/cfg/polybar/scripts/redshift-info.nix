# Adapted from
# https://github.com/x70b1/polybar-scripts/blob/master/polybar-scripts/info-redshift-temp/info-redshift-temp.sh
with import <nixpkgs> {};

writeScriptBin "redshift-info" ''
  ${systemd}/bin/systemctl --user is-active --quiet redshift

  if [ $? -eq 0 ]; then
    temp=$(${redshift}/bin/redshift -p 2> /dev/null | ${gnugrep}/bin/grep temp | ${coreutils}/bin/cut -d ":" -f 2 | ${coreutils}/bin/tr -dc "[:digit:]")

    if [ -z "$temp" ]; then
        echo "unknown"
    else
        echo "''${temp}K"
    fi
  else
    echo "off"
  fi
''
