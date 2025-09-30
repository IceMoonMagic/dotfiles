{ config, pkgs, ... }:

{
  imports = [
    ../desktop.nix
    ./hardware-configuration.nix
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
