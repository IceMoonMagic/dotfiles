{
  config,
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
  # nixpkgs.config = lib.mkIf (config.nix.package == null) { allowUnfree = true; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = !config.submoduleSupport.enable;

  # Be aware of XDG Base Directories
  xdg.enable = true;
  home.preferXdgDirectories = true;
  # Link `~/.nix-profile` to `$XDG_STATE_HOME/nix/profile`.
  # Home-manager sets home.profileDirectory to ~/.nix-profile
  # unless it's a nixos submodule or `nix.enable` && `nix.settings.use-xdg-base-directories`.
  # But if `nix.settings.use-xdg-base-directories = true;`
  # then "ignoring the client-specified setting 'use-xdg-base-directories',
  # because it is a restricted setting and you are not a trusted user".
  # See https://github.com/nix-community/home-manager/issues/5805
  home.file.".nix-profile" =
    # Errors if `home.file.".nix-profile".source = ...;`
    lib.mkIf (config.home.profileDirectory == config.home.homeDirectory + "/.nix-profile") {
      source = (config.lib.file.mkOutOfStoreSymlink "${config.xdg.stateHome}/nix/profile");
    };

  imports = [
    ./shells
    ./development/languages
  ];

  programs.gh.enable = true;
  programs.gh.gitCredentialHelper.enable = true;
}
