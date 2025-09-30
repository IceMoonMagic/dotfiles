{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../desktop.nix
    ../games.nix
  ];

  networking.hostName = "pseudo-aurora";
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.package = pkgs.openrgb-with-all-plugins;

  users.users.roboticat = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  home-manager.users.roboticat = ../../home/home.nix;

  #   virtualisation.docker.rootless.enable = true;
  #   virtualisation.docker.rootless.setSocketVariable = true;
  #   users.extraGroups.docker.members = [ "roboticat" ];
}
