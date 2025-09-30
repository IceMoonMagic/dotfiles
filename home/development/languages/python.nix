{ config, ... }:

{
  home.sessionVariables = {
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
    PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
    PYTHONUSERBASE = "${config.xdg.dataHome}/python";
    PYTHON_EGG_CACHE = "${config.xdg.cacheHome}/python-eggs";
  };
}
