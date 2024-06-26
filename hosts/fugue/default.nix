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
    ./services
  ];

  modules.secrets.server.application.enable = true;
  modules.secrets.impermanence.enable = true;

  system.stateVersion = "23.11";
}
