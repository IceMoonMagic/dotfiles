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
    overrideFolders = true;
    overrideDevices = true;
    settings = {
      options.urAccepted = -1;
      folders =
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
      devices =
        let
          syncDevice = group: name: id: {
            ${name} = {
              inherit id group;
              compression = "always";
              addresses = [
                "tcp://${name}.snow.mesh" # Netbird DNS
              ];
            };
          };
        in
        (syncDevice "Server" "X201E" "B2IDJRJ-EUC2IRM-UUQHBNT-MDJXDAN-3HYKARU-AMVFKNX-2IQAFIN-NWLI6QJ")
        // (syncDevice "Server" "T54" "2IUACYR-PTA7BZT-YR6CLOR-IKLPVJY-LXZQ337-S5HJJW2-QG53HQA-TFM2XQL")
        // (syncDevice "Personal" "Pseudo-Aurora"
          "LTOHBWQ-DNC5T45-JJGORGT-QYSXEOI-USCNKHT-K4EMF7T-TQ52LJ5-SYACMAJ"
        )
        // (syncDevice "Personal" "IceMoon-Y370"
          "F3I6AYM-MC7JXOD-2INCSSN-7E3AWUG-76ZS4UW-TA6FYU5-TVX2K5Y-SVO73Q5"
        )
        // (syncDevice "Personal" "Note-9"
          "UPYLBUE-NEPAJG6-DVVZWYD-XQNXN42-JX6VZU5-RGM7BNR-7SST3PF-QST5LAY"
        );
    };
  };
}
