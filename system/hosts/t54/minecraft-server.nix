{ pkgs, ... }:

let
  baseDir = "/home/roboticat/MineCraft";
  archiveDir = baseDir + "/archive";
  dataDir = baseDir + "/data";

  docker = "${pkgs.docker}/bin/docker";
  rmlint = "${pkgs.rmlint}/bin/rmlint";
  tar = "${pkgs.gnutar}/bin/tar";
  xz = "${pkgs.xz}/bin/xz";
in
{
  systemd.services.minecraft-server = {
    enable = true;
    description = "A Minecraft server for friends.";
    requires = [ "docker.service" ];
    wants = [ "network-online.target" ];
    after = [
      "docker.service"
      "network-online.target"
    ];
    script = "${docker} compose -f ${baseDir}/compose.yaml up";
    preStop = "${docker} compose -f ${baseDir}/compose.yaml down";
    wantedBy = [ "default.target" ];
  };

  systemd.services.minecraft-server-maintance = {
    enable = true;
    description = "Maintance operations for minecraft-server.service";
    requires = [ "docker.service" ];
    after = [ "docker.service" ];
    conflicts = [ "minecraft-server.service" ];
    onSuccess = [ "minecraft-server.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      now=$(date --rfc-3339=seconds)
      mkdir -p "${archiveDir}/$now"
      cd "${archiveDir}/$now"

      ${tar} -cvf world.tar.xz "${dataDir}/world" -I '${xz} -9e'
      ${tar} -cvf mods.tar.xz "${dataDir}/mods" -I '${xz} -9e'
      ${tar} --exclude="${dataDir}/mods" --exclude="${dataDir}/world" -cvf server.tar.xz "${dataDir}" -I '${xz} -9e'

      ${rmlint} -T "df" -c sh:handler=clone,reflink -o sh:rmlint.sh "${archiveDir}"
      ./rmlint.sh -d

      ${docker} compose -f ${baseDir}/compose.yaml pull
    '';
  };

  systemd.timers.minecraft-server-maintance = {
    enable = true;
    description = "Maintance operations for minecraft-server.service";
    timerConfig = {
      OnCalendar = "Mon 16:00 UTC";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
}
