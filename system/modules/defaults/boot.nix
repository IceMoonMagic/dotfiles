{ lib, ... }:
{
  # Bootloader
  boot.loader = {
    timeout = lib.mkDefault 0;
    systemd-boot.enable = lib.mkDefault true;
    efi.canTouchEfiVariables = lib.mkDefault true;
  };
}
