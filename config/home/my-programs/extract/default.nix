# Adapted from
# https://askubuntu.com/questions/517891/
{ pkgs, ...}:
with pkgs; writeScriptBin "extract" ''
  #!/usr/bin/env bash
  DEFAULT_TARGET="."

  SCRIPTNAME=`basename "$0"`

  err() {
    printf >&2 "$SCRIPTNAME: $*\n"
    exit 1
  }

  ARC="$1"
  [[ -f $ARC ]] || err $"'$ARC' does not exist"
  ARC="$(readlink -f "$ARC")"

  read -p "Extract to [default: $DEFAULT_TARGET]: " TARGET
  [[ -z $TARGET ]] &&\
      TARGET="$DEFAULT_TARGET"
  [[ -d $TARGET ]] || err $"Directory '$TARGET' does not exist"
  [[ -w $TARGET ]] || err $"Permission denied: '$TARGET' is not writable"

  cd "$TARGET"
  case "$ARC" in
    *.tar.bz2) ${gnutar}/bin/tar xjf "$ARC"  ;;
    *.tar.gz)  ${gnutar}/bin/tar xzf "$ARC"  ;;
    *.bz2)     ${bzip2}/bin/bunzip2 "$ARC"   ;;
    *.rar)     ${unar}/bin/unar "$ARC"       ;;
    *.gz)      ${gzip}/bin/gunzip "$ARC"     ;;
    *.tar)     ${gnutar}/bin/tar xf "$ARC"   ;;
    *.tbz2)    ${gnutar}/bin/tar xjf "$ARC"  ;;
    *.tgz)     ${gnutar}/bin/tar xzf "$ARC"  ;;
    *.zip)     ${unzip}/bin/unzip "$ARC"     ;;
    *.Z)       ${gzip}/bin/uncompress "$ARC" ;;
    *.7z)      ${p7zip}/bin/7z x "$ARC"      ;;
    *)         echo "'$ARC' cannot be extracted by $SCRIPTNAME" ;; esac
''
