{ lib, ... }:
{
  networking.networkmanager.enable = lib.mkDefault true;
  networking.networkmanager.dns = "none";
  networking.nameservers = [
    # Cloudflare
    "1.1.1.1"
    "2606:4700:4700::1111"
    "1.0.0.1"
    "2606:4700:4700::1001"
    # Quad9
    "9.9.9.9"
    "2620:fe::fe"
    "149.112.112.112"
    "2620:fe::9"
  ];
  services.netbird.enable = true;
}
