let
  thomas-nix-secrets = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICJUMKDRMG0StBe9aQcflsABxkvVaPAfouWDQZSrJxgz";
  castor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHf5T3tPtyM5Rqni8htbS6dc68DML15lmR9R2eBFAYvQ";
  router = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOya2rzqAYEKZE/zUfqp5v6uJrzsoponkjZ88mH9lV9x";
in {
  "email-thomas-churchman-nl.age".publicKeys = [ thomas-nix-secrets castor ];
  "email-thomas-kepow-org.age".publicKeys = [ thomas-nix-secrets castor ];
  "dyndns-castor.age".publicKeys = [ thomas-nix-secrets castor ];
  "mopidy-secret-config.age".publicKeys = [ thomas-nix-secrets castor ];
  # "mopidy-secret-config.age".publicKeys = [ thomas-nix-secrets castor ];
  "wireguard-router-private.age".publicKeys = [ router thomas-nix-secrets castor ];
}
