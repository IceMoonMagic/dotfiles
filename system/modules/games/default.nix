{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./ge-proton-update.nix
    ./nintendo.nix
  ];
  options.games = {
    all = lib.mkEnableOption "All Game Stuff";
    main = lib.mkEnableOption "Steam, Heroic, MangoHud, etc.";
    mods = lib.mkEnableOption "Mod Managers";
    minecraft = lib.mkEnableOption "Prism Launcher";
    gacha = lib.mkEnableOption "Regrettable Decisions";
  };
  config = {
    games = {
      main = lib.mkDefault config.games.all;
      mods = lib.mkDefault config.games.all;
      minecraft = lib.mkDefault config.games.all;
      gacha = lib.mkDefault config.games.all;
    };

    programs.steam = {
      enable = config.games.main;
      package = pkgs.steam.override {
        extraEnv.MANGOHUD = true;
      };
      extest.enable = true;
    };
    environment.systemPackages =
      with pkgs;
      (lib.optionals config.games.main [
        steamcmd
        heroic
        mangohud
        wine64
        protontricks
        protonup-qt
      ])
      ++ (lib.optionals config.games.mods [
        satisfactorymodmanager
        r2modman
      ])
      ++ (lib.optionals config.games.minecraft [
        prismlauncher
        mcaselector
      ]);
    networking.extraHosts = lib.mkIf config.games.gacha ''
      # Gacha
      0.0.0.0 data-p.gryphline.com
      0.0.0.0 native-log-collect.gryphline.com
      0.0.0.0 eventlog.gryphline.com
      0.0.0.0 event-log-api-ipv6.gryphline.com
      0.0.0.0 event-log-api-data-platform-data-lake-prod.gryphline.com
    '';
  };
}
