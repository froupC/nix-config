{
  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    config = {
      LOG_LEVEL = "debug";
      LISTEN_ADDR= "127.0.0.1:7349";
      BASE_URL = "https://read.froup.cc/";
      CREATE_ADMIN = 1;
      RUN_MIGRATIONS = 1;
    };
    adminCredentialsFile = "/etc/miniflux/admin-credentials";
  };

  services.caddy.virtualHosts."read.froup.cc" = {
    extraConfig = ''
      reverse_proxy http://127.0.0.1:7349 {
        header_up Host {host}
        header_up X-Real-IP {remote}
        header_up X-Forwarded-Proto {scheme}
        header_up X-Forwarded-Host {host}
        header_up X-Forwarded-For {remote}
        header_up X-Forwarded-Ssl {on}
      }
      tls /etc/ssl/certs/cloudflare.pem /etc/ssl/certs/cloudflare.key
    '';
  };
}
