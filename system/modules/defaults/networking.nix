{ lib, ... }:
{
  networking.networkmanager.enable = lib.mkDefault true;
  #   services.netbird.enable = true;
}
