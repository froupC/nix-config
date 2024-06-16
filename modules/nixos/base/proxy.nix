{ config, lib, pkgs, modulesPath, utils, ... }: 
let
  cfg = config.services.sing-box;
in {
  disabledModules = [
    # (modulesPath + "services/networking/sing-box.nix")
    "services/networking/sing-box.nix"
  ];

  options = {
    services.sing-box = {
      enable = lib.mkEnableOption "sing-box universal proxy platform";

      package = lib.mkPackageOption pkgs "sing-box" { };

      configUrlFilePath = lib.mkOption {
        type = lib.types.path;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sing-box
    ];
    systemd.services.sing-box = {
      preStart = ''
        umask 0077
        mkdir -p /etc/sing-box
        cat ${cfg.configUrlFilePath} | xargs curl -o "/etc/sing-box/config.json"
      '';
      wantedBy = [ "multi-user.target" ];
    };
  };
}
