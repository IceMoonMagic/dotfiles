{ lib, ... }:
{
  networking.networkmanager.enable = lib.mkDefault true;
  networking.nameservers = [
    # Quad9
    "9.9.9.9"
    "149.112.112.112"
    # Cloudflare
    "1.1.1.1"
    "1.0.0.1"
  ];
  # networking.resolvconf.enable = false;
  networking.dhcpcd.enable = false;
  #   services.netbird.enable = true;
}
