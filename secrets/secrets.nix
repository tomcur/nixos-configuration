let
  thomas-nix-secrets = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICJUMKDRMG0StBe9aQcflsABxkvVaPAfouWDQZSrJxgz";
  castor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHf5T3tPtyM5Rqni8htbS6dc68DML15lmR9R2eBFAYvQ";
in {
  "email-thomas-churchman-nl.age".publicKeys = [ thomas-nix-secrets castor ];
  "email-thomas-kepow-org.age".publicKeys = [ thomas-nix-secrets castor ];
}
