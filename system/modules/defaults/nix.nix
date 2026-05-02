{ config, lib, ... }:
{
  nix = {
    settings = {
      experimental-features = lib.mkDefault [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = lib.mkDefault true;
      auto-optimise-store = lib.mkDefault true;
    };
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      persistent = lib.mkDefault true;
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.system = lib.mkDefault config.nixpkgs.hostPlatform;
  nixpkgs.config.allowUnfree = lib.mkDefault true;
}
