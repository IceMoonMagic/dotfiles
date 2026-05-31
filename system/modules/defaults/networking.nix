{ lib, ... }:
{
  networking.networkmanager.enable = lib.mkDefault true;
  networking.networkmanager.dns = "none";
  networking.nameservers = [
    # Quad9
    "9.9.9.9"
    "149.112.112.112"
    # Cloudflare
    "1.1.1.1"
    "1.0.0.1"
  ];
  #   services.netbird.enable = true;
}
