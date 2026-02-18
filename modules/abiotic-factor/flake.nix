{
  description = "Abiotic Factor Dedicated Server";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
      getPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
    in
    {
      formatter = forEachSystem (system: (getPkgs system).nixfmt-tree);
      nixosModules = rec {
        default = abiotic-server;
        abiotic-server =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            options.services.abiotic-server = with lib; {
              enable = mkEnableOption "Abiotic Factor server";
              gameDirectory = mkOption {
                description = "Top level path to put game files";
                type = types.str;
                example = "/opt/games/AbioticFactor";
              };
              winePrefix = mkOption {
                description = "Location of wine prefix to use";
                type = types.str;
                default = config.services.abiotic-server.gameDirectory + "/pfx";
                example = "/opt/games/AbioticFactor/pfx";
              };
              autoUpdate = mkEnableOption "checking steam for updates before starting";
              # See https://github.com/DFJacob/AbioticFactorDedicatedServer/wiki/Technical-%E2%80%90-Launch-Parameters
              launchArgs =
                let
                  ifElseEmpty = cond: value: if cond then value else "";
                  ifNotNull = nullable: value: ifElseEmpty (!isNull nullable) value;
                in
                {
                  # consoleWindow = mkOption {
                  #   description = "Open server with visible console window";
                  #   type = types.bool;
                  #   default = false;
                  #   example = true;
                  #   apply = b: ifElseEmpty b "-log -newconsole";
                  # };
                  lanOnly = mkOption {
                    description = "Run the server as LAN Only";
                    type = types.bool;
                    default = false;
                    example = true;
                    apply = b: ifElseEmpty b "-LANOnly";
                  };
                  platformLimited = mkOption {
                    description = "Disable crossplay and only allow <service> users to access the server";
                    type =
                      with types;
                      nullOr (enum [
                        "PC"
                        "Playstation"
                        "Xbox"
                      ]);
                    default = null;
                    example = "PC";
                    apply = s: ifNotNull s "-PlatformLimited=\"${s}\"";
                  };
                  bindIp = mkOption {
                    description = "Make the server bind/listen to a specific IP address";
                    type = with types; nullOr str;
                    default = null;
                    apply = s: ifNotNull s "-MultiHome=\"${s}\"";
                  };
                  useLocalIps = mkOption {
                    description = "Make the server bind to local IPs";
                    type = types.bool;
                    default = false;
                    example = true;
                    apply = b: ifElseEmpty b "-UseLocalIPs";
                  };
                  usePerfThreads = mkOption {
                    description = "Whether to enable forcing the server to use performance threads on the CPU";
                    type = types.bool;
                    default = true;
                    example = false;
                    apply = b: ifElseEmpty b "-usepefthreads";
                  };
                  noAsyncLoadingThread = mkOption {
                    description = "Force the server to pause to load new assets/level sectors";
                    type = types.bool;
                    default = false;
                    example = true;
                    apply = b: ifElseEmpty b "-NoAsyncLoadingThread";
                  };
                  port = mkOption {
                    description = "The game port to use";
                    type = types.int;
                    default = 7777;
                    apply = i: "-PORT=${toString i}";
                  };
                  queryPort = mkOption {
                    description = "The port used for advertising the server on steam";
                    type = with types; nullOr int;
                    default = null;
                    example = 27015;
                    apply = i: ifNotNull i "-QUERYPORT=${toString i}";
                  };
                  serverPassword = mkOption {
                    description = "The password for users to join the server";
                    type = with types; nullOr str;
                    default = null;
                    apply = s: ifNotNull s "-ServerPassword=\"${s}\"";
                  };
                  adminPassword = mkOption {
                    description = "Enables users to become a whitelisted admin in-game by typing in the password";
                    type = with types; nullOr str;
                    default = null;
                    apply = s: ifNotNull s "-AdminPassword=\"${s}\"";
                  };
                  steamServerName = mkOption {
                    description = "The name of the server that will appear in the server browser";
                    type = with types; nullOr str;
                    default = null;
                    apply = s: ifNotNull s "-SteamServerName=\"${s}\"";
                  };
                  maxServerPlayers = mkOption {
                    description = "Max amount of players in the server, 1-24";
                    type = types.int;
                    default = 6;
                    apply = i: "-MaxServerPlayers=${toString i}";
                  };
                  worldSaveName = mkOption {
                    description = "The world save folder to use";
                    type = types.str;
                    default = "Cascade";
                    apply = s: "-WorldSaveName=\"${s}\"";
                  };
                  sandboxIniPath = mkOption {
                    description = "Override path for the SandboxSettings.ini config";
                    type = with types; nullOr str;
                    default = null;
                    apply = s: ifNotNull s "-SandboxIniPath=\"${s}\"";
                  };
                  adminIniPath = mkOption {
                    description = "Override path for the Admin.ini config";
                    type = with types; nullOr str;
                    default = null;
                    apply = s: ifNotNull s "-AdminIniPath=\"${s}\"";
                  };
                };
              # No Docs?
              adminConfig = { };
              # See https://github.com/DFJacob/AbioticFactorDedicatedServer/wiki/Technical-%E2%80%90-Sandbox-Options
              sandboxConfig = { };
            };
            config =
              let
                cfg = config.services.abiotic-server;
              in
              {
                systemd.services.abiotic-server = lib.mkIf cfg.enable {
                  description = "Abiotic Factor server";
                  wants = [ "network-online.target" ];
                  after = [ "network-online.target" ];
                  wantedBy = [ "default.target" ];
                  path = with pkgs; [
                    steamcmd
                    wine64
                  ];
                  environment = {
                    WINEPREFIX = cfg.winePrefix;
                    WINEDEBUG = "-all"; # Disable wine's messages to the console
                    GAME_DIR = cfg.gameDirectory;
                    AUTO_UPDATE = if cfg.autoUpdate then "" else "true";
                  };
                  script =
                    let
                      launchArgs = with lib; (concatStringsSep " " (attrValues cfg.launchArgs));
                    in
                    ''
                      # Install / update if configured to OR folder doesn't exist
                      if [ $AUTO_UPDATE -o ! -d "$GAME_DIR" ]; then
                        steamcmd +login anonymous \
                        +@sSteamCmdForcePlatformType windows \
                        +force_install_dir "$GAME_DIR" \
                        +app_update 2857200 +quit
                      fi

                      wine64 "$GAME_DIR/AbioticFactor/Binaries/Win64/AbioticFactorServer-Win64-Shipping.exe" \
                      ${launchArgs}
                    '';
                };
              };
          };
      };
    };
}
