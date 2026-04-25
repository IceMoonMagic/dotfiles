{ pkgs, ... }:
{
  systemd.services.wine64-test = {
    serviceConfig.TimeoutStopSec = 10;
    # serviceConfig.KillMode = "mixed";
    environment = {
      WINEPREFIX = "/home/roboticat/Games/Servers/AbioticServer/pfx";
      WINEDEBUG = "-all"; # Disable wine's messages to the console
    };
    # It seems to be `winedevice.exe` that's refusing to close
    # Mixed will kill anything after the main exe exits
    # (If used in systemd.services.<name>.script, run wine through exec)
    serviceConfig.KillMode = "mixed";
    serviceConfig.ExecStart = "${pkgs.wine64}/bin/wine64 /home/roboticat/maze-game.exe --headless";
  };
}
