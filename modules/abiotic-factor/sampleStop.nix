{ pkgs, ... }:
{
  systemd.services.wine64-test = {
    serviceConfig.TimeoutStopSec = 10;
    # serviceConfig.KillMode = "mixed";
    environment = {
      WINEPREFIX = "/home/roboticat/Games/Servers/AbioticServer/pfx";
      WINEDEBUG = "-all"; # Disable wine's messages to the console
    };
    serviceConfig.ExecStart = "${pkgs.wine64}/bin/wine64 /home/roboticat/maze-game.exe --headless";
  };
}
