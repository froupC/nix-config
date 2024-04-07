{
  username,
  hostname,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./boot.nix
    ./filesystem.nix
    ./network.nix
  ];

  zramSwap.enable = lib.mkForce false;

  environment.systemPackages = [
    pkgs.sing-box
  ];

  systemd.packages = [ pkgs.sing-box ];
  systemd.services.sing-box = {
    wantedBy = [ "multi-user.target" ];
  };

  modules.secrets.server.proxy.enable = true;

  system.stateVersion = "23.11";
}
