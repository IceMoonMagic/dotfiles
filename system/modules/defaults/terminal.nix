{ lib, pkgs, ... }:
{
  # Enable Zsh
  # Main zsh configuration done via home-manager
  programs.zsh = {
    enable = lib.mkDefault true;
    enableCompletion = lib.mkDefault true;
    enableBashCompletion = lib.mkDefault true;
  };
  users.defaultUserShell = lib.mkOverride 999 pkgs.zsh;
}
