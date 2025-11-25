{ ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    authorizedKeysInHomedir = false;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };
  users.users.roboticat.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC6M1UmUYgvYyoeBskZf1r5dG9vAp95FThjMG6ysy70W roboticat@pseudo-aurora"
  ];
}
