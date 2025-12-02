{ pkgs, ... }:

{
  systemd.services.minecraft = {
    enable = true;
    description = "A Minecraft server for friends.";
    requires = [ "docker.service" ];
    wants = [ "network-online.target" ];
    after = [
      "docker.service"
      "network-online.target"
    ];
    script = "${pkgs.docker}/bin/docker compose -f /home/roboticat/MineCraft/compose.yaml up";
    preStop = "${pkgs.docker}/bin/docker compose -f /home/roboticat/MineCraft/compose.yaml down";
    wantedBy = [ "default.target" ];
  };
}
