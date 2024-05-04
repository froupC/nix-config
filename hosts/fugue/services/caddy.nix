{ pkgs, ...}: 
{
  nix.settings.sandbox = false;
  services.caddy = {
    enable = true;
    package = pkgs.customized_caddy;
    globalConfig = ''
      debug
      auto_https disable_certs
      servers {
        trusted_proxies cloudflare
        protocols h1 h2 h3
      }
    '';
  };
  systemd.services.caddy = {
    serviceConfig = {
      # Required to use ports < 1024
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
      TimeoutStartSec = "5m";
    };
  };
}
