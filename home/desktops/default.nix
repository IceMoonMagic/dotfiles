{ config, pkgs, ... }:

{
  # imports = [ ./kde-plasma.nix ];

  home.packages = with pkgs; [
    mission-center
    helvum
  ];

  xdg.dataFile."user-places.xbel".source = pkgs.substitute {
    src = ./user-places.xbel;
    substitutions = [
      "--replace-quiet"
      "/home/roboticat"
      "${config.home.homeDirectory}"
    ];
  };
}
