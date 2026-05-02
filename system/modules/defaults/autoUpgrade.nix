{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.system.autoUpgrade.viaGit = with lib; {
    enable = mkEnableOption "Pull from git";
    gitUrl = mkOption {
      description = "Url to git repository";
      type = types.str;
    };
    updateInputs = mkOption {
      description = "Flake inputs to update. All if empty";
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config =
    let
      cfg = config.system.autoUpgrade.viaGit;
      updateInputs = builtins.concatStringsSep " " cfg.updateInputs;
    in
    {
      system.autoUpgrade = {
        enable = lib.mkDefault true;
        # flake = lib.mkDefault "github:IceMoonMagic/dotfiles";
        flags = [ "--print-build-logs" ];
        viaGit = {
          enable = true;
          gitUrl = "https://github.com/IceMoonMagic/dotfiles.git";
        };
        dates = lib.mkDefault "08:00";
        randomizedDelaySec = lib.mkDefault "1h";
        persistent = lib.mkDefault true;
        runGarbageCollection = lib.mkDefault true;
      };

      # system.autoUpgrade seems to be in a weird spot rn w/ flakes...
      # See nixpkgs #349734 and nix #14653
      # Following is loosely derived from nixpkgs/issues/349734#issuecomment-4333993657
      system.autoUpgrade.flake = lib.mkIf cfg.enable (lib.mkForce "/tmp/nixos");
      systemd.services."nixos-upgrade" = lib.mkIf cfg.enable {
        path = [ pkgs.gitMinimal ];
        serviceConfig = {
          PrivateTmp = "yes";
          ExecStartPre = (
            pkgs.writeShellScript "upgrade-nixos-config" ''
              set -euo pipefail

              if [ ! -d /etc/nixos ]; then
                  # Clone if /etc/nixos doesn't exist
                  git clone --filter="blob:none" "${cfg.gitUrl}"
              fi

              if [ -d /etc/nixos ] \
              && origin=$(git -C /etc/nixos remote get-url origin) \
              && [ "$origin" = "${cfg.gitUrl}" ]
              then
                  # If /etc/nixos exists and is correct repo
                  git fetch origin main:main || true  # Ignore fail
                  git clone --shared --revision=origin/main /etc/nixos /tmp/nixos
              else
                  # Exists and is the wrong repo
                  git clone --filter="blob:none" --single-branch "${cfg.gitUrl}" /tmp/nixos
              fi
              nix flake update ${updateInputs} --flake /tmp/nixos
            ''
          );
        };
      };
    };
}
