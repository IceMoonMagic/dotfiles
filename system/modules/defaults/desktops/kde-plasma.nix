{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = lib.mkDefault true;
  services.desktopManager.plasma6.enable = lib.mkDefault true;
  services.desktopManager.plasma6.notoPackage = lib.mkDefault pkgs.noto-fonts-lgc-plus;
  environment.systemPackages =
    with pkgs;
    (builtins.map (value: lib.mkIf config.services.desktopManager.plasma6.enable value) [
      kdePackages.kate
      kdePackages.filelight
      haruna
    ]);
}
