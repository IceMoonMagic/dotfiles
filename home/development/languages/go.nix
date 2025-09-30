{ config, ... }:

{
  home.sessionVariables = {
    GOPATH = "${config.xdg.dataHome}/go";
    GOCACHE = "${config.xdg.cacheHome}/go";
    GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
  };
  xdg.configFile."go/telemetry/mode".text = "off 1970-01-01";
}
