{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../base.nix
  ];

  networking.hostName = "pseudo-aurora";
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.package = pkgs.openrgb-with-all-plugins;
  # Keyboard: `Key: \ (ISO)` & `Key: #` Don't exist on device
  # Motherboard:
  #  RGB LED 1: Unused
  #  ARGB 1:
  #    Bottom Fans
  #    1-9: Fans Blades + Some Frame
  #    10-68: Fan Frame (Clockwise)
  #    69-80: Unused
  #  ARGB 2:
  #    AIO CPU Block
  #    1-16: Ring (Clockwise)
  #    17-80: Unused
  #  PCB:
  #    Can technically see through front of case. Just turn off given hard to see without looking for.
  #    1: Next to GPU Slot? Sorta glows between CPU and GPU
  #    2: Below middle of GPU? Hardly glows onto rear bottom fan (hidden by fans' lights and GPU)
  #    3: Behind lower case fans. Basically doesn't glow.
  #    4: Somewhere below 5. Glows through GPU (hidden by PSU from seat)
  #    5: Next to RAM Slots? Glows right below RAM (hidden by PSU from seat)
  #  ARGB 3:
  #    Top Fans
  #    1-9: Fans Blades + Some Frame
  #    10-52: Fan Frame (Counter Clockwise)
  #    53-80: Unused

  users.users.roboticat = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  home-manager.users.roboticat = ../../home/home.nix;

  games.all = true;
  games.autoGEProton.directory = "/mnt/sda/games/Wine/compatibilitytools.d/";
  headsets.enable = true;
  headsets.chatmix = true;

  #   virtualisation.docker.rootless.enable = true;
  #   virtualisation.docker.rootless.setSocketVariable = true;
  #   users.extraGroups.docker.members = [ "roboticat" ];
}
