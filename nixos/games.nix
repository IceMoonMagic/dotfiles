{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv.MANGOHUD = true;
      extraEnv.PROTON_ENABLE_WAYLAND = 1;
    };
  };
  environment.systemPackages = with pkgs; [
    steamcmd
    heroic
    mangohud
    wine64
    protontricks
    protonup-qt
    satisfactorymodmanager
    r2modman
  ];
}
