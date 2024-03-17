{
  username,
  hostname,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.unstable.sing-box
  ];

  system.stateVersion = "23.11";
}
