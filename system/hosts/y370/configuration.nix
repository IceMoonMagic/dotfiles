{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "icemoon-y370";

  users.users.roboticat = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  home-manager.users.roboticat = ../../../home/home.nix;

  services.sshd.enable = true;
}
