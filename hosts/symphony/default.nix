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

  modules.secrets.impermanence.enable = true;
  modules.secrets.desktop.enable = true;

  system.stateVersion = "24.05";
}
