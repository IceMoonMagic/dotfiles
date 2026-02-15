{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    headsets.enable = lib.mkEnableOption "Headset Control";
    headsets.chatmix = lib.mkEnableOption "Nova Chatmix";
  };
  config = {
    environment.systemPackages =
      with pkgs;
      lib.flatten [
        (builtins.map (value: lib.mkIf config.headsets.enable value) [
          headsetcontrol
          headset-charge-indicator
        ])
      ];

    services.udev.packages = [
      (lib.mkIf config.headsets.enable pkgs.headsetcontrol)
    ];
    services.nova-chatmix.enable = lib.mkDefault config.headsets.chatmix;
  };
}
