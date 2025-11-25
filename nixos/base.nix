{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader = pkgs.lib.mkDefault {
    timeout = 0;
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  #   boot.loader.grub.enable = true;
  #   boot.loader.grub.theme = pkgs.fetchzip {
  #     url = "https://github.com/AdisonCavani/distro-grub-themes/raw/master/themes/nixos.tar";
  #     hash = "sha256-ivi68lkV2mypf99BOEnRiTpc4bqupfGJR7Q0Fm898kM=";
  #     stripRoot = false;
  #   };
  #   boot.loader.grub.device = "/dev/nvme0n1p1";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.use-xdg-base-directories = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.enable = pkgs.lib.mkForce false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  home-manager.backupFileExtension = "backup";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    cloc
    btdu
    compsize
    docker-compose
    fastfetch
    tree
    rmlint
    nixfmt-rfc-style
    p7zip
    unrar
    #     unrar-free
    nerd-fonts.noto
  ];

  # Enable Zsh
  # Main zsh configuration done via home-manager
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableBashCompletion = true;
  users.defaultUserShell = pkgs.zsh;
  #environment.pathsToLink = [ "/share/zsh" ];

  #   services.netbird.enable = true;
  #   systemd.sockets.sshd = {
  #     after = [ "netbird.service" ];
  #     bindsTo = [ "netbird.service" ];
  #     upheldBy = [ "netbird.service" ];
  #   };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = false;
    # If false: change netbird section to service instead of socket
    startWhenNeeded = true;
    # Only listen on NetBird IP
    #listenAddresses = [ { addr = "100.79.185.174"; } ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  virtualisation.containers.enable = false;
  virtualisation.podman = {
    enable = false;
    defaultNetwork.settings.dns_enable = true;
    #     storageDriver = "btrfs";
    #     rootless = {
    #       enable = true;
    #       setSocketVariable = true;
    #     };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
