{ config, lib, ... }:
{
  # Set your time zone.
  time.timeZone = lib.mkDefault "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = lib.mkDefault config.i18n.defaultLocale;
    LC_IDENTIFICATION = lib.mkDefault config.i18n.defaultLocale;
    LC_MEASUREMENT = lib.mkDefault config.i18n.defaultLocale;
    LC_MONETARY = lib.mkDefault config.i18n.defaultLocale;
    LC_NAME = lib.mkDefault config.i18n.defaultLocale;
    LC_NUMERIC = lib.mkDefault config.i18n.defaultLocale;
    LC_PAPER = lib.mkDefault config.i18n.defaultLocale;
    LC_TELEPHONE = lib.mkDefault config.i18n.defaultLocale;
    LC_TIME = lib.mkDefault config.i18n.defaultLocale;
  };
}
