{
  services.vaultwarden = {
    enable = true;
    environmentFile = "/etc/vaultwarden/.env";
    config = {
      PUSH_ENABLED = true;
      DOMAIN = "https://vw.froup.cc";
      SIGNUPS_ALLOWED = false;
      SIGNUPS_VERIFY = false;
      EXPERIMENTAL_CLIENT_FEATURE_FLAGS = "fido2-vault-credentials,autofill-v2,autofill-overlay";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
    };
  };

  services.caddy.virtualHosts."vw.froup.cc" = {
    extraConfig = ''
      log {
        level INFO
        output file {$LOG_FILE} {
          roll_size 10MB
          roll_keep 10
        }
      }
      encode zstd gzip
      reverse_proxy http://127.0.0.1:8222 {
        header_up Host {host}
        header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
        header_up X-Forwarded-Proto {scheme}
        header_up X-Forwarded-Host {host}
        header_up X-Forwarded-For {remote}
        header_up X-Forwarded-Ssl {on}
      }
      tls /etc/ssl/certs/cloudflare.pem /etc/ssl/certs/cloudflare.key
    '';
  };
}
