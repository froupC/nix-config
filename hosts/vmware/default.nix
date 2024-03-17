{
  username,
  hostname,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./impermanence.nix
  ];

  virtualisation.vmware.guest.enable = true;
  xdg.portal.enable = lib.mkForce false;
  services.greetd.enable = lib.mkForce false;

  system.stateVersion = "23.11";
}
