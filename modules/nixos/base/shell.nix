{config, lib, pkgs, ...}: {
  environment.systemPackages = [
    pkgs.grc
    pkgs.mdcat
    pkgs.chafa
  ];
}
