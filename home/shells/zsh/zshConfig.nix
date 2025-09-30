{ config, pkgs, ... }:

{
  home.shell.enableZshIntegration = config.programs.zsh.enable;
  programs.zsh = {
    enable = true;

    # Set dotDir to config.xdg.configHome/zsh, but relative to config.home.homeDirectory
    dotDir =
      builtins.replaceStrings [ (config.home.homeDirectory + "/") ] [ "" ]
        "${config.xdg.configHome}/zsh";

    initContent = pkgs.lib.mkOrder 500 (
      builtins.concatStringsSep "\n" [
        # ToDo: Set in syntaxHighlighting.styles
        ''eval "${builtins.readFile ./themes/catppuccin/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh}"''
        (builtins.readFile ./setopt.zsh)
        (builtins.readFile ./bindkey.zsh)
      ]
    );

    autocd = true;
    enableCompletion = true;
    completionInit = (builtins.readFile ./zstyle-completion.zsh);

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
