{ lib, pkgs, ... }:

# macOS only: makes TextEdit a plain-text editor and the default application
# for text files.
let
  bundleId = "com.apple.TextEdit";
  # Content types (UTIs) and file extensions to open with TextEdit. More specific
  # types (e.g. `public.json`) don't inherit the handler of their parent types
  # (e.g. `public.plain-text`), so they're listed separately.
  types = [
    "public.plain-text"
    "public.text"
    "public.source-code"
    "public.script"
    "public.shell-script"
    "public.python-script"
    "public.ruby-script"
    "public.perl-script"
    "public.c-source"
    "public.c-header"
    "public.c-plus-plus-source"
    "public.json"
    "public.yaml"
    "public.xml"
    "public.log"
    "net.daringfireball.markdown"
    ".md"
    ".nix"
    ".toml"
    ".lua"
    ".rs"
    ".ts"
    ".conf"
  ];
  dutiSettings = pkgs.writeText "duti-textedit" (lib.concatMapStrings (type: "${bundleId} ${type} all\n") types);
in
{
  targets.darwin.defaults.${bundleId} = {
    # New documents are plain text rather than rich text.
    RichText = false;
    # UTF-8 when opening and saving plain-text files.
    PlainTextEncoding = 4;
    PlainTextEncodingForWrite = 4;
    # Don't mangle quotes and dashes in code.
    SmartQuotes = false;
    SmartDashes = false;
  };

  home.activation.setTextEditDefault = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${lib.getExe pkgs.duti} ${dutiSettings}
  '';
}
