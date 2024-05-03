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

  system.stateVersion = "23.11";
}
