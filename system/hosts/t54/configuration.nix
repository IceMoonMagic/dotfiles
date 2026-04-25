{ config, inputs, ... }:

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
  home-manager.users.roboticat = {
    imports = [
      ../../../home/base.nix
      ../../../home/accounts/icemoon.git.nix
      ../../../home/accounts/roboticat.home.nix
    ];
  };
  nix.settings.trusted-users = [ "roboticat" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.sshd.enable = true;

  networking.firewall.allowedUDPPorts = [ 7777 ];
  # networking.nat.enable;
  containers.abiotic-server = {
    autoStart = true;
    # privateNetwork = true;
    # forwardPorts = [
    #   {
    #     hostPort = 53;
    #     protocol = "udp";
    #   }
    #   {
    #     hostPort = 7777;
    #     protocol = "udp";
    #   }
    #   {
    #     hostPort = 27015;
    #     protocol = "udp";
    #   }
    # ];
    ephemeral = true;
    bindMounts = {
      "/opt/Games/AbioticFactor" = {
        hostPath = "/opt/Games/AbioticFactor";
        isReadOnly = false;
      };
      "/root/Steam" = {
        hostPath = "/opt/Games/AbioticFactor/.steam";
      };
    };
    config =
      { ... }:
      {
        imports = [
          ../../modules/defaults/defaultContainer.nix
          inputs.extra-flakes.nixosModules.abiotic-server
        ];
        services.abiotic-server = {
          enable = true;
          gameDirectory = "/opt/Games/AbioticFactor";
          launchArgs.serverPassword = "AK47";
          launchArgs.worldSaveName = "Side7";
        };
        networking.useHostResolvConf = false;
        services.resolved.enable = true;
      };
  };
}
