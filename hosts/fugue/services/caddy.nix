{
  nix.settings.sandbox = false;
  # services.caddy = {
  #   enable = false;
  #   globalConfig = ''
  #     debug
  #     auto_https disable_certs
  #     servers {
  #       trusted_proxies cloudflare
  #       protocols h2 h3
  #     }
  #   '';
  # };
}
