{ config, pkgs, ... }:

{
  home.shell.enableZshIntegration = config.programs.zsh.enable;
  programs.zsh = {
    enable = true;
    dotDir = config.xdg.configHome + "/zsh";

    initContent = pkgs.lib.mkOrder 500 (
      builtins.concatStringsSep "\n" [
        (
          let
            catppuccin = pkgs.fetchFromGitHub {
              owner = "catppuccin";
              repo = "zsh-syntax-highlighting";
              rev = "7926c3d3e17d26b3779851a2255b95ee650bd928";
              hash = "sha256-l6tztApzYpQ2/CiKuLBf8vI2imM6vPJuFdNDSEi7T/o=";
            };
          in
          ''eval "${
            builtins.readFile (catppuccin + "/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh")
          }"''
        )
        (builtins.readFile ./bindkey.zsh)
        "autoload -U select-word-style && select-word-style Bash"
      ]
    );

    autocd = true;
    enableCompletion = true;
    completionInit = (builtins.readFile ./zstyle-completion.zsh);

    setOptions = [
      "no_beep"
      "inc_append_history"
      "numeric_glob_sort"
    ];

    history = {
      append = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      path = "${config.xdg.stateHome}/zsh/history";
    };
    historySubstringSearch = {
      enable = true;
      searchUpKey = [
        "^[[A"
        "$terminfo[kcuu1]"
      ];
      searchDownKey = [
        "^[[B"
        "$terminfo[kcud1]"
      ];
    };

    syntaxHighlighting.enable = true;
  };
}
