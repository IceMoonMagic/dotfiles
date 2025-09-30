{ config, lib, ... }:

{
  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    NODE_REPL_HISTORY = "${config.xdg.stateHome}/node_repl_history";
  };
  home.shellAliases = {
    yarn = "yarn --use-yarnrc \"${config.xdg.configHome}/yarn/config\"";
  };

  home.activation.yarn = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d ${config.xdg.configHome}/yarn ]; then
      run mkdir $VERBOSE_ARG ${config.xdg.configHome}/yarn
    fi
    if [ ! -e $ "${config.xdg.configHome}/yarn/config" ]; then
      run touch $VERBOSE_ARG "${config.xdg.configHome}/yarn/config"
    fi
  '';
}
