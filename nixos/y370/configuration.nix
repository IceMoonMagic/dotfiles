{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../desktop.nix
  ];

  networking.hostName = "icemoon-y370";

  users.users.roboticat = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
