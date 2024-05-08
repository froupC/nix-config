{
  containers.freshrss = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "172.18.0.1";
    localAddress = "172.18.0.2";

    bindMounts = {
      "/var/lib/freshrss" = {
        hostPath = "/var/lib/freshrss";
        isReadOnly = false;
      };
      "/run/secrets/freshrss" = {
        hostPath = "/var/lib/freshrss";
        isReadOnly = true;
      };
    };

    forwardPorts = [
      {
        containerPort = 80;
        hostPort = 7349;
      }
    ];

    config = { config, pkgs, lib, ... }: {
      services.freshrss = {
        enable = true;
        baseUrl = "https://read.froup.cc";
        dataDir = "/var/lib/freshrss";
        defaultUser = "froup";
        passwordFile = "/run/secrets/freshrss";
      };

      system.stateVersion = "23.11";

      config.nixpkgs.pkgs = pkgs;

      networking.useHostResolvConf = true;
    };
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
        header_up X-Forwarded-Prefix "/freshrss/"
      }
      tls /etc/ssl/certs/cloudflare.pem /etc/ssl/certs/cloudflare.key
    '';
  };
}
