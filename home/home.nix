{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./syncthing.nix
    ./desktops
    ./games/mangohud.nix
    ./games/vesktop.nix
    ./development/editors/vscode.nix
  ];

  home.username = "roboticat";
  home.homeDirectory = "/home/roboticat";

  programs.git = {
    enable = true;
    userName = "IceMoonMagic";
    userEmail = "icemoonmagic@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };

  # Packages where configs aren't important (or not saved yet...)
  home.packages = with pkgs; [
    obsidian
    # an office suite

    #sqlitebrowser
    #imhex
    #hyfetch
    #bruno
    #jetbrains.pycharm-community-bin

    #krita
    #gimp3
    #inkscape
    #obs-studio
    #tenacity

    #dolphin-emu
    #melonDS # or desmume
    #sunshine
  ];
}
