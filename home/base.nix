{
  config,
  pkgs,
  lib,
  ...
}:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Allow unfree packages, only set if not using home-manager.useGlobalPkgs
  nixpkgs.config = lib.mkIf (config.nix.package == null) { allowUnfree = true; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = lib.mkIf (config.nix.package == null) true;

  # Be aware of XDG Base Directories
  xdg.enable = true;
  home.preferXdgDirectories = true;

  imports = [
    ./shells
    ./development/languages
  ];

  programs.gh.enable = true;
  programs.gh.gitCredentialHelper.enable = true;
}
