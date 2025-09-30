{ config, lib, ... }:

{
  home.sessionVariables = {
    SQLITE_HISTORY = "${config.xdg.dataHome}/sqlite_history";

    PSQLRC = "${config.xdg.configHome}/pg/psqlrc";
    PSQL_HISTORY = "${config.xdg.stateHome}/psql_history";
    PGPASSFILE = "${config.xdg.configHome}/pg/pgpass";
    #PGSERVICEFILE = "${config.xdg.configHome}/pg/pg_service.conf";
    # configHome/pg needs to be manually created
  };

  home.activation.postgres = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d ${config.xdg.configHome}/pg ]; then
      run mkdir $VERBOSE_ARG ${config.xdg.configHome}/pg
    fi
  '';
}
