{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkConditionalSet = (cond: builtins.mapAttrs (_: value: lib.mkIf cond value));
  mkHeadless = mkConditionalSet (config.system.mode != "container");
  mkDesktop = mkConditionalSet (config.system.mode == "desktop");
in
{
  options = {
    system.mode = lib.mkOption {
      default = "desktop";
      type = lib.types.enum [
        "container"
        "headless"
        "desktop"
      ];
    };
    headsets.enable = lib.mkEnableOption "Headset Control";
    headsets.chatmix = config.services.nova-chatmix.enable;
  };

  imports = [
    ./games.nix
    ./ssh.nix
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.settings.use-xdg-base-directories = true;

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
    }

    (mkHeadless {
      # Bootloader
      boot.loader = {
        timeout = 0;
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      # Enable networking
      networking.networkmanager.enable = true;

      home-manager.backupFileExtension = "backup";

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
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
        (nerd-fonts.noto.overrideAttrs {
          preInstall = "find -not -name NotoSansMNerdFont-Regular.ttf -delete";
        })
      ];

      # Enable Zsh
      # Main zsh configuration done via home-manager
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableBashCompletion = true;
      };
      users.defaultUserShell = pkgs.zsh;
      #environment.pathsToLink = [ "/share/zsh" ];

      #   services.netbird.enable = true;
    })

    (mkDesktop {
      # Enable the KDE Plasma Desktop Environment.
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;
      services.desktopManager.plasma6.notoPackage = pkgs.noto-fonts-lgc-plus;
      # Disable mouse acceleration
      services.libinput.mouse.accelProfile = "flat";

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      # Enable Bluetooth
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;

      # Install firefox.
      programs.firefox.enable = true;

      environment.systemPackages =
        with pkgs;
        lib.flatten [
          (builtins.map (value: lib.mkIf config.headsets.enable value) [
            headsetcontrol
            headset-charge-indicator
          ])
          (builtins.map (value: lib.mkIf config.services.desktopManager.plasma6.enable value) [
            kdePackages.kate
            kdePackages.filelight
            haruna
          ])
        ];

      services.udev.packages = [
        (lib.mkIf config.headsets.enable pkgs.headsetcontrol)
      ];
    })

    {
      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.05"; # Did you read the comment?
    }
  ];
}
