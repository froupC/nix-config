{
  username,
  hostname,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./boot.nix
    ./filesystem.nix
    ./network.nix
  ];

  environment.systemPackages = [
    pkgs.sing-box
  ];

  systemd.packages = [ pkgs.sing-box ];
  systemd.services.sing-box = {
    wantedBy = [ "multi-user.target" ];
  };

  server.proxy.enable = true;

  system.stateVersion = "23.11";
}
