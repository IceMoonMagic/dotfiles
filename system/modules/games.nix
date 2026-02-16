{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  options.games = {
    all = lib.mkEnableOption "All Game Stuff";
    main = lib.mkEnableOption "Steam, Heroic, MangoHud, etc.";
    mods = lib.mkEnableOption "Mod Managers";
    minecraft = lib.mkEnableOption "Prism Launcher";
    nintendo = lib.mkEnableOption "Nintendo Stuff";
    autoGEProton = {
      enable = lib.mkEnableOption "Automatic Download of GE-Proton";
      directory = lib.mkOption {
        description = "Directory ot save Proton to.";
        type = lib.types.path;
      };
      frequency = lib.mkOption {
        description =
          "How often to check for an update, using systemd timespans;"
          + "see {manpage} `systemd.timer(5)` and {manpage} `systemd.time(7)`.";
        type = lib.types.str;
        default = "1week";
      };
    };
  };
  config = {
    games = {
      main = lib.mkDefault config.games.all;
      mods = lib.mkDefault config.games.all;
      minecraft = lib.mkDefault config.games.all;
      nintendo = lib.mkDefault config.games.all;
      autoGEProton.enable = lib.mkDefault config.games.main;
    };

    programs.steam = {
      enable = config.games.main;
      package = pkgs.steam.override {
        extraEnv.MANGOHUD = true;
        extraEnv.PROTON_ENABLE_WAYLAND = 1;
      };
    };
    /*
      services.joycond.enable = true;
      services.joycond.package = pkgs.joycond.overrideAttrs (old: {
        # Without: I couldn't use the joycons' motion as non-root
        # With: Cemuhook doesn't combine them, but motion is accessable
        version = "2025-04-12";
        src = pkgs.fetchFromGitHub {
          owner = "DanielOgorchock";
          repo = "joycond";
          rev = "39d5728d41b70840342ddc116a59125b337fbde2";
          sha256 = "sha256-VT433rrgZ6ltdXLQRjtjRy7rhMl1g9dan9SRqlsCPTk=";
        };
        installPhase = old.installPhase + ''
          substituteInPlace $out/etc/udev/rules.d/72-joycond.rules --replace \
            'TAG-="uaccess"' 'TAG+="uaccess"'

          rm $out/etc/udev/rules.d/89-joycond.rules
        '';
      });
      # programs.joycond-cemuhook.enable = true;
      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
      '';
    */
    environment.systemPackages =
      let
        mkConditionalList = (cond: builtins.map (value: lib.mkIf cond value));
      in
      with pkgs;
      lib.flatten [
        (mkConditionalList config.games.main [
          steamcmd
          heroic
          mangohud
          wine64
          protontricks
          protonup-qt
        ])
        (mkConditionalList config.games.mods [
          satisfactorymodmanager
          r2modman
        ])
        (mkConditionalList config.games.minecraft [
          prismlauncher
          mcaselector
        ])
        (mkConditionalList config.games.nintendo [
          dolphin-emu
          ryubing
          sshd-rando
        ])
      ];
    systemd.timers.ge-proton-update = lib.mkIf config.games.autoGEProton.enable {
      enable = config.games.autoGEProton.enable;
      description = "Automatically update GE-Proton";
      timerConfig = {
        OnUnitActiveSec = config.games.autoGEProton.frequency;
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };
    systemd.services.ge-proton-update = lib.mkIf config.games.autoGEProton.enable {
      description = "Automatically update GE-Proton";
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig.Type = "oneshot";
      path = with pkgs; [
        curl
        gnutar
        zstd
      ];
      environment.PROTON_DIR = config.games.autoGEProton.directory;
      script = ''
        set -euo pipefail

        dir="$PROTON_DIR"
        echo proton directory: $dir
        githubReleaseUrl="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest"

        echo fetching latest release info
        latestRelease=$(curl --silent $githubReleaseUrl)
        version=$(echo "$latestRelease" | grep tag_name | cut -d\" -f4)
        echo latest Version: $version

        echo checking if already installed
        # Skip if latest is already installed
        if [ -d "$dir/$version" ]; then
            echo - $version already installed, done
            exit 0;
        fi

        echo ensuring existance of $dir
        mkdir -p "$dir"

        download_url=$(echo "$latestRelease" | grep --fixed-strings "$version.tar.zst" | tail -1 | cut -d\" -f4)
        echo downloading and extracting $download_url
        tar --extract --zstd --directory "$dir" --group=users \
            --file <(curl --location "$download_url" --output -)

        echo updating group and permissions
        chgrp users "$dir/$version" --recursive
        chmod g=u "$dir/$version" --recursive

        echo updating GE-Proton-latest symlink
        ln --force --symbolic --relative --no-dereference \
            "$dir/$version" "$dir/GE-Proton-latest"
        # Alternatively, update Steam's config
        # File: ~/.local/share/Steam/config/config.vdf
        # Find: "0"\n\s*?{\n\s*?"name"\s*?"(GE-Proton\d+?-\d+?)"

        # Remove all but N newest versions of GE-Proton
        toRemove=$(
            find "$dir" -name 'GE-Proton[0-9]*-[0-9]*' |
            sort --version-sort |
            head --lines=-2
        ) || true  # Ignore potential errors
        if [ -n "$toRemove" ]; then
            echo removing older GE-Protons
            echo $toRemove
            echo $toRemove | xargs --delimiter='\n' -- rm --recursive;
        fi
      '';
    };
  };
}
