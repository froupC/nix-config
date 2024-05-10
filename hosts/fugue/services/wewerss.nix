{
  services.caddy.virtualHosts."wewe.froup.cc" = {
    extraConfig = ''
      reverse_proxy http://127.0.0.1:33255 {
        header_up Host {host}
        header_up Connection ""
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
