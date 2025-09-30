{ config, pkgs, ... }:

{
  home.packages = [ pkgs.ludusavi ];
  xdg.configFile."ludusavi/config.yaml".source = ./ludusavi-config.yaml;
  systemd.user.services = {
    ludusavi-backup = {
      Unit.Desciption = "Ludusavi backup";
      Service.ExecStart = "${pkgs.ludusavi}/bin/ludusavi backup --force";
    };
  };
  systemd.user.timers = {
    ludusavi-backup = {
      Unit = {
        Description = "Ludusavi backup timer";
      };

      Timer = {
        OnCalendar = "*-*-* 00:00:00";
        Unit = config.systemd.user.units.ludusavi-backup;
      };
    };
  };
}
