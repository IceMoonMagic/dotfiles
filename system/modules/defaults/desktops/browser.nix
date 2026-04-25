{ lib, ... }:
{
  # Install firefox.
  programs.firefox.enable = lib.mkDefault true;
  # programs.firefox.policies = ./firefox-policies.json;
  programs.firefox.policies = {
    Homepage = "previous-session";
    AutofillAddressEnabled = false;
    AutofillCreditCard = false;
    OfferToSaveLoginsDefault = false;
    PromptForDownloadLocation = true;
    SearchEngines.Default = "DuckDuckGo";
    EnableTrackingProtection.Category = "strict";
    SanitizeOnShutdown = {
      Cache = true;
      Cookies = true;
      FormData = true;
    };
    Permissions = {
      Location.BlockNewRequests = true;
      Notifications.BlockNewRequests = true;
      Autoplay.Default = "block-audio-video";
    };
    PopupBlocking.Default = true;
    DisableTelemetry = true;
    HttpsOnlyMode = "enabled";
    ExtensionSettings = builtins.fromJSON ''
      {
      "addon@darkreader.org": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/addon@darkreader.org/latest.xpi",
        "private_browsing": true
      },
      "uBlock0@raymondhill.net": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/uBlock0@raymondhill.net/latest.xpi",
        "private_browsing": true
      },
      "{446900e4-71c2-419f-a6a7-df9c091e268b}": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/{446900e4-71c2-419f-a6a7-df9c091e268b}/latest.xpi"
      },
      "sponsorBlocker@ajay.app": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/sponsorBlocker@ajay.app/latest.xpi"
      }
      }
    '';
  };
}
