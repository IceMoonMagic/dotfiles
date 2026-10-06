{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.games.geProtonUpdate = {
    enable = lib.mkEnableOption "Automatic Download of GE-Proton";
    directory = lib.mkOption {
      description = "Directory to save Proton to.";
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
  config = {
    games.geProtonUpdate.enable = lib.mkDefault config.games.main;
    systemd.timers.ge-proton-update = lib.mkIf config.games.geProtonUpdate.enable {
      enable = config.games.geProtonUpdate.enable;
      description = "Automatically update GE-Proton";
      timerConfig = {
        OnUnitActiveSec = config.games.geProtonUpdate.frequency;
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };
    systemd.services.ge-proton-update = lib.mkIf config.games.geProtonUpdate.enable {
      description = "Automatically update GE-Proton";
      requires = [ "network-online.target" ];
      after = [
        "network-online.target"
        "default.target"
        "multi-user.target"
      ];
      serviceConfig.Type = "oneshot";
      path = with pkgs; [
        curl
        gnutar
        gzip
      ];
      environment.PROTON_DIR = config.games.geProtonUpdate.directory;
      script = ''
        set -euo pipefail

        dir="$PROTON_DIR"
        echo proton directory: $dir
        githubReleaseUrl="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest"
        suffix="-x86_64"

        echo fetching latest release info
        latestRelease=$(curl --silent $githubReleaseUrl)
        version=$(echo "$latestRelease" | grep tag_name | cut -d\" -f4)$suffix
        echo Latest Version: $version

        echo checking if already installed
        # Skip if latest is already installed
        if [ -d "$dir/$version" ]; then
            echo - $version already installed, done
            exit 0;
        fi

        echo ensuring existence of $dir
        mkdir -p "$dir"

        download_url=$(echo "$latestRelease" | grep --fixed-strings "$version.tar.gz" | tail -1 | cut -d\" -f4)
        echo downloading and extracting $download_url
        tar --extract --gzip --directory "$dir" --group=users \
            --file <(curl --location "$download_url" --output -)

        echo updating group and permissions
        chgrp users "$dir/$version" --recursive
        chmod g=u "$dir/$version" --recursive

        echo replacing GE-Proton-Latest
        rm --recursive --force "$dir/GE-Proton-Latest" || true
        cp --archive --reflink=auto "$dir/$version" "$dir/GE-Proton-Latest"
        sed -i "s/$version/GE-Proton-Latest/g" "$dir/GE-Proton-Latest/compatibilitytool.vdf"

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
