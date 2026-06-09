{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "x201e";

  users.users.roboticat = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  home-manager.users.roboticat = {
    imports = [
      ../../../home/base.nix
      ../../../home/accounts/icemoon.git.nix
      ../../../home/accounts/roboticat.home.nix
    ];
  };

  system.autoUpgrade.allowReboot = true;

  services.sshd.enable = true;
  # services.opencloud.enable = true;

  # ToDo: OpenCloud + Radicale
  virtualisation.quadlets = {
    discord-bot.enable = true;
    home-assistant.enable = true;
  };
}
