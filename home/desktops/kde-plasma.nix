{ config, pkgs, ... }:

{
  # https://github.com/nix-community/plasma-manager
  #programs.kate.enable = true;
  xdg.dataFile."konsole.desktop" = {
    # Make Dolphin's "Open Terminal Here" open a new konsole tab
    source = pkgs.substitute {
      src = "${pkgs.kdePackages.konsole}/share/applications/org.kde.konsole.desktop";
      substitutions = [
        "--replace-quiet"
        "\nTryExec=konsole\nExec=konsole\n"
        "\nExec=konsole --new-tab\n"
      ];
    };
    target = "applications/org.kde.konsole.desktop";
  };
  xdg.dataFile."global.desktop" = {
    # Dolphin tries to delete this file, but the values do seem to work
    text = ''
      [Settings]
      HiddenFilesShown=true

      [Dolphin]
      ViewMode=1
      SortFoldersFirst=true
      SortHiddenLast=true
    '';
    target = "dolphin/view_properties/global/.directory";
  };
  xdg.dataFile."dolphinui.rc" = {
    source = ./dolphinui.rc;
    target = "kxmlgui5/dolphin/dolphinui.rc";
  };
  xdg.dataFile."haruna/recent-files.conf".text = "";
  programs.ghostwriter = {
    enable = true;
    package = null;
    editor.typing.bulletPointCycling = false;
  };
  #xdg.desktopEntries."org.kde.konsole".exec = "konsole --new-tab";
  programs.konsole = {
    enable = true;
    extraConfig."FileLocation" = {
      RememberWindowSize = false;
      UseSingleInstance = true;
    };
    extraConfig."MainWindow"."RestorePositionForNextInstance" = false;
  };
  programs.okular = {
    enable = true;
    package = null;
    general.openFileInTabs = true;
  };
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    kscreenlocker = {
      autoLock = false;
      lockOnResume = true;
    };
    powerdevil.AC = {
      powerProfile = "performance";
      autoSuspend.action = "nothing";
      powerButtonAction = "showLogoutScreen";
      whenLaptopLidClosed = "turnOffScreen";
      dimDisplay.enable = true;
      dimDisplay.idleTimeout = 300; # 5 Minutes
      turnOffDisplay.idleTimeout = "never";
    };
    spectacle.shortcuts = {
      captureRectangularRegion = [
        "Meta+Shift+S"
      ];
      recordWindow = [ ];
    };
    krunner.historyBehavior = "disabled";
    kwin = {
      cornerBarrier = false;
      edgeBarrier = 0;
    };
    workspace.colorScheme = "BreezeDark";
    shortcuts = {
      "services/org.kde.konsole.desktop"."NewTab" = "Ctrl+Alt+T";
      "services/org.kde.konsole.desktop"."_launch" = [ ];
    };
    #     input.mice."Logitech G305" = {
    #       enable = true;
    #       accelerationProfile = "none";
    #     };
    #input.mice.*.accelerationProfile = "none";
    input.keyboard.numlockOnStartup = "on";
    file."${builtins.replaceStrings [ (config.home.homeDirectory + "/") ] [ "" ]
      "${config.xdg.dataHome}/dolphinstaterc"
    }"."State"."RestorePositionForNextInstance" =
      false;
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "dolphinrc"."General" = {
        "BrowseThroughArchives" = true;
        "ConfirmClosingMultipleTabs" = false;
        "EditableUrl" = true;
        "FilterBar" = true;
        "OpenExternallyCalledFolderInNewTab" = true;
        "RememberOpenedTabs" = false;
        "ShowFullPath" = true;
      };
      #"kcminputrc"."Keyboard"."NumLock" = 0;
      #"kcminputrc"."Libinput/1133/16500/Logitech G305"."Enabled" = true;
      #"kcminputrc"."Libinput/1133/16500/Logitech G305"."PointerAccelerationProfile" = 1;
      #"kcminputrc"."Libinput/1133/49284/Logitech G203 Prodigy Gaming Mouse"."PointerAccelerationProfile" = 1;
      #"kcminputrc"."Libinput/1133/49284/Logitech G203 Prodigy Gaming Mouse Keyboard"."Enabled" = false;
      #"kcminputrc"."Mouse"."X11LibInputXAccelProfileFlat" = true;
      #"kcminputrc"."Mouse"."XLbInptAccelProfileFlat" = true;
      #"kcminputrc"."Mouse"."XLbInptPointerAcceleration" = 0;
      "kded5rc"."Module-browserintegrationreminder"."autoload" = false;
      "kded5rc"."Module-device_automounter"."autoload" = false;
      "kdeglobals"."General"."fixed" = "NotoMono Nerd Font,10,-1,5,50,0,0,0,0,0";
      "kdeglobals"."General"."toolBarFont" = "Noto Sans,10,-1,5,50,0,0,0,0,0";
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = true;
      #"kdeglobals"."KFileDialog Settings"."Speedbar Width" = 105;
      "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";
      #"kdeglobals"."KScreen"."ScreenScaleFactors" = "DP-0.8=1;DVI-D-0=1;HDMI-0=1;DP-0=1;DP-1=1;";
      #"kdeglobals"."Sounds"."Theme" = "oxygen";
      #"krunnerrc"."General"."HistoryEnabled" = false;
      #"krunnerrc"."General"."historyBehavior" = "Disabled";
      "krunnerrc"."PlasmaRunnerManager"."migrated" = true;
      "krunnerrc"."Plugins"."baloosearchEnabled" = false;
      "krunnerrc"."Plugins"."browserhistoryEnabled" = false;
      "krunnerrc"."Plugins"."browsertabsEnabled" = false;
      "krunnerrc"."Plugins"."helprunnerEnabled" = false;
      "krunnerrc"."Plugins"."krunner_appstreamEnabled" = false;
      "krunnerrc"."Plugins"."krunner_bookmarksrunnerEnabled" = false;
      "krunnerrc"."Plugins"."krunner_katesessionsEnabled" = false;
      "krunnerrc"."Plugins"."krunner_konsoleprofilesEnabled" = false;
      "krunnerrc"."Plugins"."krunner_kwinEnabled" = false;
      "krunnerrc"."Plugins"."krunner_plasma-desktopEnabled" = false;
      "krunnerrc"."Plugins"."krunner_recentdocumentsEnabled" = false;
      "krunnerrc"."Plugins"."krunner_sessionsEnabled" = false;
      "krunnerrc"."Plugins"."krunner_webshortcutsEnabled" = false;
      "krunnerrc"."Plugins"."locationsEnabled" = true;
      "krunnerrc"."Plugins"."windowsEnabled" = false;
      "krunnerrc"."Plugins/Favorites"."plugins" = "krunner_services";
      "kwinrc"."Effect-overview"."BorderActivate" = 9; # Disable TopLeftCorner triggering Overview
      #"ktrashrc"."\\/home\\/roboticat\\/.local\\/share\\/Trash"."Days" = 7;
      #"ktrashrc"."\\/home\\/roboticat\\/.local\\/share\\/Trash"."LimitReachedAction" = 1;
      #"ktrashrc"."\\/home\\/roboticat\\/.local\\/share\\/Trash"."Percent" = 5;
      #"ktrashrc"."\\/home\\/roboticat\\/.local\\/share\\/Trash"."UseSizeLimit" = true;
      #"ktrashrc"."\\/home\\/roboticat\\/.local\\/share\\/Trash"."UseTimeLimit" = true;
      #"ktrashrc"."\\/run\\/media\\/roboticat\\/FE0B-2B1D\\/.Trash-1000"."Days" = 7;
      #"ktrashrc"."\\/run\\/media\\/roboticat\\/FE0B-2B1D\\/.Trash-1000"."LimitReachedAction" = 0;
      #"ktrashrc"."\\/run\\/media\\/roboticat\\/FE0B-2B1D\\/.Trash-1000"."Percent" = 10;
      #"ktrashrc"."\\/run\\/media\\/roboticat\\/FE0B-2B1D\\/.Trash-1000"."UseSizeLimit" = true;
      #"ktrashrc"."\\/run\\/media\\/roboticat\\/FE0B-2B1D\\/.Trash-1000"."UseTimeLimit" = false;
      #"ktrashrc"."\\/run\\/user\\/1000\\/Discreet\\/.local\\/share\\/Trash"."Days" = 7;
      #"ktrashrc"."\\/run\\/user\\/1000\\/Discreet\\/.local\\/share\\/Trash"."LimitReachedAction" = 0;
      #"ktrashrc"."\\/run\\/user\\/1000\\/Discreet\\/.local\\/share\\/Trash"."Percent" = 10;
      #"ktrashrc"."\\/run\\/user\\/1000\\/Discreet\\/.local\\/share\\/Trash"."UseSizeLimit" = true;
      #"ktrashrc"."\\/run\\/user\\/1000\\/Discreet\\/.local\\/share\\/Trash"."UseTimeLimit" = false;
    };
    dataFile = { };
    panels = [
      {
        lengthMode = "fill";
        height = 48;
        screen = "all";
        widgets = [
          "org.kde.plasma.kickoff"
          {
            iconTasks.launchers = [
              #"applications:org.kde.plasma-systemmonitor.desktop"
              "applications:io.missioncenter.MissionCenter.desktop"
              "preferred://filemanager"
              "preferred://browser"
              "preferred://terminal"
              "applications:vesktop.desktop"
              "applications:org.pipewire.Helvum.desktop"
              "applications:steam.desktop"
              "applications:com.heroicgameslauncher.hgl.desktop"
              #"applicatiosn:md.obsidian.Obsidian.deskop"
            ];
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray = {
              items.hidden = [
                "org.kde.plasma.brightness"
                "org.kde.kdeconnect"
                "org.kde.plasma.addons.katesessions"
                #"martchus.syncthingplasmoid"
              ];
            };
          }
          {
            digitalClock = {
              date.enable = true;
              date.format = "isoDate";
            };
          }
        ];
      }
    ];
  };
}
