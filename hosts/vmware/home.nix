{
  nix-index-database,
  ...
}: {
  imports = [
    nix-index-database.hmModules.nix-index
    ../../home/desktop.nix
  ];

  # modules.desktop.hyprland.enable = true; # GPU issues; don't want to solve
}
