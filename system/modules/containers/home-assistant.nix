{
  config,
  lib,
  ...
}:

let
  cfg = config.virtualisation.quadlets.home-assistant;
in
with lib;
{
  options.virtualisation.quadlets.home-assistant = {
    enable = mkEnableOption "Home Assistant Quadlet";
    configDir = mkOption {
      description = "The config directory, where your `configuration.yaml` is located";
      type = types.str;
      default = "/var/lib/home-assistant";
    };
    openFirewall = mkOption {
      description = "Whether to open the firewall for the specified frontend port";
      type = types.bool;
      default = true;
    };
  };
  config = {
    environment.etc."containers/systemd/home-assistant.container".text = mkIf cfg.enable ''
      [Unit]
      Description=Open source home automation that puts local control and privacy first
      Requires=network.target
      After=network.target

      [Container]
      ContainerName=homeassistant
      Image=ghcr.io/home-assistant/home-assistant:stable
      Pull=newer
      Network=host
      Volume=${cfg.configDir}:/config
      Volume=/etc/localtime:/etc/localtime:ro
      Volume=/run/dbus:/run/dbus:ro

      [Service]
      Slice=quadlets.slice
      Restart=always
    '';
    networking.firewall.allowedTCPPorts = lib.optional (cfg.enable && cfg.openFirewall) 8123;
  };
}
