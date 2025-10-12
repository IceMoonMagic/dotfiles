{ config, pkgs, ... }:

{
  # ToDo: Find way to set which folder should be synced to "this" device,
  # as this sets all of them to be made, just who to sync it with.
  home.packages = [ pkgs.syncthingtray ];
  services.syncthing = {
    enable = true;
    #tray.enable = true;
    #tray.package = pkgs.syncthingtray;
    settings.folders = {
      "Projects" = {
        id = "X201E-Projects";
        label = "Projects";
        path = "~/Projects";
        type = "sendreceive";
        devices = [
          "X201E"
          "T54"
          "Pseduo Aurora"
          "Y370"
        ];
      };
      "Mods" = {
        id = "X201E-Mods";
        label = "Mods";
        path = "~/Games/Mods";
        type = "sendreceive";
        devices = [
          "X201E"
          "T54"
          "Pseduo Aurora"
        ];
      };
    };
    settings.devices = {
      "X201E".id = "5W7WFI3-R26ENXL-QL6IOJE-TKMWLMH-5R6CAHN-C2HXOF7-N7TMTGG-VFIUNAW";
      "T54".id = "2IUACYR-PTA7BZT-YR6CLOR-IKLPVJY-LXZQ337-S5HJJW2-QG53HQA-TFM2XQL";
      "Pseduo Aurora".id = "LTOHBWQ-DNC5T45-JJGORGT-QYSXEOI-USCNKHT-K4EMF7T-TQ52LJ5-SYACMAJ";
      "Y370".id = "F3I6AYM-MC7JXOD-2INCSSN-7E3AWUG-76ZS4UW-TA6FYU5-TVX2K5Y-SVO73Q5";
    };
  };
}
