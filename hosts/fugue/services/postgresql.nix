{ pkgs, lib, ... }:
{
  config.services.postgresql = {
    enable = true;
    enableTCPIP = true;
    identMap = ''
        # ArbitraryMapName systemUser DBUser
        superuser_map      root      postgres
        superuser_map      postgres  postgres
        # Let other names login as themselves
        superuser_map      /^(.*)$   \1
    '';
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser   auth-method optional_ident_map
      local all       postgres peer        map=superuser_map
      local sameuser  all      peer        map=superuser_map
      #type database DBuser origin-address auth-method
      # ipv4
      host  all      all    127.0.0.1/32   trust
      host  all      all    172.18.0.1/16  trust
      # ipv6
      host  all      all    ::1/128        trust
    '';
  };

  config.services.postgresqlBackup = {
    enable = true;
    backupAll = true;
  };
}
