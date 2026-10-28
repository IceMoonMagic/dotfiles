{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.syncthing = {
    enable = true;
    tray.enable = true;
    tray.package = pkgs.syncthingtray;
    settings.folders =
      let
        syncFolder = id: path: ignorePatterns: {
          inherit id ignorePatterns;
          path = lib.mkDefault path;
          devices = lib.mkDefault (builtins.attrNames config.services.syncthing.settings.devices);
        };
      in
      {
        "Documents" = syncFolder "X201E-Documents" "~/Documents" [ ];
        "Projects" = syncFolder "X201E-Projects" "~/Projects" [
          "/local"
          "dist"
          "target"
          "node_modules"
          "Godot"
        ];
        "Godot" = syncFolder "X201E-Godot" "~/Projects/Godot" [ ".godot" ];
        "Mods" = syncFolder "X201E-Mods" "~/Games/Mods" [ ];
      };
    settings.devices = {
      "X201E".id = "5W7WFI3-R26ENXL-QL6IOJE-TKMWLMH-5R6CAHN-C2HXOF7-N7TMTGG-VFIUNAW";
      "T54".id = "2IUACYR-PTA7BZT-YR6CLOR-IKLPVJY-LXZQ337-S5HJJW2-QG53HQA-TFM2XQL";
      "Pseudo Aurora".id = "LTOHBWQ-DNC5T45-JJGORGT-QYSXEOI-USCNKHT-K4EMF7T-TQ52LJ5-SYACMAJ";
      "Y370".id = "F3I6AYM-MC7JXOD-2INCSSN-7E3AWUG-76ZS4UW-TA6FYU5-TVX2K5Y-SVO73Q5";
      "Note9".id = "UPYLBUE-NEPAJG6-DVVZWYD-XQNXN42-JX6VZU5-RGM7BNR-7SST3PF-QST5LAY";
    };
  };
}
