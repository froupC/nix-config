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

  system.stateVersion = "23.11";
}
