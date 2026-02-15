{ lib, ... }:
{
  # Disable mouse acceleration
  services.libinput.mouse.accelProfile = lib.mkDefault "flat";
}
