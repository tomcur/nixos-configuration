{ config, pkgs, lib, ... }:
let
  getPasswordScript = secretFile:
    pkgs.writeShellScript "get-mail-pass" ''
      ${pkgs.coreutils}/bin/cat "${secretFile}"
    '';
  passwordCommandGen = secretFile: "${getPasswordScript secretFile}";
  sharedSettings = {
    realName = "Thomas Churchman";
    gpg = {
      key = "8A69EAFC868629C6D0FEE112D3A723E79C81A3A6";
    };
    mbsync = {
      enable = true;
      create = "maildir";
    };
    imapnotify.enable = true;
    imapnotify.boxes = [ "Inbox" ];
    imapnotify.onNotify = "systemctl start --user email-fetch.service";
    msmtp.enable = true;
    notmuch.enable = true;
    astroid.enable = true;
    neomutt.enable = true;
    imap = {
      host = "eagle.mxlogin.com";
      port = 993;
    };
    smtp = {
      host = "eagle.mxlogin.com";
      port = 587;
      tls = {
        enable = true;
        useStartTls = true;
      };
    };
  };
  deobfuscate = s: builtins.replaceStrings [ "^" "$" ] [ "@" "." ] s;
in
{
  accounts.email.accounts.thomas-churchman-nl = {
    primary = true;
    address = deobfuscate "thomas^churchman$nl";
    userName = deobfuscate "thomas^churchman$nl";
    passwordCommand = passwordCommandGen "/run/secrets/email-thomas-churchman-nl";
  } // sharedSettings;
  accounts.email.accounts.thomas-kepow-org = {
    address = deobfuscate "thomas^kepow$org";
    userName = deobfuscate "thomas^kepow$org";
    passwordCommand = passwordCommandGen "/run/secrets/email-thomas-kepow-org";
  } // sharedSettings;
}
