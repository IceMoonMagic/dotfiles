{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.games = {
    all = lib.mkEnableOption "All Game Stuff";
    main = lib.mkEnableOption "Steam, Heroic, MangoHud, etc.";
    mods = lib.mkEnableOption "Mod Managers";
    minecraft = lib.mkEnableOption "Prism Launcher";
    nintendo = lib.mkEnableOption "Nintendo Stuff";
  };
  config = {
    games = {
      main = lib.mkDefault config.games.all;
      mods = lib.mkDefault config.games.all;
      minecraft = lib.mkDefault config.games.all;
      nintendo = lib.mkDefault config.games.all;
    };

    programs.steam = {
      enable = config.games.main;
      package = pkgs.steam.override {
        extraEnv.MANGOHUD = true;
        extraEnv.PROTON_ENABLE_WAYLAND = 1;
      };
    };
    /*
      services.joycond.enable = true;
      services.joycond.package = pkgs.joycond.overrideAttrs (old: {
        # Without: I couldn't use the joycons' motion as non-root
        # With: Cemuhook doesn't combine them, but motion is accessable
        version = "2025-04-12";
        src = pkgs.fetchFromGitHub {
          owner = "DanielOgorchock";
          repo = "joycond";
          rev = "39d5728d41b70840342ddc116a59125b337fbde2";
          sha256 = "sha256-VT433rrgZ6ltdXLQRjtjRy7rhMl1g9dan9SRqlsCPTk=";
        };
        installPhase = old.installPhase + ''
          substituteInPlace $out/etc/udev/rules.d/72-joycond.rules --replace \
            'TAG-="uaccess"' 'TAG+="uaccess"'

          rm $out/etc/udev/rules.d/89-joycond.rules
        '';
      });
      # programs.joycond-cemuhook.enable = true;
      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
      '';
    */
    environment.systemPackages =
      let
        mkConditionalList = (cond: builtins.map (value: lib.mkIf cond value));
      in
      with pkgs;
      lib.flatten [
        (mkConditionalList config.games.main [
          steamcmd
          heroic
          mangohud
          wine64
          protontricks
          protonup-qt
        ])
        (mkConditionalList config.games.mods [
          satisfactorymodmanager
          r2modman
        ])
        (mkConditionalList config.games.minecraft [
          prismlauncher
          mcaselector
        ])
        (mkConditionalList config.games.nintendo [
          dolphin-emu
          ryubing
          sshd-rando
        ])
      ];
  };
}
