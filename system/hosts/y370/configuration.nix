{ lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "icemoon-y370";
  system.autoUpgrade.enable = false;
  system.autoUpgrade.viaGit.enable = lib.mkForce false;
  environment.systemPackages = with pkgs; [
    gimp
    inkscape
    krita
  ];

  users.users.roboticat = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  home-manager.users.roboticat = {
    imports = [
      ../../../home/base.nix
      ../../../home/desktops
      ../../../home/development/editors
      ../../../home/games
      ../../../home/accounts/icemoon.git.nix
      ../../../home/accounts/roboticat.home.nix
    ];
  };

  services.sshd.enable = true;
}
