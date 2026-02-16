{
  homeModules,
  lib,
  ...
}:
{
  # Configure Home Manager
  home-manager.backupFileExtension = lib.mkDefault "hm-bak";
  home-manager.useGlobalPkgs = lib.mkDefault true;
  home-manager.useUserPackages = lib.mkDefault true;
  home-manager.sharedModules = homeModules;
}
