{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Nix
        jnoortheen.nix-ide

        # Go
        golang.go

        # Web
        esbenp.prettier-vscode
        bradlc.vscode-tailwindcss
        vue.volar
      ];
      userSettings = {
        "files.autoSave" = "onFocusChange";
        "editor.rulers" = [
          80
          120
        ];
        "editor.formatOnSave" = true;
        "editor.fontFamily" =
          "'NotoSansM Nerd Font', 'Noto Sans Mono', 'Droid Sans Mono', 'monospace', monospace";
        "terminal.external.linuxExec" = "zsh";
        "terminal.integrated.defaultProfile.linux" = "zsh";

        "[go]"."editor.defaultFormatter" = "golang.go";
        "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
        "[nix]"."editor.tabSize" = 2;
        "[python]"."editor.rulers" = [
          79
          120
        ];
        "[html]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.tabSize" = 2;
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.tabSize" = 2;
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.tabSize" = 2;
        };
        "[vue]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.tabSize" = 2;
        };
        "vue.autoInsert.dotValue" = true;
        "vue.inlayHints.missingProps" = true;
        "vue.inlayHints.optionsWrapper" = true;
        "vue.inlayHints.vBindShorthand" = true;
        "vue.server.includeLanguages" = [
          "vue"
          "ts"
        ];

      };
    };
  };
}
