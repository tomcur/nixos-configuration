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

  useFetchCargoVendor = true;
  cargoHash = "sha256-6uvIc69x/yHkAC3GJUuYGcCbpVyX/mb/pXLf+BQC+48=";

  meta = with lib; {
    description = "A river-status client written in Rust";
    homepage = "https://gitlab.com/snakedye/ristate";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
    mainProgram = "ristate";
  };
}
