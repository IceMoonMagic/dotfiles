{
  inputs,
  lib,
  registry,
  ...
}:
{
  # Configure Home Manager
  home-manager.backupFileExtension = lib.mkDefault "hm-bak";
  home-manager.useGlobalPkgs = lib.mkDefault true;
  home-manager.useUserPackages = lib.mkDefault true;
  home-manager.extraSpecialArgs = lib.mkDefault [
    inputs
    registry
  ];
  # home-manager.sharedModules = [ homeModules ];
}
