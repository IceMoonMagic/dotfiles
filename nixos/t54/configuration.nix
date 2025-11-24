{ lib }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../base.nix
  ];

  networking.hostName = "t54";

  services.openssh.enable = lib.mkForce true;

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  users.extraGroups.docker.members = [ "roboticat" ];

  users.users.roboticat = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  home-manager.users.roboticat = ../../home/home.nix;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
