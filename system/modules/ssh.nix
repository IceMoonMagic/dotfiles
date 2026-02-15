{
  config,
  lib,
  options,
  ...
}:

{
  options = {
    sshd = options.services.openssh.enable;
    sshKeys.roboticat = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  config = {
    # Enable the OpenSSH daemon.
    services.openssh = {
      # enable = lib.mkDefault true;
      startWhenNeeded = lib.mkDefault true;
      authorizedKeysInHomedir = lib.mkDefault false;
      settings.PasswordAuthentication = lib.mkDefault false;
      settings.PermitRootLogin = lib.mkDefault "no";
    };

    users.users.roboticat.openssh.authorizedKeys.keys =
      lib.mkIf (config.sshd && config.sshKeys.roboticat)
        [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC6M1UmUYgvYyoeBskZf1r5dG9vAp95FThjMG6ysy70W roboticat@pseudo-aurora"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMeY+Y64S9L6wJmGIc2oPIApS3YHRuXX8xpApKHiYsvk roboticat@icemoon-y370"
        ];
  };
}
