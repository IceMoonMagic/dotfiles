{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
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
  environment.systemPackages = with pkgs; [
    steamcmd
    heroic
    mangohud
    wine64
    protontricks
    protonup-qt
    satisfactorymodmanager
    r2modman
    dolphin-emu
    ryubing
    sshd-rando
  ];
}
