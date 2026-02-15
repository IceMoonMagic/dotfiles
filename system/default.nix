{
  inputs,
  registry,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.nova-chatmix.nixosModules.nova-chatmix
    registry
    ./modules
  ];
}
