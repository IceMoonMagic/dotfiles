# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  /*
    # KDE Plasma
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
  */

  /*
    # Cosmic
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;
  */

  /*
    # Gnome
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
  */

  /*
    # Everything else "normally" uses LightDM
    services.xserver.displayManager.lightdm.enable = true;
    # services.desktopManager.lomiri.enable = true;
    services.xserver.desktopManager = {
      # cinnamon.enable = true;
      # mate.enable = true;
      # xfce.enable = true;
      # budgie.enable = true;
      # deepin.enable = true; # Failed
      # pantheon.enable = true;
      # cde.enable = true; # Failed
      # lxqt.enable = true;
      # lumina.enable = true;
    };
  */

  /*
    # build-vm stuff
    users.mutableUsers = false;
    users.users.user = {
      isNormalUser = true;
      password = "password";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };

    virtualisation.vmVariant = {
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        memorySize = 16386; # Use 2048MiB memory.
        cores = 6;
        qemu.options = [
          "-vga none -device qxl-vga,vgamem_mb=64,ram_size_mb=256,vram_size_mb=128,max_outputs=2"
        ];
        qemu.package = pkgs.qemu;
      };
    };
  */

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable = lib.mkForce false; # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = lib.mkForce false; # Easiest to use and most distros use this by default.

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
