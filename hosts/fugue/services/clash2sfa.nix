{
  virtualisation.oci-containers.containers.clash2sfa = {
    image = "ghcr.io/xmdhs/clash2sfa:v0.13.1";
    ports = ["127.0.0.1:5149:8080"];
    volumes = [
      "clash2sfa:/server/db"
    ];
  };

  services.caddy.virtualHosts."sb.froup.cc" = {
    extraConfig = ''
      reverse_proxy http://127.0.0.1:5149
      tls /etc/ssl/certs/cloudflare.pem /etc/ssl/certs/cloudflare.key
    '';
  };
}
