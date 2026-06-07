{ pkgs, ... }:
{
  imports = [
    ./bluetooth.nix
    ./printing.nix
    ./audio.nix
    ./mouse.nix
    ./kde-plasma.nix
    ./browser.nix
  ];

  # Doesn't have a headless mode (github:localsend/localsend#11)
  programs.localsend.enable = true;
  environment.systemPackages = with pkgs; [
    opencloud-desktop
  ];
}
