{ lib, rustPlatform, fetchFromGitLab }:

rustPlatform.buildRustPackage rec {
  pname = "ristate";
  version = "unstable-2023-07-23";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = pname;
    rev = "92e989f26cadac69af1208163733e73b4cf447da";
    sha256 = "sha256-6slH7R6kbSXQBd7q38oBEbngaCbFv0Tyq34VB1PAfhM=";
  };

  cargoSha256 = "sha256-q20qKciiYziOsSkjpN/w2IhWnCo2M7O0cK3gJE8t51I=";

  meta = with lib; {
    description = "A river-status client written in Rust";
    homepage = "https://gitlab.com/snakedye/ristate";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
    mainProgram = "ristate";
  };
}
