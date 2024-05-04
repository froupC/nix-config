{
  lib,
  config,
  pkgs,
  agenix,
  username,
  mysecrets,
  ...
}: let
  cfg = config.modules.secrets;

  noaccess = {
    mode = "0000";
    owner = "root";
  };
  high_security = {
    mode = "0500";
    owner = "root";
  };
  user_readable = {
    mode = "0500";
    owner = username;
  };
  in
{
  imports = [
    agenix.nixosModules.default
  ];

  options.modules.secrets = with lib; {
    desktop.enable = mkEnableOption "NixOS Secrets for Desktops";

    server.proxy.enable = mkEnableOption "NixOS Secrets for Proxy Servers";
    server.application.enable = mkEnableOption "NixOS Secrets for Application Servers";

    impermanence.enable = mkEnableOption "whether use impermanence and ephemeral root file system";
  };

  config = with lib; (mkMerge [
    {
      environment.systemPackages = [
        agenix.packages."${pkgs.system}".default
      ];

      age.identityPaths =
        if cfg.impermanence.enable
        then [
          # To decrypt secrets on boot, this key should exists when the system is booting,
          # so we should use the real key file path(prefixed by `/persistent/`) here, instead of the path mounted by impermanence.
          "/nix/persistent/etc/ssh/ssh_host_ed25519_key" # Linux
        ]
        else [
          "/etc/ssh/ssh_host_ed25519_key"
        ];

      assertions = [
        {
          assertion =
            !(cfg.desktop.enable
              && (
                cfg.server.application.enable
                || cfg.server.proxy.enable
              ));
          message = "Enable either desktop or server's secrets, not both!";
        }
      ];
    }

    (mkIf cfg.desktop.enable {
      age.secrets = {
        "nix-access-tokens" =
          {
            file = "${mysecrets}/nix-access-tokens.age";
          }
          // high_security;
      };
    })

    (mkIf cfg.server.proxy.enable {
      age.secrets = {
        "sing-box-server" = {
          file = "${mysecrets}/sing-box-server.age";
        } // high_security;
        "sb-cert" = {
          file = "${mysecrets}/sb-cert.age";
        } // high_security;
        "sb-key" = {
          file = "${mysecrets}/sb-key.age";
        } // high_security;
      };

      environment.etc = {
        "sing-box/config.json" = {
          source = config.age.secrets."sing-box-server".path;
          mode = "0500";
          user = "root";
        };
        "cert/cert.pem" = {
          source = config.age.secrets."sb-cert".path;
          mode = "0500";
          user = "root";
        };
        "cert/key.pem" = {
          source = config.age.secrets."sb-key".path;
          mode = "0500";
          user = "root";
        };
      };
    })

    (mkIf cfg.server.application.enable {
      age.secrets = {
        "cf-cert" = {
          file = "${mysecrets}/cf-cert.age";
        } // high_security;
        "cf-key" = {
          file = "${mysecrets}/cf-key.age";
        } // high_security;
      };

      environment.etc = {
        "ssl/certs/cloudflare.pem" = {
          source = config.age.secrets."cf-cert".path;
          mode = "0440";
          user = "root";
          group = "caddy";
        };
        "ssl/certs/cloudflare.key" = {
          source = config.age.secrets."cf-key".path;
          mode = "0440";
          user = "root";
          group = "caddy";
        };
      };
    })
  ]);
}
