{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./minecraft-server.nix
  ];

  networking.hostName = "t54";

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  users.extraGroups.docker.members = config.users.groups.wheel.members;

  users.users.roboticat = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  home-manager.users.roboticat = ../../../home/home.nix;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
