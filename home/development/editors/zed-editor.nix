{ config, pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "codebook"
      "dockerfile"
      "git_firefly"
      "html"
      "nix"
    ];
    extraPackages = [ pkgs.nixd ];
    userSettings = {
      autosave = "on_focus_change";
      disable_ai = true;
      buffer_font_size = 16;
    };
  };
}
