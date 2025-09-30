{ config, ... }:

{
  home.activation.heroic = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -L $HOME/.config/heroic ]; then
      if [ -e $HOME/.config/heroic ]; then
        run mv $VERBOSE_ARG $HOME/.config/heroic ${config.xdg.dataHome}/heroic
      fi
      run ln -s $VERBOSE_ARG ${config.xdg.dataHome}/heroic $HOME/.config/heroic
    fi
  '';
  home.file.".config/heroic/config.json".text = ''
    {
      "defaultSettings": {
        "checkUpdatesInterval": 10,
        "enableUpdates": false,
        "addDesktopShortcuts": false,
        "addStartMenuShortcuts": false,
        "autoInstallDxvk": true,
        "autoInstallVkd3d": true,
        "autoInstallDxvkNvapi": true,
        "addSteamShortcuts": true,
        "preferSystemLibs": false,
        "checkForUpdatesOnStartup": true,
        "autoUpdateGames": false,
        "customWinePaths": [],
        "defaultInstallPath": "${config.home.homeDirectory}/Games/Heroic",
        "libraryTopSection": "disabled",
        "defaultSteamPath": "${config.home.homeDirectory}/.steam/steam",
        "defaultWinePrefix": "${config.home.homeDirectory}/Games/Heroic/Prefixes",
        "hideChangelogsOnStartup": false,
        "language": "en",
        "maxWorkers": 0,
        "minimizeOnLaunch": false,
        "nvidiaPrime": false,
        "enviromentOptions": [],
        "wrapperOptions": [],
        "showFps": false,
        "useGameMode": false,
        "wineCrossoverBottle": "Heroic",
        "winePrefix": "${config.home.homeDirectory}/Games/Heroic/Prefixes/default",
        "wineVersion": {
          "bin": "${config.home.homeDirectory}/Games/Steam/steamapps/common/Proton - Experimental/proton",
          "name": "Proton - Proton - Experimental",
          "type": "proton"
        },
        "enableEsync": true,
        "enableFsync": true,
        "enableMsync": false,
        "eacRuntime": true,
        "battlEyeRuntime": true,
        "framelessWindow": false,
        "beforeLaunchScriptPath": "",
        "afterLaunchScriptPath": "",
        "disableUMU": false,
        "verboseLogs": false,
        "downloadProtonToSteam": true,
        "advertiseAvxForRosetta": false,
        "darkTrayIcon": false,
        "disablePlaytimeSync": false
      },
      "version": "v0"
    }
  '';
  home.file.".config/heroic/store/config.json".text = ''
    {
      "theme": "nord-dark",
      "settings": {
        "checkUpdatesInterval": 10,
        "enableUpdates": false,
        "addDesktopShortcuts": false,
        "addStartMenuShortcuts": false,
        "autoInstallDxvk": true,
        "autoInstallVkd3d": true,
        "autoInstallDxvkNvapi": true,
        "addSteamShortcuts": true,
        "preferSystemLibs": false,
        "checkForUpdatesOnStartup": true,
        "autoUpdateGames": false,
        "customWinePaths": [],
        "defaultInstallPath": "${config.home.homeDirectory}/Games/Heroic",
        "libraryTopSection": "disabled",
        "defaultSteamPath": "${config.home.homeDirectory}/.steam/steam",
        "defaultWinePrefix": "${config.home.homeDirectory}/Games/Heroic/Prefixes",
        "hideChangelogsOnStartup": false,
        "language": "en",
        "maxWorkers": 0,
        "minimizeOnLaunch": false,
        "nvidiaPrime": false,
        "enviromentOptions": [],
        "wrapperOptions": [],
        "showFps": false,
        "useGameMode": false,
        "wineCrossoverBottle": "Heroic",
        "winePrefix": "${config.home.homeDirectory}/Games/Heroic/Prefixes/default",
        "wineVersion": {
          "bin": "${config.home.homeDirectory}/Games/Steam/steamapps/common/Proton - Experimental/proton",
          "name": "Proton - Proton - Experimental",
          "type": "proton"
        },
        "enableEsync": true,
        "enableFsync": true,
        "enableMsync": false,
        "eacRuntime": true,
        "battlEyeRuntime": true,
        "framelessWindow": false,
        "beforeLaunchScriptPath": "",
        "afterLaunchScriptPath": "",
        "disableUMU": false,
        "verboseLogs": false,
        "downloadProtonToSteam": true,
        "advertiseAvxForRosetta": false,
        "darkTrayIcon": false,
        "disablePlaytimeSync": false
      },
      "contentFontFamily": "\"Noto Sans\"",
      "actionsFontFamily": "\"Noto Sans\""
    }
  '';
  #home.file.".config/heroic/gog_store/config.json".text = "";

}
