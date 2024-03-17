{
  lib,
  ...
}: {
  # Disable the OpenSSH daemon.
  services.openssh.enable = lib.mkForce false;
}
