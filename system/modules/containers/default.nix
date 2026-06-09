{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virtualisation.quadlets;
  children = builtins.attrValues (builtins.removeAttrs cfg [ "enable" ]);
  enabled = builtins.any (child: child.enable) children;
in
with lib;
{
  imports = [
    ./discord-bot.nix
    ./home-assistant.nix
  ];
  options.virtualisation.quadlets.enable = mkEnableOption "Podman quadlet services";
  config = {
    virtualisation.quadlets.enable = mkIf enabled (mkForce true);
    virtualisation.podman.enable = mkIf cfg.enable true;
    virtualisation.podman.dockerCompat = mkIf cfg.enable true;
    environment.systemPackages =
      with pkgs;
      optionals cfg.enable [
        podlet
        podman
        podman-compose
      ];
    systemd.targets.quadlets.wantedBy = [ "multi-user.target" ];
  };
}
