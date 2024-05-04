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
        protocols h2 h3
      }
    '';
  };
}
