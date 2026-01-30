{ config, pkgs, ... }:

{
  imports = [ ./zsh/zshConfig.nix ];

  home.shell.enableBashIntegration = config.programs.bash.enable;
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [
      "erasedups"
      "ignoreboth"
    ];
    historyFile = "${config.xdg.stateHome}/bash_history";
  };

  programs.oh-my-posh = {
    enable = true;
    configFile = ./my_theme_ordered.omp.yaml;
  };

  programs.dircolors.enable = true;
  programs.less.enable = true;

  home.sessionVariables = {
    OMP_PALETTE = "mocha";
    EDITOR = "nano";
    GTK_USE_PORTAL = 1;
    LESS = "RSMC"; # Raw Colors and OSC 8, chop lines, verbose prompt, clear screen
    SYSTEMD_LESS = "RSMKC"; # Removes F, X (always open less, enables mouse scroll)
    # Color man pages
    #LESS_TERMCAP_mb = "$'\E[01;32m'";
    #LESS_TERMCAP_md = "$'\E[01;32m'";
    #LESS_TERMCAP_me = "$'\E[0m'";
    #LESS_TERMCAP_se = "$'\E[0m'";
    #LESS_TERMCAP_so = "$'\E[01;47;34m'";
    #LESS_TERMCAP_ue = "$'\E[0m'";
    #LESS_TERMCAP_us = "$'\E[01;36m'";
    #LESS = "-R"
  };

  home.shellAliases = {
    ls = "ls --color=auto";
    cp = "cp --archive --interactive --reflink=auto";
    df = "df --human-readable";
  };
}
